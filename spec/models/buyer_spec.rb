require_relative '../spec_helper'

describe Buyer do

  context ".last" do
    context  "with no buyer in the database" do
      it "should return nil" do
       Buyer.last.should be_nil
      end
    end
    context "with multiple buyers in the db" do
      before do
        Buyer.new("Foo").save
        Buyer.new("Bar").save
        Buyer.new("Baz").save
        Buyer.new("Grille").save
      end
      it "should return the last one inserted" do
        Buyer.last.name.should == "Grille"
      end
    end
  end
=begin
  context ".delete_by_name" do
    context "delete 1 buyer in database" do
      it "should remove a buyer" do
        Buyer.new("Dick").save
        Buyer.delete_by_name("Dick")
        Buyer.count.should == 0
      end
    end
  end
=end
  context ".find_by_name" do
    context "with no buyer in the database" do
      it "should return 0" do
        Buyer.find_by_name("Foo").should be_nil
      end
    end
    context "with buyer by that name in the database" do
      let(:foo){ Buyer.create("Foo") }
      before do
        foo.save
        Buyer.new("Bar").save
        Buyer.new("Baz").save
        Buyer.new("Grille").save
      end
      it "should return the buyer with that name" do
        Buyer.find_by_name("Foo").id.should == foo.id
      end
      it "should return the buyer with that name" do
        Buyer.find_by_name("Foo").name.should == foo.name
      end
    end
  end

  context ".count" do
    context "with no buyer in the database" do
      it "should return 0" do
        Buyer.count.should == 0
      end
    end
    context "with multiple buyers in the database" do
      before do
        Buyer.new("Foo").save
        Buyer.new("Bar").save
        Buyer.new("Baz").save
        Buyer.new("Grille").save
      end
      it "should return the correct count" do
        Buyer.count.should == 4
      end
    end
  end


  context ".all" do
    context "with no buyer in the database" do
      it "should return an empty array" do
        Buyer.all.should == []
      end
    end
    context "with multiple buyers in the database" do
      let!(:foo){ Buyer.create("Foo") }
      let!(:bar){ Buyer.create("Bar") }
      let!(:baz){ Buyer.create("Baz") }
      let!(:grille){ Buyer.create("Grille") }
      it "should return all of the buyers" do
        buyer_attrs = Buyer.all.map{ |buyer| [buyer.name,buyer.id] }
        buyer_attrs.should == [["Foo", foo.id],["Bar", bar.id],["Baz", baz.id],["Grille", grille.id]]
      end
    end
  end

  context "#new" do
    let(:buyer) { Buyer.new("Clyde") }
    it "should store the name" do
      buyer.name.should == "Clyde"
    end
  end

  context "#create" do
    let(:result){ Environment.database_connection.execute("Select * from buyer") }
    let(:buyer){ Buyer.create("foo") }
    context "with a valid car" do
      before do
        Buyer.any_instance.stub(:valid?){ true }
        buyer
      end
      it "should record the new id" do
        buyer.id.should == result[0]["id"]
      end
      it "should only save one row to the database" do
        result.count.should == 1
      end
      it "should actually save it to the database" do
        result[0]["name"].should == "foo"
      end
    end
    context "with a invalid car" do
      before do
        Buyer.any_instance.stub(:valid?){ false }
        buyer
      end
      it "should not save a new car" do
        result.count.should == 0
      end
    end
  end

  context "#save" do
    let(:result){ Environment.database_connection.execute("Select * from buyer") }
    let(:buyer){ Buyer.new("foo") }
    context "with a valid buyer" do
      before do
        buyer.stub(:valid?){ true }
      end
      it "should only save one row to the database" do
        buyer.save
        result.count.should == 1
      end
      it "should actually save it to the database" do
        buyer.save
        result[0]["name"].should == "foo"
      end
      it "should record the new id" do
        buyer.save
        buyer.id.should == result[0]["id"]
      end
    end
    context "with an invalid buyer" do
      before do
        buyer.stub(:valid?){ false }
      end
      it "should not save a new buyer" do
        buyer.save
        result.count.should == 0
      end
    end
=begin
    context "updating a buyer" do
      let(:original_buyer){ Buyer.create("Hans") }
      let!(:original_id){ original_buyer.id }
      context "valid update" do
        before do
          original_buyer.name = "Dick"
          original_buyer.save
        end
        let(:updated_buyer){Buyer.find_by_name("Dick")}
        it "updated buyer should not be nil" do
          updated_group.should_not be_nil
        end
        it "updated buyer should retain previous id" do
          updated_buyer.id.should == original_id
        end
        it "should keep a constant total number of buyers"
          Buyer.count.should == 1
        end
      end
      context "invalid update" do
        let(:duplicate_buyer){ Buyer.create("Geoff") }
        before do
          original_buyer
          duplicate_buyer.name = "Mark"
          duplicate_buyer.save
        end
        it "should not allow duplicate buyer to change to existing buyer" do
          duplicate_buyer.errors.first.should == "Mark already exists."
        end
        it "should retain number of buyers in database" do
          Buyer.count.should == 2
        end
      end
    end
  end
=end
  context "#valid?" do
    let(:result){ Environment.database_connection.execute("Select name from buyer") }
    context "after fixing the errors" do
      let(:buyer){ Buyer.new("123") }
      it "should return true" do
        buyer.valid?.should be_false
        buyer.name = "Kirk"
        buyer.valid?.should be_true
      end
    end
    context "with a unique name" do
      let(:buyer){ Buyer.new("Karl") }
      it "should return true" do
        buyer.valid?.should be_true
      end
    end
    context "with an invalid name" do
      let(:buyer){ Buyer.new("666") }
      it "should return false" do
        buyer.valid?.should be_false
      end
      it "should have the error messages" do
        buyer.valid?
        buyer.errors.first.should == "'666' is not a valid buyer name because it has no letters!"
      end
    end
    context "with a duplicate name" do
      let(:name){ "Holly" }
      let(:buyer){ Buyer.new(name) }
      before do
        Buyer.new(name).save
      end
      it "should return false" do
        buyer.valid?.should be_false
      end
      it "should save the error messages" do
        buyer.valid?
        buyer.errors.first.should == "#{name} already exists."
      end
    end
  end
end
end
