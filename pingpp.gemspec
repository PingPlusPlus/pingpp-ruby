$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'pingpp/version'

spec = Gem::Specification.new do |s|
  s.name = 'pingpp'
  s.version = Pingpp::VERSION
  s.summary = 'Ruby bindings for the PingPlusPlus API'
  s.description = 'PingPlusPlus is the easiest way to accept payments online.  See https://pingxx.com for details.'
  s.authors = ['Xufeng Weng']
  s.email = ['xufeng.weng@pingxx.com']
  s.homepage = 'https://www.pingxx.com/api'
  s.license = 'MIT'

  s.add_dependency('rest-client', '>= 1.4', '< 4.0')

  s.files = Dir['lib/**/*.{rb,crt}'] + Dir['test/**/*.rb']
  s.test_files = Dir['test/**/*.rb']
  s.require_paths = ['lib']
end
