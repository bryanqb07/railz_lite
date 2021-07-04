require 'sqlite3'
require 'pg'

class SQLite3Wrapper
  def initialize(db_file_name)
    @db = SQLite3::Database.new(db_file_name)
    @db.results_as_hash = true
    @db.type_translation = true

    @db
  end

  def execute(*args)
    @db.execute(*args)
  end

  def execute2(*args)
    @db.execute2(*args)
  end

  def insert(*args)
    execute(*args)
    last_insert_row_id
  end

  private

  def self.last_insert_row_id
    @db.last_insert_row_id
  end
end


class PGWrapper
  def initialize(db_name)
    @db = PG::Connection.connect(dbname: db_name)
    @db.type_map_for_results = PG::BasicTypeMapForResults.new(@db) # converts pgsql strings to ruby type
    @db
  end

  def execute(sql, *args)
    converted_sql = convert_escaped_question_marks(sql)
    @db.exec_params(converted_sql, args).to_a
  end

  def execute2(sql, *args)
    converted_sql = convert_escaped_question_marks(sql)
    result = @db.exec_params(converted_sql, args) 
    [result.fields, result.to_a]
  end

  def insert(sql, *args)
    sql.insert(sql.index(';'), ' RETURNING ID')
    converted_sql = convert_escaped_question_marks(sql)
    result = @db.exec_params(converted_sql, args)
    result.to_a.first['id']
  end


  private

  # for pgsql, SELECT * FROM films WHERE x = ?;  must be converted to SELECT * FROM films WHERE x = $1;
  def convert_escaped_question_marks(sql)
    converted_sql = ""
    index = 1
    sql.each_char do |char|
      if char == '?'
        converted_sql += "$#{index}"
        index += 1
      else
        converted_sql += char
      end
    end
    converted_sql
  end

end

class DBConnection
  PRINT_QUERIES = ENV['PRINT_QUERIES'] == 'true'
  ROOT_FOLDER = Dir.pwd
  SQL_FILE = File.join(ROOT_FOLDER, 'db', 'app.sql')
  DB_FILE = File.join(ROOT_FOLDER, 'db', 'app.db')

  def self.start
    DBConnection.open(DB_FILE)
  end

  def self.open(db_name) # for sqlite3 we need file.db, for postgresql we need database name

    @db = ENV['DB_TYPE'] == 'PG' ?  PGWrapper.new(db_name) : SQLite3Wrapper.new(db_name)

    @db
  end

  def self.reset
    commands =
      { sqlite3: [
          "rm '#{DB_FILE}'",
          "cat '#{SQL_FILE}' | sqlite3 '#{DB_FILE}'"
        ],
        pgsql: []
      }

    commands.each { |command| `#{command}` }
    DBConnection.open(DB_FILE)
  end

  def self.instance
    start if @db.nil?

    @db
  end

  # results hash of results [{id: 1, name: 'Bob'}...]
  def self.execute(*args)
    print_query(*args)
    instance.execute(*args)
  end

  # returns result with header fields [['id', 'name'...], { id: 1, name: 'Bob' ... }
  def self.execute2(*args)
    print_query(*args)
    instance.execute2(*args)
  end

  # used to insert data into tables
  def self.insert(*args)
    print_query(*args)
    instance.insert(*args)
  end


  private

  def self.print_query(query, *interpolation_args)
    return unless PRINT_QUERIES

    puts '--------------------'
    puts query
    unless interpolation_args.empty?
      puts "interpolate: #{interpolation_args.inspect}"
    end
    puts '--------------------'
  end
end
