Gem::Specification.new do |s|
  s.name = %q{optimus-prime}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Pat Nakajima"]
  s.date = %q{2009-07-10}
  s.email = %q{patnakajima@gmail.com}
  s.files = ["lib/optimus_prime/command.rb", "lib/optimus_prime/optor.rb", "lib/optimus_prime.rb"]
  s.homepage = %q{http://github.com/nakajima/optimus-prime}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Easy command line options.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
