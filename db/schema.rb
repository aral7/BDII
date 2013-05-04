# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130504162652) do

  create_table "Categories", :primary_key => "CategoryID", :force => true do |t|
    t.text   "CategoryName"
    t.text   "Description"
    t.binary "Picture"
  end

  create_table "CustomerCustomerDemo", :primary_key => "CustomerID", :force => true do |t|
    t.text "CustomerTypeID", :null => false
  end

  create_table "CustomerDemographics", :primary_key => "CustomerTypeID", :force => true do |t|
    t.text "CustomerDesc"
  end

  add_index "CustomerDemographics", ["CustomerTypeID"], :name => "sqlite_autoindex_CustomerDemographics_1", :unique => true

  create_table "Customers", :primary_key => "CustomerID", :force => true do |t|
    t.text "CompanyName"
    t.text "ContactName"
    t.text "ContactTitle"
    t.text "Address"
    t.text "City"
    t.text "Region"
    t.text "PostalCode"
    t.text "Country"
    t.text "Phone"
    t.text "Fax"
  end

  add_index "Customers", ["CustomerID"], :name => "sqlite_autoindex_Customers_1", :unique => true

  create_table "EmployeeTerritories", :primary_key => "EmployeeID", :force => true do |t|
    t.text "TerritoryID", :null => false
  end

  add_index "EmployeeTerritories", ["EmployeeID", "TerritoryID"], :name => "sqlite_autoindex_EmployeeTerritories_1", :unique => true

  create_table "Employees", :primary_key => "EmployeeID", :force => true do |t|
    t.text    "LastName"
    t.text    "FirstName"
    t.text    "Title"
    t.text    "TitleOfCourtesy"
    t.date    "BirthDate"
    t.date    "HireDate"
    t.text    "Address"
    t.text    "City"
    t.text    "Region"
    t.text    "PostalCode"
    t.text    "Country"
    t.text    "HomePhone"
    t.text    "Extension"
    t.binary  "Photo"
    t.text    "Notes"
    t.integer "ReportsTo"
    t.text    "PhotoPath"
  end

# Could not dump table "Order Details" because of following StandardError
#   Unknown type 'REAL' for column 'Discount'

  create_table "Orders", :primary_key => "OrderID", :force => true do |t|
    t.text     "CustomerID"
    t.integer  "EmployeeID"
    t.datetime "OrderDate"
    t.datetime "RequiredDate"
    t.datetime "ShippedDate"
    t.integer  "ShipVia"
    t.decimal  "Freight",        :default => 0.0
    t.text     "ShipName"
    t.text     "ShipAddress"
    t.text     "ShipCity"
    t.text     "ShipRegion"
    t.text     "ShipPostalCode"
    t.text     "ShipCountry"
  end

  create_table "Products", :primary_key => "ProductID", :force => true do |t|
    t.text    "ProductName",                      :null => false
    t.integer "SupplierID"
    t.integer "CategoryID"
    t.text    "QuantityPerUnit"
    t.decimal "UnitPrice",       :default => 0.0
    t.integer "UnitsInStock",    :default => 0
    t.integer "UnitsOnOrder",    :default => 0
    t.integer "ReorderLevel",    :default => 0
    t.text    "Discontinued",    :default => "0", :null => false
  end

  create_table "Regions", :primary_key => "RegionID", :force => true do |t|
    t.text "RegionDescription", :null => false
  end

  create_table "Shippers", :primary_key => "ShipperID", :force => true do |t|
    t.text "CompanyName", :null => false
    t.text "Phone"
  end

  create_table "Suppliers", :primary_key => "SupplierID", :force => true do |t|
    t.text "CompanyName",  :null => false
    t.text "ContactName"
    t.text "ContactTitle"
    t.text "Address"
    t.text "City"
    t.text "Region"
    t.text "PostalCode"
    t.text "Country"
    t.text "Phone"
    t.text "Fax"
    t.text "HomePage"
  end

  create_table "Territories", :primary_key => "TerritoryID", :force => true do |t|
    t.text    "TerritoryDescription", :null => false
    t.integer "RegionID",             :null => false
  end

  add_index "Territories", ["TerritoryID"], :name => "sqlite_autoindex_Territories_1", :unique => true

end
