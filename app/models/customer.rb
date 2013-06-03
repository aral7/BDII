class Customer < ActiveRecord::Base
  # attr_accessible :title, :body
  self.table_name = "Customers"
  self.primary_key = "CustomerID"
end
