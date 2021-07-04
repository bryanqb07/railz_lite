require 'sqlite3'

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
