require_relative '../spec_helper'

describe "Menu Integration" do
  let(:menu_text) do
<<EOS
What do you want to do?
1. Add Buyer
2. Add Car to inventory
3. Delete Car from inventory
4. Exit
EOS
  end
  context "the menu displays on startup" do
    let(:shell_output){ run_Cars_with_input() }
      it "should print the menu" do
        shell_output.should include(menu_text)
    end
  end

  context "the user selects 1" do
    let(:shell_output){ run_Cars_with_input("1") }
    it "should print the next menu" do
      shell_output.should include("Who do you want to add?")
    end
  end
  context "the user selects 2" do
    let(:shell_output){ run_Cars_with_input("2") }
    it "should print the next menu" do
      shell_output.should include("What is the car you want to add?")
    end
  end
  context "the user selects 3" do
    let(:shell_output){ run_Cars_with_input("3") }
    it "should print the menu" do
      shell_output.should include("Enter the 17 character VIN to delete vehicle")
    end
  end
  context "the user selects 4" do
    let(:shell_output){run_Cars_with_input("4")}
    it "should print the next menu" do
      shell_output.should include(menu_text)
    end
  end
=begin
  context "the user selects 5" do
    let(:shell_output){run_Cars_with_input("5")}
    it "should print the next menu" do
      shell_output.should include("Which car would you like to delete from inventory?")
    end
  end
  context "the user selects 6" do
    let(:shell_output){run_Cars_with_input("6")}
    it "should print the next menu" do
      shell_output.should include("Which buyer would you like to delete?")
    end
  end
  context "the user selects 7" do
    let(:shell_output){run_Cars_with_input("7")}
    it "should print the next menu" do
      shell_output.should include("Name of the car you would like to view?")
    end
  end
  context "the user selects 8" do
    let(:shell_output){run_Cars_with_input("8")}
    it "should print the next menu" do
      shell_output.should include("Name of buyer you would like to view?")
    end
  end
  context "the user selects 9" do
    let(:shell_output){run_Cars_with_input("9")}
    it "should print the next menu" do
      shell_output.should include("Thank you!")
    end
  end
=end
  context "the user selects 10" do
    let(:shell_output){run_Cars_with_input("10")}
    it "should print the menu again" do
      shell_output.should include("'10' is not a valid selection")
    end
  end
  context "the user types in the wrong input" do
    let(:shell_output){ run_Cars_with_input("11") }
    it "should print the menu again" do
      shell_output.should include_in_order(menu_text, "11", menu_text)
    end
    it "should include an appropriate error message" do
      shell_output.should include("'11' is not a valid selection")
    end
  end
  context "if the user types in no input" do
    let(:shell_output){ run_Cars_with_input("") }
    it "should print the menu again" do
      shell_output.should include_in_order(menu_text, menu_text)
    end
    it "should include an appropriate error message" do
      shell_output.should include("'' is not a valid selection")
    end
  end
  context "if the user types in incorrect input, it should allow correct input" do
    let(:shell_output){ run_Cars_with_input("5", "1") }
    it "should include the appropriate menu" do
      shell_output.should include("Who do you want to add?")
    end
  end
  context "if the user types in incorrect input multiple times, it should allow correct input" do
    let(:shell_output){ run_Cars_with_input("5","", "1") }
    it "should include the appropriate menu" do
      shell_output.should include("Who do you want to add?")
    end
  end
end
