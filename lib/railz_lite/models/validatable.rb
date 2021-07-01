module Validatable
  class Validator
    def validation_callbacks
      @validation_callbacks ||= []
    end

    def validate(method_name, *args)
      @validation_callbacks << method_name
    end

    def save
      @validation_callbacks.each { |method| send(:method) }
    end
  end
end
