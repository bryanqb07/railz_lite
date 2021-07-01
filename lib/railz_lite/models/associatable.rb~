require_relative '02_searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    foreign_key_sym = "#{name}_id".to_sym
    class_name_val = name.to_s.camelcase.singularize
    send("primary_key=", :id)
    send("foreign_key=", foreign_key_sym)
    send("class_name=", class_name_val)

    options.each do |attr, val|
      send("#{attr}=", val)
    end
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    foreign_key_sym = "#{self_class_name.underscore}_id".to_sym
    class_name_val = name.to_s.camelcase.singularize

    send("primary_key=", :id)
    send("foreign_key=", foreign_key_sym)
    send("class_name=", class_name_val)

    options.each do |attr, val|
      send("#{attr}=", val)
    end
  end
end

module Associatable
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    assoc_options[name] = options
    define_method(name) do
     foreign_key = send(options.foreign_key)
     primary_key = options.primary_key
     params = [[primary_key, foreign_key]].to_h
     options.model_class.where(params).first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.name, options)
    define_method(name) do
     foreign_key = options.foreign_key
     primary_key = send(options.primary_key)
     params = [[foreign_key, primary_key]].to_h
     options.model_class.where(params)
    end
  end

  def assoc_options
    @assoc_options ||= {}
    @assoc_options
  end
end

class SQLObject
  extend Associatable
end
