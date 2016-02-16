require 'json'
def setup_files
	path = File.join(File.dirname(__FILE__), '../data/products.json')
	file = File.read(path)
	$products_hash = JSON.parse(file)
	$report_file = File.new("report.txt","w+")
end

def ascii_sales_report
	$report_file.write( "  _____           _                  _____                                  _           \n")
	$report_file.write( " / ____|         | |                |  __ \\                                | |         \n")
	$report_file.write( "| (___     __ _  | |   ___   ___    | |__) |   ___   _ __     ___    _ __  | |_         \n")
	$report_file.write( " \\___ \\   / _` | | |  / _ \\ / __|   |  _  /   / _ \\ | '_ \\   / _ \\  | '__| | __|  \n")
	$report_file.write( " ____) | | (_| | | | |  __/ \\__ \\   | | \\ \\  |  __/ | |_) | | (_) | | |    | |_     \n")
	$report_file.write( "|_____/   \\__,_| |_|  \\___| |___/   |_|  \\_\\  \\___| | .__/   \\___/  |_|     \\__| \n")
	$report_file.write( "                                                    | |                                 \n")
	$report_file.write( "                                                    |_|                                 \n")

end

def ascii_products
	$report_file.write( "                     _            _       \n")
	$report_file.write( "                    | |          | |      \n")
	$report_file.write( " _ __  _ __ ___   __| |_   _  ___| |_ ___ \n")
	$report_file.write( "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|\n")
	$report_file.write( "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\ \n")
	$report_file.write( "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/\n")
	$report_file.write( "| |                                       \n")
	$report_file.write( "|_|                                       \n")
end

def ascii_brands
	$report_file.write( " _                         _     \n")
	$report_file.write( "| |                       | |    \n")
	$report_file.write( "| |__  _ __ __ _ _ __   __| |___ \n")
	$report_file.write( "| '_ \\| '__/ _` | '_ \\ / _` / __|\n")
	$report_file.write( "| |_) | | | (_| | | | | (_| \\__ \\\n")
	$report_file.write( "|_.__/|_|  \\__,_|_| |_|\\__,_|___/\n\n")
end

def get_toy_name(toy)
	return toy["title"]
end

def get_retail_price(toy)
	return toy["full-price"].to_f
end

def get_list_purchases(toy)
	purchases = toy["purchases"]
	return purchases
end

def get_total_sales(purchases)
	sales = 0
	purchases.each do |purchase|
		sales += purchase["price"]
	end
	return sales
end

def calc_average_price(sales,number_purchases)
	return (sales/number_purchases).round(2)
end

def calc_average_discount(price_retail,price_average)
	return price_retail - price_average
end

def get_brand_name(brand)
	return brand["name"]
end

def get_total_stock_toys(brand)
	return brand["stock"]
end

def get_total_sales_brand(brand)
	return brand["sales"].round(2)
end

def is_brand_recorded(brand)
	return $brands_data.has_key?(brand)
end

def get_brand(toy)
	return toy["brand"]
end

def build_brands_data_hash(toy_brand,retail_price,toy_sales,toys_stock)
	if !is_brand_recorded(toy_brand)
		$brands_data[toy_brand] = Hash.new
		$brands_data[toy_brand]["name"] = toy_brand
		$brands_data[toy_brand]["count"] = 1
		$brands_data[toy_brand]["price"] = retail_price
		$brands_data[toy_brand]["sales"] = toy_sales
		$brands_data[toy_brand]["stock"] = toys_stock
	else
		$brands_data[toy_brand]["count"] += 1
		$brands_data[toy_brand]["price"] += retail_price
		$brands_data[toy_brand]["sales"] += toy_sales
		$brands_data[toy_brand]["stock"] += toys_stock
	end
end

def brands_report
	# Print "Brands" in ascii art
	ascii_brands
	report = ""
	# For each brand in the data set:
	$brands_data.each do |key,brand|
		# Print the name of the brand
		# Total toys of brand
		total_toys = brand["count"]
		# Count and print the number of the brand's toys we stock
		total_toys_in_stock = get_total_stock_toys(brand)
		# Calculate and print the average price of the brand's toys
		average_price = calc_average_price(brand["price"],total_toys)
		# Calculate and print the total sales volume of all the brand's toys combined
		total_sales = get_total_sales_brand(brand)
		report += "Brand Name: #{key}\nToys in Stock: #{total_toys_in_stock}\nAverage Price: $#{average_price}\nSales: $#{total_sales}\n\n"
	end
	$report_file.write(report)
end

def products_report
	# Print "Products" in ascii art
	ascii_products
	report = ""
	# For each product in the data set:
	$products_hash["items"].each do |toy|
		# Print the name of the toy
		toy_name = get_toy_name(toy)
		# Print the retail price of the toy
		price = get_retail_price(toy)
		# Calculate and print the total number of purchases
		total_purchases = get_list_purchases(toy).length
		# Calculate and print the total amount of sales
		sales = get_total_sales(get_list_purchases(toy))
		# Calculate and print the average price the toy sold for
		average = calc_average_price(sales,total_purchases)
		# Calculate and print the average discount (% or $) based off the average sales price
		discount = calc_average_discount(price,average)
		report += "Name: #{toy_name}\nRetail Price: $#{price}\nTotal Purchases: #{total_purchases}\nTotal Sales: $#{sales}\nAverage Price: #{average}\nAverage Discount $#{discount}\n\n"
		build_brands_data_hash(get_brand(toy),price,sales,toy["stock"])
	end
	$report_file.write(report)
end

def generate_final_report
	products_report
	brands_report
	$report_file.close
end

def start
	$brands_data = {}
	# Print "Sales Report" in ascii art
	ascii_sales_report
	# Print today's date
	$report_file.write( Time.now.to_s + "\n" )
end

setup_files
start
generate_final_report
