class Buyer
  attr_reader :errors
  attr_reader :id
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def self.find_by_name(name)
    statement = "Select * from buyer where name = ?;"
    execute_and_instantiate(statement, name)[0]
  end

  def self.last
    statement = "Select * from buyer order by id DESC limit(1);"
    execute_and_instantiate(statement)[0]
  end

  def self.create(name)
    person = Buyer.new(name)
    person.save
    person
  end

  def self.count
    statement = "Select count(*) from buyer;"
    result = Environment.database_connection.execute(statement)
    result[0][0]
  end

  def self.all
    statement = "Select * from buyer;"
    execute_and_instantiate(statement)
  end

  def self.execute_and_instantiate(statement, bind_vars = [])
    rows = Environment.database_connection.execute(statement, bind_vars)
    results = []
    rows.each do |row|
      buyer = Buyer.new(row["name"])
      buyer.instance_variable_set(:@id, row["id"])
      results << buyer
    end
    results
  end

  def save
    if self.valid?
      statement = "Insert into buyer (name) values (?);"
      Environment.database_connection.execute(statement, name)
      @id = Environment.database_connection.execute("SELECT last_insert_rowid();")[0][0]
      true
    else
      false
    end
  end

  def valid?
    @errors = []
    if !name.match /[a-zA-Z]/
      @errors << "'#{self.name}' is not a valid buyer name because it has no letters!"
    end
    if Buyer.find_by_name(self.name)
      @errors << "#{self.name} already exists."
    end
    @errors.empty?
  end
end




