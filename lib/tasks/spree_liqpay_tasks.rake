desc 'Prepare test app database'
task :setup do
  Rake::Task['app:spree:install:migrations'].invoke
  Rake::Task['app:db:create'].invoke
  Rake::Task['app:db:migrate'].invoke
  Rake::Task['app:db:seed'].invoke
end