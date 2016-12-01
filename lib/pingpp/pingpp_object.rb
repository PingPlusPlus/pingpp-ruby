module Pingpp
  class PingppObject
    include Enumerable

    @@permanent_attributes = Set.new([:id])

    # The default :id method is deprecated and isn't useful to us
    if method_defined?(:id)
      undef :id
    end

    def initialize(id=nil, opts={})
      id, @retrieve_params = Util.normalize_id(id)
      @opts = Util.normalize_opts(opts)
      @original_values = {}
      @values = {}
      # This really belongs in APIResource, but not putting it there allows us
      # to have a unified inspect method
      @unsaved_values = Set.new
      @transient_values = Set.new
      @values[:id] = id if id
    end

    def self.construct_from(values, opts={})
      values = Pingpp::Util.symbolize_names(values)
      self.new(values[:id]).send(:initialize_from, values, opts)
    end

    def ==(other)
      other.is_a?(PingppObject) && @values == other.instance_variable_get(:@values)
    end

    def to_s(*args)
      JSON.pretty_generate(@values)
    end

    def inspect
      id_string = (self.respond_to?(:id) && !self.id.nil?) ? " id=#{self.id}" : ""
      "#<#{self.class}:0x#{self.object_id.to_s(16)}#{id_string}> JSON: " + JSON.pretty_generate(@values)
    end

    def refresh_from(values, opts, partial=false)
      initialize_from(values, opts, partial)
    end
    extend Gem::Deprecate
    deprecate :refresh_from, "#initialize_from", 2017, 01

    def [](k)
      @values[k.to_sym]
    end

    def []=(k, v)
      send(:"#{k}=", v)
    end

    def keys
      @values.keys
    end

    def values
      @values.values
    end

    def to_json(*a)
      JSON.generate(@values)
    end

    def as_json(*a)
      @values.as_json(*a)
    end

    def to_hash
      @values.inject({}) do |acc, (key, value)|
        acc[key] = value.respond_to?(:to_hash) ? value.to_hash : value
        acc
      end
    end

    def each(&blk)
      @values.each(&blk)
    end

    def _dump(level)
      Marshal.dump([@values, @opts])
    end

    def self._load(args)
      values, opts = Marshal.load(args)
      construct_from(values, opts)
    end

    if RUBY_VERSION < '1.9.2'
      def respond_to?(symbol)
        @values.has_key?(symbol) || super
      end
    end

    def serialize_params(options = {})
      update_hash = {}

      @values.each do |k, v|
        unsaved = @unsaved_values.include?(k)
        if options[:force] || unsaved || v.is_a?(PingppObject)
          update_hash[k.to_sym] =
            serialize_params_value(@values[k], @original_values[k], unsaved, options[:force])
        end
      end

      update_hash.reject! { |_, v| v == nil }

      update_hash
    end

    protected

    def metaclass
      class << self; self; end
    end

    def protected_fields
      []
    end

    def remove_accessors(keys)
      f = protected_fields
      metaclass.instance_eval do
        keys.each do |k|
          next if f.include?(k)
          next if @@permanent_attributes.include?(k)
          k_eq = :"#{k}="
          remove_method(k) if method_defined?(k)
          remove_method(k_eq) if method_defined?(k_eq)
        end
      end
    end

    def add_accessors(keys, values)
      f = protected_fields
      metaclass.instance_eval do
        keys.each do |k|
          next if f.include?(k)
          next if @@permanent_attributes.include?(k)
          k_eq = :"#{k}="
          define_method(k) { @values[k] }
          define_method(k_eq) do |v|
            if v == ""
              raise ArgumentError.new(
                "You cannot set #{k} to an empty string." +
                "We interpret empty strings as nil in requests." +
                "You may set #{self}.#{k} = nil to delete the property.")
            end
            @values[k] = Util.convert_to_pingpp_object(v, @opts)
            dirty_value!(@values[k])
            @unsaved_values.add(k)
          end

          if [FalseClass, TrueClass].include?(values[k].class)
            k_bool = :"#{k}?"
            define_method(k_bool) { @values[k] }
          end
        end
      end
    end

    def method_missing(name, *args)
      # TODO: only allow setting in updateable classes.
      if name.to_s.end_with?('=')
        attr = name.to_s[0...-1].to_sym
        add_accessors([attr], {})
        begin
          mth = method(name)
        rescue NameError
          raise NoMethodError.new("Cannot set #{attr} on this object. HINT: you can't set: #{@@permanent_attributes.to_a.join(', ')}")
        end
        return mth.call(args[0])
      else
        return @values[name] if @values.has_key?(name)
      end

      begin
        super
      rescue NoMethodError => e
        if @transient_values.include?(name)
          raise NoMethodError.new(e.message + ".  HINT: The '#{name}' attribute was set in the past, however.  It was then wiped when refreshing the object with the result returned by Pingpp's API, probably as a result of a save().  The attributes currently available on this object are: #{@values.keys.join(', ')}")
        else
          raise
        end
      end
    end

    def respond_to_missing?(symbol, include_private = false)
      @values && @values.has_key?(symbol) || super
    end

    def update_attributes(values, opts = {}, method_options = {})
      dirty = method_options.fetch(:dirty, true)
      values.each do |k, v|
        add_accessors([k], values) unless metaclass.method_defined?(k.to_sym)
        @values[k] = Util.convert_to_pingpp_object(v, opts)
        dirty_value!(@values[k]) if dirty
        @unsaved_values.add(k)
      end
    end

    def initialize_from(values, opts, partial=false)
      @opts = Util.normalize_opts(opts)
      @original_values = Marshal.load(Marshal.dump(values)) # deep copy

      removed = partial ? Set.new : Set.new(@values.keys - values.keys)
      added = Set.new(values.keys - @values.keys)

      instance_eval do
        remove_accessors(removed)
        add_accessors(added, values)
      end

      removed.each do |k|
        @values.delete(k)
        @transient_values.add(k)
        @unsaved_values.delete(k)
      end

      update_attributes(values, opts, :dirty => false)
      values.each do |k, _|
        @transient_values.delete(k)
        @unsaved_values.delete(k)
      end

      self
    end

    def serialize_params_value(value, original, unsaved, force)
      case true
      when value == nil
        ''

      when value.is_a?(APIResource) && !value.save_with_parent
        nil

      when value.is_a?(Array)
        update = value.map { |v| serialize_params_value(v, nil, true, force) }

        # This prevents an array that's unchanged from being resent.
        if update != serialize_params_value(original, nil, true, force)
          update
        else
          nil
        end

      when value.is_a?(Hash)
        Util.convert_to_pingpp_object(value, @opts).serialize_params

      when value.is_a?(PingppObject)
        update = value.serialize_params(:force => force)
        update = empty_values(original).merge(update) if original && unsaved

        update

      else
        value
      end
    end

    private

    def dirty_value!(value)
      case value
      when Array
        value.map { |v| dirty_value!(v) }
      when PingppObject
        value.dirty!
      end
    end

    def empty_values(obj)
      values = case obj
      when Hash         then obj
      when PingppObject then obj.instance_variable_get(:@values)
      else
        raise ArgumentError, "#empty_values got unexpected object type: #{obj.class.name}"
      end

      values.inject({}) do |update, (k, _)|
        update[k] = ''
        update
      end
    end
  end
end
