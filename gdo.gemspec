
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "gdo"
  spec.version       = 1.00
  spec.authors       = ["gizmore"]
  spec.email         = ["gizmore@wechall.net"]

  spec.summary       = %q{Gizmore Data Objects for ruby}
  spec.description   = %q{From scratch implementation of GWF/GDO. No rails or active actions here. Almost no dependencies.}
  spec.homepage      = "https://github.com/ruby-gdo/gdo"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
#  if spec.respond_to?(:metadata)
#    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
#  else
 #   raise "RubyGems 2.0 or newer is required to protect against " \
 #     "public gem pushes."
 # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  # spec.bindir        = "bin"
  # spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.executables   = ["gdo"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "byebug", "~> 10.0"

  spec.add_dependency "bcrypt", "~> 3.1"
  spec.add_dependency "mysql2", "~> 0.5"
  spec.add_dependency "mail", "~> 2.7"
#  spec.add_dependency "memcached", "~> 1.8"
end
