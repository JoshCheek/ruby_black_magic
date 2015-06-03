require 'rake/extensiontask'
spec = Gem::Specification.load('object_model.gemspec')
Rake::ExtensionTask.new('black_magic', spec)

task default: :test

desc 'Run tests'
task test: :compile do
  sh 'mrspec'
end
