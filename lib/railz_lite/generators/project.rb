require 'thor/group'

module RailzLite
  module Generators
    class Project < Thor::Group
      include Thor::Actions
      
      def self.source_root
        File.dirname(__FILE__) + "/templates"
      end
      
      def add_controllers
        template("application_controller.rb", "/controllers/application_controller.rb")
      end

      def add_models
        template("application_model.rb", "/models/application_model.rb")
      end

      def add_server
        template("server.rb", "/config/server.rb")
      end

      def add_views
        empty_directory("/views")
      end

      def add_public
        empty_directory("/public")
      end
    end
  end
end
