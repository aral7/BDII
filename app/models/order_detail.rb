class OrderDetail < ActiveRecord::Base
  self.primary_key = "odID"
  self.table_name = "orderdetails"
  # attr_accessible :title, :body
end
