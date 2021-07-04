require 'pg'

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
    result = @db.exec_params(converted_sql, *args)
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
