require 'rake/extensiontask'
spec = Gem::Specification.load('object_model.gemspec')
Rake::ExtensionTask.new('object_model', spec)
Rake::ExtensionTask.new('black_magic', spec)


desc 'Try: FuckingAround.times2 123'
task console: :compile do
  sh 'pry -r ./lib/object_model'
end
