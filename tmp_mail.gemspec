$:.push File.expand_path("../lib", __FILE__)
require "tmp_mail/version"

Gem::Specification.new do |s|
  s.name         = "tmp_mail"
  s.summary      = "Temporary Email"
  s.description  = "Temporary email for programmers."
  s.homepage     = "http://notfinishedyet.com"
  s.version      = TmpMail::VERSION
  s.platform     = Gem::Platform::RUBY
  s.authors      = [ "Dan Knox", "Three Dot Loft LLC" ]
  s.email        = [ "dknox@threedotloft.com" ]

  s.rubyforge_project = "tmp_mail"

  s.files        = Dir["{lib,bin,spec}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.md", "CHANGELOG.md"]
  s.executables  = []
  s.require_path = 'lib'

  s.add_dependency "mail"
  s.add_dependency "mailman"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
