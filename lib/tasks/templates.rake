require 'rubyception/templating'
namespace :templates do
  desc 'Compile Haml Templates for Javascript'
  task :compile => :environment do
    Rubyception::Templating.compile
  end
end
