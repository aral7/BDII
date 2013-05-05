class Employee < ActiveRecord::Base
  self.primary_key= 'EmployeeID'
  self.table_name = 'Employees'
  belongs_to :employee, :foreign_key => 'ReportsTo', :primary_key => 'EmployeeID'
  attr_accessible :FirstName, :LastName, :Photo, :City, :Address, :Title, :TitleOfCourtesy, :BirthDate, :HireDate
end
