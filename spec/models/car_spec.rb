require_relative '../spec_helper'

describe Car do

  context ".last" do
    context "with no car in the database" do
      it "should return nil" do
        Car.last.should be_nil
      end
    end
    context "with multiple cars in the db" do
      let(:grille){ Car.new("Grille") }
      before do
        Car.new("Foo").save
        Car.new("Bar").save
        Car.new("Baz").save
        grille.save
      end
      it "should return the last one inserted" do
        Car.last.name.should == "Grille"
      end
      it "should return the last one inserted with id populated" do
        Car.last.id.should == grille.id
      end
    end
  end
  context ".find_by_name" do
    context "with no car in the database" do
      it "should return 0" do
        Car.find_by_name("Foo").should be_nil
      end
    end
    context "with car by that name in the database" do
      let(:foo){ Car.create("Foo") }
      before do
        foo.save
        Car.new("Bar")
        Car.new("Baz")
        Car.new("Grille")
      end
      it "should return a car with that id" do
        Car.find_by_name("Foo").id.should == foo.id
      end
      it "should return a car with that name" do
        Car.find_by_name("Foo").name.should == "Foo"
      end
    end
  end

  context ".count" do
    context "with no car in the database" do
      it "should return 0" do
        Car.count.should == 0
      end
    end
    context "with multiple cars in the database" do
      before do
        Car.new("Foo").save
        Car.new("Bar").save
        Car.new("Baz").save
        Car.new("Grille").save
      end
      it "should return the correct count" do
        Car.count.should == 4
      end
    end
  end

  context ".all" do
    context "with no cars in the database" do
      it "should return and empty array" do
        Car.all.should == []
      end
    end
    context "with multiple cars in the database" do
      let(:foo){ Car.new("Foo") }
      let(:bar){ Car.new("Bar") }
      let(:baz){ Car.new("Baz") }
      let(:grille){ Car.new("Grille") }
      before do
        foo.save
        bar.save
        baz.save
        grille.save
      end
      it "should return all of the cars with their name and id" do
        car_attrs = Car.all.map{ |car| [car.name,car.id] }
        car_attrs.should == [["Foo", foo.id],
                             ["Bar", bar.id],
                             ["Baz", baz.id],
                             ["Grille", grille.id]]
      end
    end
  end
  context "#new" do
    let(:car) { Car.new("Beemer") }
    it "should store the name" do
      car.name.should == "Beemer"
    end
  end
  context "#create" do
    let(:result){ Environment.database_connection.execute("Select * from car") }
    let(:car){ Car.create("foo") }
    context "with a valid car" do
      before do
        Car.any_instance.stub(:valid?){ true }
        car
      end
      it "should record the new id" do
        result[0]["id"].should == car.id
      end
      it "should only save one row to the database" do
        result.count.should == 1
      end
      it "should actually save it to the database" do
        result[0]["name"].should == "foo"
      end
    end
    context "with an invalid car" do
      before do
        Car.any_instance.stub(:valid?){ false }
        car
      end
      it "should not save a new car" do
        result.count.should == 0
      end
    end
  end

  context "#save" do
    let(:result){ Environment.database_connection.execute("Select * from car") }
    let(:car){ Car.new("foo") }
    context "with a valid car" do
      before do
      car.stub(:valid?){ true }
      end
      it "should only save one row to the database" do
        car.save
        result.count.should == 1
      end
      it "should record the new id" do
        car.save
        car.id.should == result[0]["id"]
      end
      it "should actually save it to the database" do
        car.save
        result[0]["name"].should == "foo"
      end
    end
    context "with an invalid car" do
      before do
        car.stub(:valid?){ false }
      end
      it "should not save a new car" do
        car.save
        result.count.should == 0
      end
    end
  end
  context "#valid?" do
    let(:result){ Environment.database_connection.execute("Select name from cars") }
    context "after fixing the errors" do
      let(:car){ Car.new("123") }
      it "should return true" do
        car.valid?.should be_true
        car.name = "Merc"
        car.valid?.should be_true
      end
    end
    context "with a unique name" do
      let(:car){ Car.new("JTHKD5BH6C2114556") }
      it "should return true" do
        car.valid?.should be_true
      end
    end
    context "with an invalid car name" do
      let(:car){ Car.new("666") }
      it "should return false" do
        car.valid?.should be_true
      end
      it "should save the error messages" do
        car.valid?
        car.errors.first.should == nil
      end
    end
    context "with a duplicate name" do
      let(:car){ Car.new("JTHKD5BH3C2114255") }
      before do
        Car.new("JTHKD5BH3C2114255").save
      end
      it "should return false" do
        car.valid?.should be_false
      end
      it "should save the error messages" do
        car.valid?
        car.errors.first.should == "JTHKD5BH3C2114255 already exists."
      end
    end
  end

  context "#delete" do
    let(:result){Environment.database_connection.execute("Select * from car")}
    let(:car){Car.create("WDDGJ7HBXCF861624")}
    it "should delete a car" do
      car.delete
      Car.find_by_name("WDDGJ7HBXCF861624").should be_nil
    end
    it "should return nil with result" do
      result.count.should == 0
    end
  end
end
