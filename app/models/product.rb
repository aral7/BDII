class Product < ActiveRecord::Base
  # attr_accessible :title, :body
  self.table_name = "Products"
  self.primary_key = "ProductID"
end
