require 'templating'
namespace :templates do
  desc 'Compile Haml Templates for Javascript'
  task :compile => :environment do
    Templating.compile
  end
end
