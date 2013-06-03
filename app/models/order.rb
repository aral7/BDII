class Order < ActiveRecord::Base
  self.primary_key = "OrderID"
  self.table_name = "Orders"
  # attr_accessible :title, :body
end
