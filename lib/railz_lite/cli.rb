require 'thor'
require 'railz_lite'
require 'railz_lite/generators/project'

module RailzLite
  class CLI < Thor
    desc 'new', 'Generates a new RailzLite project'
    def new(project_name)
      RailzLite::Generators::Project.start([project_name])
    end

    desc 'server', 'Starts up a puma server within RailzLite project'
    def server
      puts "hello world"
    end
  end
end
