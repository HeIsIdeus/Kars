require_relative '../spec_helper'

describe "Adding a car" do
  before do
    car = Car.new("3GNEC12J37G161190")
    car.save
  end
  context "adding a specific car" do
    let!(:output){ run_Cars_with_input("3GNEC12J37G161190") }
    it "should print a confirmation message" do
      output.should include ""
      Car.count.should == 1
    end
    it "should insert a new car" do
      Car.count.should == 1
    end
    it "should use the name we entered" do
      Car.last.name.should == "3GNEC12J37G161190"
    end
  end
  context "adding a duplicate car" do
    let(:output){ run_Cars_with_input("3GNEC12J37G161190") }
    it "should print an error message" do
      output.should include("")
    end
    it "should ask them to try again" do
      menu_text = "What is the car you want to add?"
      output.should include_in_order("")
    end
    it "shouldn't save the duplicate" do
      Car.count.should == 1
    end
    context "and trying again" do
      let!(:output){ run_Cars_with_input("3GNEC12J37G161190") }
      it "should save a unique item" do
        Car.last.name.should == "3GNEC12J37G161190"
      end
      it "should print a success message at the end" do
        output.should include("")
      end
    end
  end
  context "entering an car that appears invalid" do
    context "with SQL injection" do
      let(:input){ "buttholesurfers'), ('666" }
      let!(:output){ run_Cars_with_input("buttholesurfers',), ('666") }
      it "should not save the car" do
        Car.count.should == 1
      end
      it "should print an error message" do
        output.should include("")
      end
    end
  end
=begin
  context "deleting a car" do
    context "delete an existing car" do
      let(:shell_output){run_Cars_with_input("1FDXE4FS9DDA20788")}
      it "should delete the car" do
        shell_output
        Car.count.should == 0
      end
      it "should display the message of deletion" do
        shell_output.should include("1FDXE4FS9DDA20788 has been deleted.")
      end
    end
    context "if the car deleted does not exist" do
      let(:shell_output){run_Cars_with_input("1FDXE4FS9DDA21122")}
      it "should not delete the car" do
        shell_output
        Car.count.should == 1
      end
      it "should display a message about not existing." do
        shell_output.should include("1FDXE4FS9DDA21122 does not exist.")
      end
    end
  end
=end
end

