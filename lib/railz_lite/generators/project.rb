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

      def add_welcome_view
        template('welcome_view.index.html.erb', "#{project_name}/views/welcome_controller/welcome_view.index.html.erb")
      end

      def add_public
        copy_file('winter_fox_large.jpg', "#{project_name}/public")
      end

      def create_sql_file
        create_file("#{project_name}/db/app.sql")
      end
    end
  end
end
