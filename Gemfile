source "https://rubygems.org"

gemspec

group :development do
  gem 'rake'
  gem 'mocha', '~> 0.13.2'
  gem 'shoulda-context'
  gem 'test-unit'
  gem 'pry'

  if Gem::Version.new(RUBY_VERSION.dup) < Gem::Version.new('2.0.0')
    gem 'rest-client', '1.8.0'
    gem 'mime-types', '2.6.2'
  end
end
