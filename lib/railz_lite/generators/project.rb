require 'thor/group'

module RailzLite
  module Generators
    class Project < Thor::Group
      include Thor::Actions
      argument :project_name, type: :string
      
      def self.source_root
        File.dirname(__FILE__) + "/templates"
      end

      def self.destination_root
        Dir.pwd
      end
      
      def add_controllers
        empty_directory("#{project_name}/controllers")
      end

      def add_models
        empty_directory("#{project_name}/models")
      end

      def add_server
        template('server.rb', "#{project_name}/config/server.rb")
      end

      def add_views
        empty_directory("#{project_name}/views")
      end

      def add_public
        empty_directory("#{project_name}/public")
      end
    end
  end
end
