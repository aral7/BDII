class Employee < ActiveRecord::Base
  self.primary_key= 'EmployeeID'
  self.table_name = 'Employees'
  has_one :ReportsTo, :class_name => 'Employee'
  attr_accessible :FirstName, :LastName
end
