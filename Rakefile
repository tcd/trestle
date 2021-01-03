require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "yard"

YARD::Rake::YardocTask.new do |t|
  t.files = [
    "app/**/*.rb",
    "lib/**/*.rb",
  ]
  t.options = [
    "--charset=utf-8",
    "--markup-provider=redcarpet", # Better markdown support
    "--markup=markdown", # Better markdown support
    "--readme=README.md",
    "--private", # Document private methods
    "--protected", # Document protected methods
    "--exclude=app/admin/mixins.rb",
    # "--template-path=#{Rails.root.join('tooling/yard/doc-src/templates')}",
  ]
  # t.stats_options = ["--list-undoc"] # optional
end

RSpec::Core::RakeTask.new(:spec)

task(default: :spec)
