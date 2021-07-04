require_relative 'wrappers/pg_wrapper'
require_relative 'wrappers/sqlite3_wrapper'

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
