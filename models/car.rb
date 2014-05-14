class Car
  attr_reader :errors
  attr_reader :id
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def self.delete
    statement = "DELETE FROM car WHERE id == ?;"
    Environment.database_connection.execute(statement, self.id)
    true
  end

  def self.all
    statement = "Select * from car;"
    execute_and_instantiate(statement)
  end

  def self.count
    statement = "Select count(*) from car;"
    result = Environment.database_connection.execute(statement)
    result[0][0]
  end

  def self.create(name)
    car = Car.new(name)
    car.save
    car
  end

  def self.find_by_name(name)
    statement = "Select * from car where name = ?;"
    execute_and_instantiate(statement, name)[0]
  end

  def self.last
    statement = "Select * from car order by id DESC limit(1);"
    execute_and_instantiate(statement)[0]
  end

  def save
    if self.valid?
      statement = "Insert into car (name) values (?);"
      Environment.database_connection.execute(statement, name)
      @id = Environment.database_connection.execute("SELECT last_insert_rowid();")[0][0]
      true
    else
      false
    end
  end

  def valid?
    @errors = []
#    if s.length != 17
#      @errors << "'#{self.name}' is not a valid car because it is not 17 characters!"
#    end
    if !name.match /[a-zA-Z0-9]/
      @errors << "'#{self.name}' is not a valid car because it does not have any letters!"
    end
    if Car.find_by_name(self.name)
      @errors << "#{self.name} already exists."
    end
    @errors.empty?
  end

  private

  def self.execute_and_instantiate(statement, bind_vars = [])
    rows = Environment.database_connection.execute(statement, bind_vars)
    results = []
    rows.each do |row|
      car = Car.new(row["name"])
      car.instance_variable_set(:@id, row["id"])
      results << car
    end
    results
  end
end

