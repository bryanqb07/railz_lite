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
      file =  File.join(Dir.pwd, 'config', 'server.rb')
      if File.exist?(file)
        system('ruby', file)
      else
        raise "File not found at #{file}"
      end
    end
  end
end
