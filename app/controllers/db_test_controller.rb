class DbTestController < ApplicationController
  require 'benchmark'

  def calcTime(&block)
    Benchmark.measure(&block).total
  end

  def parseOrders
    Order.delete_all
    ordersToAdd = []
    path = "#{Rails.root}/public/data/orders_rand_10000.xml"
    results = "#{Rails.root}/public/data/times_mem.txt"
    file = Nokogiri::XML(open(path))
    file.root.elements.each do |node|
         if node.node_name.eql? 'order'
           newOrder = Order.new
           node.elements.each do |orderNode|
              newOrder.OrderID = orderNode.text.to_s if orderNode.node_name.eql? 'OrderID'
              newOrder.CustomerID = orderNode.text.to_s if orderNode.node_name.eql? 'CustomerID'
              newOrder.EmployeeID = orderNode.text.to_s if orderNode.node_name.eql? 'EmployeeID'
              newOrder.OrderDate = orderNode.text.to_s if orderNode.node_name.eql? 'OrderDate'
              newOrder.RequiredDate = orderNode.text.to_s if orderNode.node_name.eql? 'RequiredDate'
              newOrder.ShippedDate = orderNode.text.to_s if orderNode.node_name.eql? 'ShippedDate'
              newOrder.ShipVia = orderNode.text.to_s if orderNode.node_name.eql? 'ShipVia'
              newOrder.Freight = orderNode.text.to_s if orderNode.node_name.eql? 'Freight'
              newOrder.ShipName = orderNode.text.to_s if orderNode.node_name.eql? 'ShipName'
              newOrder.ShipAddress = orderNode.text.to_s if orderNode.node_name.eql? 'ShipAddress'
              newOrder.ShipCity = orderNode.text.to_s if orderNode.node_name.eql? 'ShipCity'
              newOrder.ShipRegion = orderNode.text.to_s if orderNode.node_name.eql? 'ShipRegion'
              newOrder.ShipPostalCode = orderNode.text.to_s if orderNode.node_name.eql? 'ShipPostalCode'
              newOrder.ShipCountry = orderNode.text.to_s if orderNode.node_name.eql? 'ShipCountry'
           end
           ordersToAdd << newOrder
         end
    end
    i = 0
    start = Time.now
    File.open(results, 'w+') do |f|
      Order.transaction do
          ordersToAdd.each do |ord|
            ord.save!
            i += 1
            if i % 1000 == 0 then
              f.puts "After " + (i*1000).to_s + " inserts: " + (Time.now - start).to_s
            end
          end
        end
    end
  end

  def parseOrderDetails
    OrderDetail.delete_all
    ordersToAdd = []
    path = "#{Rails.root}/public/data/orderdetails_rand_10000.xml"
    results = "#{Rails.root}/public/data/times2_mem.txt"
    file = Nokogiri::XML(open(path))
    file.root.elements.each do |node|
      if node.node_name.eql? 'orderdetail'
        newOrder = OrderDetail.new
        node.elements.each do |orderNode|
          newOrder.odID = orderNode.text.to_s if orderNode.node_name.eql? 'odID'
          newOrder.OrderID = orderNode.text.to_s if orderNode.node_name.eql? 'OrderID'
          newOrder.ProductID = orderNode.text.to_s if orderNode.node_name.eql? 'ProductID'
          newOrder.UnitPrice = orderNode.text.to_s if orderNode.node_name.eql? 'UnitPrice'
          newOrder.Quantity = orderNode.text.to_s if orderNode.node_name.eql? 'Quantity'
          newOrder.Discount = orderNode.text.to_s if orderNode.node_name.eql? 'Discount'
        end
        ordersToAdd << newOrder
      end
    end
    i = 0
    start = Time.now
    File.open(results, 'w+') do |f|
      OrderDetail.transaction do
        ordersToAdd.each do |ord|
          ord.save
          i += 1
          if i % 1000 == 0 then
            f.puts "After " + i.to_s + " inserts: " + (Time.now - start).to_s
          end
        end
      end
    end
  end

  def orders_by_country
    orders_by_c = Hash.new()
    orders_by_c.default = 0
    time = calcTime do
      Order.all.each do |order|
         orders_by_c[order.ShipCountry] += 1 if order.ShippedDate <= order.RequiredDate
      end
    end
    File.open("#{Rails.root}/public/data/1_mem.txt", "w+") do |f|
      orders_by_c.each do |key, value|
        f.puts key.to_s + " got " + value.to_s + " orders "
      end
      f.puts "Time: " + time.to_s
    end
  end

  def avg_time_by_year
    time_by_year = Hash.new()
    time_by_year.default = 0.0
    counts = Hash.new()
    counts.default = 0
    time = calcTime do
      Order.all.each do |order|
        time_by_year[order.OrderDate.strftime("%Y")] += (order.ShippedDate - order.OrderDate)
        counts[order.OrderDate.strftime("%Y")] += 1
      end
    end
    File.open("#{Rails.root}/public/data/2_mem.txt", "w+") do |f|
      time_by_year.each do |key, value|
        f.puts key.to_s + " got " + (value.to_f/counts[key]).to_s  + " avg "
      end
      f.puts "Time: " + time.to_s
    end
  end

  def products_by_supplier
    supplier_product = Hash.new()
    supplier_product.default = 0
    time = calcTime do
      OrderDetail.all.each do |ord|
        prod = Product.find(ord.ProductID)
        supplier_product[prod.SupplierID] += 1
      end
    end
    File.open("#{Rails.root}/public/data/3_mem.txt", "w+") do |f|
      supplier_product.each do |key, value|
        f.puts key.to_s + " sold " + (value).to_s  + " products "
      end
      f.puts "Time: " + time.to_s
    end
  end

  def amount_by_day
     day_amount = Hash.new()
     day_amount.default = 0.0
    time = calcTime do
      Order.all.each do |order|
        ordDet = OrderDetail.where("OrderID = ?", order.OrderID)
        amount = 0.0
        ordDet.each do |od|
          amount += od.UnitPrice * od.Quantity
        end
        day_amount[order.OrderDate.strftime("%A")] += amount
      end
    end
     File.open("#{Rails.root}/public/data/4_mem.txt", "w+") do |f|
       day_amount.each do |key, value|
         f.puts key.to_s + " had " + (value).to_s  + " amount "
       end
       f.puts "Time: " + time.to_s
     end
  end

  def amount_by_country
    country_years = Hash.new()
    time = calcTime do
      Order.all.each do |order|
          country = Customer.find(order.CustomerID).Country
          country_years.fetch(country) { country_years[country] = Hash.new() }
          year = order.OrderDate.strftime("%Y")
          country_years[country].fetch(year) { country_years[country][year] = 0.0 }
          amount = 0.0
          ordDet = OrderDetail.where("OrderID = ?", order.OrderID)
          ordDet.each do |od|
            amount += od.UnitPrice * od.Quantity
          end
          country_years[country][year] += amount
      end
    end
    File.open("#{Rails.root}/public/data/5_mem.txt", "w+") do |f|
      country_years.each do |key, value|
        value.each do |year, amount|
          f.puts key.to_s + " in " + year.to_s + " bought " + amount.to_s
        end
      end
      f.puts "Time: " + time.to_s
    end
  end

  def product_val_by_supplieryear
    supplier_year_amount = Hash.new()
    supplier_year_count = Hash.new()
    time = calcTime do
        Order.all.each do |order|
          ordDet = OrderDetail.where("OrderID = ?",order.OrderID)
          ordDet.each do |od|
            supplier = Product.find(od.ProductID).SupplierID
            supplier_year_amount.fetch(supplier) { supplier_year_amount[supplier] = Hash.new() }
            supplier_year_count.fetch(supplier) { supplier_year_count[supplier] = Hash.new() }
            year = order.OrderDate.strftime("%Y")
            supplier_year_amount[supplier].fetch(year) { supplier_year_amount[supplier][year] = 0.0 }
            supplier_year_count[supplier].fetch(year) { supplier_year_count[supplier][year] = 0.0 }
            price = od.UnitPrice
            supplier_year_amount[supplier][year] += price
            supplier_year_count[supplier][year] += 1
            end
        end
    end
    File.open("#{Rails.root}/public/data/6_mem.txt", "w+") do |f|
      supplier_year_amount.each do |key, value|
        value.each do |year, amount|
          f.puts key.to_s + " had in " + year.to_s + " avg product price was " + (amount/supplier_year_count[key][year]).to_s
        end
      end
      f.puts "Time: " + time.to_s
    end
  end

end
