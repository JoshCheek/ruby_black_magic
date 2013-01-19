require 'rake/extensiontask'
spec = Gem::Specification.load('fucking-around.gemspec')
Rake::ExtensionTask.new('fucking_around', spec)


desc 'Try: FuckingAround.times2 123'
task console: :compile do
  sh 'irb -r ./lib/fucking_around'
end

