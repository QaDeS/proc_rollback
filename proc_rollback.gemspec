require File.expand_path("../lib/proc_rollback/version", __FILE__)

Gem::Specification.new do |s|
  s.name = "proc_rollback"
  s.version = ProcRollback::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["Michael Klaus"]
  s.email = ["Michael.Klaus@gmx.net"]
  s.homepage = "http://github.com/QaDeS/proc_rollback"
  s.summary = "Lets you rollback the side effects of a Proc by resetting the modified instance variables."
  s.description = "Rollback the side effects of a Proc by resetting the modified instance variables. Does not work on native code!"

  s.required_rubygems_version = ">= 1.3.6"

  s.rubyforge_project = "proc_rollback"  # as if...

  # If you have other dependencies, add them here
  s.add_development_dependency "rspec"

  s.files = Dir["{lib,spec}/**/*.rb", "LICENSE", "Gemfile"]
  s.require_path = 'lib'
end
