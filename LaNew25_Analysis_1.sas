proc sql number;
title	'z5295984 Dominik Xiong';
select	Employee_ID 'Employee ID',
		Salary format = dollar12.2 'Salary',
		case
			when Salary <= 18200 then 0
			when Salary <= 45000 then (Salary - 18200) * 0.19
			when Salary <= 120000 then (Salary - 45000) * 0.325 + 5092
			when Salary <= 180000 then (Salary - 120000) * 0.37 + 29467
			else (Salary - 180000) * 0.45 + 51667
		end format = dollar12.2 'Tax'
	from Orion.Lanew25_Employees
	where TermDate > '01Jan2024'd
	and country = 'AU'
	order by 3 desc;
quit;

proc sql number;
create table Orion.LaNew25_CurrentOzEmpTax as
select	Employee_ID as Employee_ID,
		Salary format = dollar12.2 as Salary,
		case
			when Salary <= 18200 then 0
			when Salary <= 45000 then (Salary - 18200) * 0.19
			when Salary <= 120000 then (Salary - 45000) * 0.325 + 5092
			when Salary <= 180000 then (Salary - 120000) * 0.37 + 29467
			else (Salary - 180000) * 0.45 + 51667
		end format = dollar12.2 as Tax
	from Orion.Lanew25_Employees
	where TermDate > '01Jan2024'd
	and country = 'AU'
	order by 3 desc;
quit;

proc sql number;
create table Orion.LaNew25_CurrentOzEmpTaxRange as
select	Employee_ID,
		Salary,
		Tax,
		case
			when Tax <= 10000 then '$0 - $10,000'
      		when Tax <= 30000 then '$10,001 - $30,000'
      		when Tax <= 50000 then '$30,001 - $50,000'
      		when Tax <= 70000 then '$50,001 - $70,000'
      		when Tax < 100000 then '$70,001 - $100,000'
      		else '> $100,000'
		end as Tax_Range
	from Orion.LaNew25_CurrentOzEmpTax;
quit;

proc sql number;
title 'z5295984 Dominik Xiong';
select	Tax_Range 'Tax Range',
		count(*) 'Number of Employees'
	from Orion.LaNew25_CurrentOzEmpTaxRange
	group by Tax_Range;
quit;

proc sql number;
title 'z5295984 Dominik Xiong';
select	int((HireDate - Date_of_Birth)/365.25) 'Hiring Age',
		sum(case when Gender = 'M' then 1 else 0 end) 'Number of Male Employees',
		sum(case when Gender = 'F' then 1 else 0 end) 'Number of Female Employees'
	from Orion.LaNew25_Employees
	where TermDate > '01JAN2024'd
	group by int((HireDate - Date_of_Birth)/365.25)
	order by 1 desc;
quit;

proc sql number;
title 'z5295984 Dominik Xiong';
select	Country 'Country',
		Activity_Level 'Active Level',
		mean(int(('01JAN2024'd - Date_of_Birth)/365.25)) format = 6.1 'Average Age'
	from Orion.LaNew25_Customers
	group by	Country,
				Activity_Level
	order by	Country asc,
				Activity_Level asc;
quit;

proc sql number;
title 'z5295984 Dominik Xiong';
select	Product_Line 'Product Line',
		mean((Unit_Sales_Price / Unit_Cost) - 1) format = percent8.1 'Average Unit Margin'
	from Orion.LaNew25_Products
	where Supplier_Country in ('BE', 'CA', 'DK', 'FR', 'GB', 'NL', 'NO', 'PT', 'SE', 'US')
	group by Product_Line
	having mean((Unit_Sales_Price / Unit_Cost) - 1) > 1.25
	order by 2 asc;
quit;