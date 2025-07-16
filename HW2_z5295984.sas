proc sql number;
create table Orion.LaNew25_HW2Q1 as
select	c.Customer_ID,
		c.Activity_Level,
		count(distinct t.Order_Date) as Num_Shoppings,
		sum(p.Unit_Sales_Price * t.Quantity) as Total_Spending
	from	Orion.Lanew25_Customers as c
		left join
			Orion.Lanew25_Transactions as t
			on c.Customer_ID = t.Customer_ID
		left join
			Orion.Lanew25_Products as p
			on t.Product_ID = p.Product_ID
	group by	c.Customer_ID,
				c.Activity_Level;
quit;

proc sql number;
title	'z5295984 Dominik Xiong';
select	Activity_Level 'Activity Level',
		count(Customer_ID) 'No. of Customers',
		mean(Num_Shoppings) format=8.2 'Avg. No. of Shoppings',
		mean(Total_Spending) format=dollar12.2 'Avg. Spending'
	from	Orion.LaNew25_HW2Q1
	group by	Activity_Level
	order by	Activity_Level;
quit;

proc sql number;
title	'z5295984 Dominik Xiong';
select	c.Customer_Group 'Customer Group',
		sum(case
				when p.Product_Line = 'Children'
				then t.Quantity
				else 0
			end) / sum(t.Quantity) format=percent7.1 'Children',
		sum(case
				when p.Product_Line = 'Clothes & Shoes'
				then t.Quantity
				else 0
			end) / sum(t.Quantity) format=percent7.1 'Clothes & Shoes',
		sum(case
				when p.Product_Line = 'Outdoors'
				then t.Quantity
				else 0
			end) / sum(t.Quantity) format=percent7.1 'Outdoors',
		sum(case
				when p.Product_Line = 'Sports'
				then t.Quantity
				else 0
			end) / sum(t.Quantity) format=percent7.1 'Sports'
	from	Orion.LaNew25_Customers as c
		inner join
			Orion.LaNew25_Transactions as t
			on	c.Customer_ID = t.Customer_ID
		inner join
			Orion.LaNew25_Products as p
			on	t.Product_ID = p.Product_ID
	group by	Customer_Group
	order by	Customer_Group;
quit;

proc sql number;
create table Orion.LaNew25_HW2Q3_EmpProfit as
select	t.Employee_ID,
		p.Product_Line,
		sum((p.Unit_Sales_Price - p.Unit_Cost) * t.Quantity) as Employee_Profit
	from	Orion.LaNew25_Transactions as t
		inner join
			Orion.LaNew25_Products as p
        	on t.Product_ID = p.Product_ID
    group by	t.Employee_ID,
				p.Product_Line;
quit;

proc sql number;
title	'z5295984 Dominik Xiong';
select	Product_Line 'Product Line',
		Employee_ID 'Star Employee ID',
		Employee_Profit format=dollar12.2 'Total Profit'
	from	Orion.LaNew25_HW2Q3_EmpProfit
	group by	Product_Line
	having	Employee_Profit = max(Employee_Profit)
	order by	Product_Line;
quit;

proc sql number;
title	'z5295984 Dominik Xiong';
select	p.Product_Name 'Product Name',
		sum(t.Quantity) 'Quantity'
	from	Orion.LaNew25_Customers as c
		inner join
			Orion.LaNew25_Transactions as t
			on c.Customer_ID = t.Customer_ID
		inner join
			Orion.LaNew25_Products as p
			on t.Product_ID = p.Product_ID
	where	p.Product_Line in ('Sports', 'Outdoors')
			and int(('01JAN2024'd - c.Date_of_Birth) / 365.25) >= 35
			and int(('01JAN2024'd - c.Date_of_Birth) / 365.25) <= 54
	group by	p.Product_Name
	order by	2 desc;
quit;