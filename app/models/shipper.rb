class Shipper < ActiveRecord::Base
  self.primary_key = 'ShipperID'
  self.table_name = 'Shippers'
  # attr_accessible :title, :body
end
