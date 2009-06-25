require 'rubygems'
require 'rake/gempackagetask'
PKG_NAME = "arsecurity"
PKG_VERSION = "0.1.3"
PKG_FILE_NAME = "#{PKG_NAME}-#{PKG_VERSION}"
PKG_FILES = FileList[
  '[A-Z]*',
  'lib/**/*'
]
spec = Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.summary = "A security component for Activerecord"
  s.name = PKG_NAME
  s.version = PKG_VERSION
  s.require_path = 'lib'
  s.homepage = %q{http://arsecurity.rubyforge.org/}
  s.rubyforge_project = 'Activerecord Security'
  s.has_rdoc = false
  s.authors = ["Leon Li"]
  s.email = "scorpio_leon@hotmail.com"
  s.files = PKG_FILES
  s.description = <<-EOF
    A security component for Activerecord, it can manage CRUD permissions with attribute level by configuration, you can implement RBAC easily with it. It depend on the AOP framework Rinter(Rinterceptor) and the OO query tool Rquerypad(Optinal)
  s.add_dependency('rinter', '>= 0.1.0')
  EOF
end
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end
