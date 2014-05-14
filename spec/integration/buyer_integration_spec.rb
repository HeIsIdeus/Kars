require_relative '../spec_helper'

describe "Adding a buyer" do
  before do
    buyer = Buyer.new("Crocket")
    buyer.save
  end
  context "adding a unique buyer" do
    let!(:output){ run_Cars_with_input("1", "Tubbs") }
    it "should print a confirmation message" do
      output.should include("Tubbs has been added.")
      Buyer.count.should == 2
    end
    it "should insert a new buyer" do
      Buyer.count.should == 2
    end
    it "should use the name we entered" do
      Buyer.last.name.should == "Tubbs"
    end
  end
  context "adding a duplicate buyer" do
    let(:output){ run_Cars_with_input("1", "Crocket") }
    it "should print an error message" do
      output.should include("Crocket already exists.")
    end
    it "should ask them to try again" do
      menu_text = "Who do you want to add?"
      output.should include_in_order(menu_text, "already exists", menu_text)
    end
    it "shouldn't save the duplicate" do
      Buyer.count.should == 1
    end
    context "and trying again" do
      let!(:output){ run_Cars_with_input("1", "Crocket", "Rubin") }
      it "should save a unique item" do
        Buyer.last.name.should == "Rubin"
      end
      it "should print a success message at the end" do
        output.should include("Rubin has been added")
      end
    end
  end

  context "entering what appears to be an invalid buyer" do
    context "with SQL injection" do
      let(:input){ "buttholesurfers'), ('666" }
      let!(:output){ run_Cars_with_input("1", input) }
      it "should create the buyer without evaluating the SQL" do
        Buyer.last.name.should == input
      end
      it "shouldn't create an extra buyer" do
        Buyer.count.should == 2
      end
      it "should print a success message at the end" do
        output.should include("#{input} has been added")
      end
    end
    context "without alphabet characters" do
      let(:output){ run_Cars_with_input("1", "9*222") }
      it "should not save the buyer" do
        Buyer.count.should == 1
      end
      it "should print an error message" do
        output.should include("'9*222' is not a valid buyer name because it has no letters!")
      end
      it "should let them try again" do
        menu_text = "Who do you want to add?"
        output.should include_in_order(menu_text, "not a valid", menu_text)
      end
    end
  end
=begin
  context "deleting a buyer" do
    context "delete an existing buyer" do
      let(:shell_output){run_Cars_with_input("Hans")}
      it "should delete the buyer" do
        shell_output
        Buyer.count.should == 0
      end
      it "should display the message of deletion" do
        shell_output.should include("Hans has been deleted.")
      end
    end
    context "if the buyer deleted does not exist" do
      let(:shell_output){run_Cars_with_input("Plop")}
      it "should not delete the group" do
        shell_output
        Buyer.count.should == 1
      end
      it "should display a message about not existing." do
        shell_output.should include("Plop does not exist.")
      end
    end
  end
=end
end
