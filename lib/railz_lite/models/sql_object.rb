require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'

class SQLObject
  def self.columns
    @columns ||= DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
    SQL
    @columns.first.map(&:to_sym)
  end

  def self.finalize!
    columns.each do |name|
      define_method(name) do
        attributes[name]
      end
      define_method("#{name}=") do |val|
        attributes[name] = val
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name || self.name.tableize 
  end

  def self.all
    results = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
    SQL
    parse_all(results)
  end

  def self.parse_all(results)
     results.map { |attrs| self.new(attrs) }
  end

  def self.find(id)
    target = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        ID = ?
    SQL

    return nil if target.empty?
    self.new(target.first)
  end

  def initialize(params = {})
    params.each do |attr_name, val|
      name_sym = attr_name.to_sym
      raise Exception.new "unknown attribute '#{attr_name}'" unless self.class.columns.include?(name_sym)
      send("#{name_sym}=", val)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map { |attr| send(attr) }
  end

  def insert
    DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO
        #{self.class.table_name}(#{self.class.columns.join(',')})
      VALUES
        (#{(["?"] * attribute_values.length).join(',')})
    SQL
    self.id = DBConnection.last_insert_row_id
  end

  def update
    DBConnection.execute(<<-SQL, *attribute_values, self.id)
      UPDATE
        #{self.class.table_name}
      SET
        #{self.class.columns.map { |attr_name| "#{attr_name}=?"}.join(',')}
      WHERE
        id = ?
    SQL
  end

  def save
    if self.id.nil?
      insert
    else
      update
    end
  end
end
