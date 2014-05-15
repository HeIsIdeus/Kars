User Stories
============

As a inventory manager
In order to keep a detailed account of my cars
I want a simple command line inventory app.

## Viewing the Menu

For new users, unfamiliar with the application
and want to see a list of options so that they can
continue on.

Acceptance Criteria:
* If the user selects 1, they see "Add buyer."
* If the user selects 2, they see "Add car."
* If the user selects 3, they see "Delete car."

Usage:

  `> ./Cars`

    What do you want to do?
    1. Add buyer.
    2. Add a car to inventory.
    3. Delete a car from inventory.
    4. Exit

## Add buyer

Acceptance Criteria:

* Unique buyer will be added to the database
* Duplicate buyers can't be added

Usage:

  `> ./Cars`

    What do you want to do?
    1. Add buyer.
    2. Add a car to inventory.
    3. Delete a car from inventory.
    4. Exit
    - 1
    Who do you want to add?
    - 
    Dick has been added.

## Add car to inventory

Acceptance Criteria:

* Unique car will be added to the database
* Duplicate cars can't be added

Usage:

  `> ./Cars`

    What do you want to do?
    1. Add buyer.
    2. Add car to inventory.
    3. Delete car from inventory.
    4. Exit
    - 2 
    Which buyer do you want to add? 
    -
    VIN#1G1YA2DW2D5108499, Corvette has been added.
    

## Delete car from inventory

Acceptance Criteria:

*Unique car will be deleted from the database
*17 character VIN is required input from user

Usage:

  `> ./Cars`

    What do you want to do?
    1. Add buyer.
    2. Add car to inventory.
    3. Delete car from inventory.
    4. Exit
    - 3
    Which car would you like to update?
    -
    

