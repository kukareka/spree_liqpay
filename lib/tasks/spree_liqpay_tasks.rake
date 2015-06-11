desc 'Prepare test app'
task :setup do
  Rake::Task['app:spree:install:migrations'].invoke
  Rake::Task['app:db:create'].invoke
  Rake::Task['app:db:migrate'].invoke
  Rake::Task['app:db:seed'].invoke
  Rake::Task['app:assets:precompile'].invoke
end