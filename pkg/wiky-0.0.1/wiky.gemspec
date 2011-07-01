# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{wiky}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Tanin Na Nakorn}]
  s.date = %q{2011-07-01}
  s.description = %q{A Ruby library to convert Wiki markup to HTML}
  s.email = %q{tanin47@gmail.com}
  s.extra_rdoc_files = [%q{lib/wiky.rb}]
  s.files = [%q{Rakefile}, %q{lib/wiky.rb}, %q{Manifest}, %q{wiky.gemspec}]
  s.homepage = %q{http://www.github.com/tanin47/wiky}
  s.rdoc_options = [%q{--line-numbers}, %q{--inline-source}, %q{--title}, %q{Wiky}]
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{wiky}
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{A Ruby library to convert Wiki markup to HTML}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
