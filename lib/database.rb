require "sqlite3"

class Database < SQLite3::Database
  def initialize(database)
    super(database)
    self.results_as_hash = true
  end

  def self.connection(environment)
    @connection ||= Database.new("db/Cars_#{environment}.sqlite3")
  end

  def create_tables
    self.execute("CREATE TABLE car (id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(50), lot varchar(1)")
    self.execute("CREATE TABLE buyer (id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(50))")
  end

  def execute(statement, bind_vars = [])
    Environment.logger.info("Executing: #{statement} with: #{bind_vars}")
    super(statement, bind_vars)
  end
end


