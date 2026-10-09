use dailychallenges_2;

create table farmers(
farmer_id int primary key,
first_name varchar(40),
last_name varchar(40),
email varchar(30),
hire_date date
);

create table plots(
plot_id int primary key,
plot_name varchar(50),
farmer_id int,
crop_type varchar(40),
soil_type varchar(15),
foreign key (farmer_id) references farmers(farmer_id)
);

create table yields (
yield_id int primary key,
plot_id int,
harvest_date date,
yield_kg decimal(10,2),
weather_condition varchar(30),
foreign key (plot_id) references plots(plot_id)
);

create table irrigation_logs(
log_id int primary key,
plot_id int,
irrigation_date date,
water_amount_liters decimal (10,2),
foreign key (plot_id) references plots(plot_id)
);


-- 1. Productivity & Performance
-- • Identify the top 3 most productive plots based on average yield per harvest. Show the
-- plot_name, crop_type, and average_yield_kg.


select p.plot_name as plot_name , p.crop_type as crop_type, avg(yield_kg) as average_yield_kg from plots p
join yields y
on p.plot_id = y.plot_id
group by plot_name,crop_type
order by average_yield_kg desc
limit 3;

-- • Calculate the total water consumption for each plot and rank them from highest to
-- lowest. Show plot_name and total_water_liters

select p.plot_name as plot_name , coalesce(sum(i.water_amount_liters)) as total_water_liters
from plots p join irrigation_logs i 
on p.plot_id = i.plot_id
group by p.plot_id,p.plot_name
order by total_water_liters desc;

-- 2. Yield & Environmental Analysis
-- • Determine the average yield for each crop type under different weather conditions. The
-- output should have crop_type, weather_condition, and average_yield_kg.

select p.crop_type as crop_type, y.weather_condition as weather_condition, avg(y.yield_kg) as average_yield_kg from plots p 
join yields y 
on p.plot_id = y.plot_id
group by crop_type, weather_condition;

-- • Find the highest-yielding plot for each soil type. Show the soil_type, plot_name, and
-- highest_yield_kg.

select p.soil_type as soil_type, p.plot_name as plot_name , max(y.yield_kg) as highest_yield_kg
from plots p join yields y
on p.plot_id = y.plot_id
group by soil_type, plot_name
order by highest_yield_kg desc
limit 1;

-- 3. Farmer & Resource Management
-- • Identify the farmer who manages the plots with the lowest average water
-- consumption. Show the first_name, last_name, and their plots'
-- average_water_liters_per_plot.

with plot_water as (
select p.Plot_id as plot_id, p.farmer_id as farmer_id, coalesce(sum(i.water_amount_liters)) as total_water_liters_per_plot
from plots p left join irrigation_logs i 
on p.plot_id = i.plot_id
group by plot_id, farmer_id
)
select f.first_name as farmer_first_name , f.last_name as farmer_last_name, avg(pw.total_water_liters_per_plot) as average_water_liters_per_plot 
from  farmers f left join plot_water pw
on f.farmer_id = pw.farmer_id
group by farmer_first_name,farmer_last_name
order by average_water_liters_per_plot asc
limit 1;


-- • Calculate the number of harvests per month for the last 12 months. Show the month
-- and the number of harvests.

select monthname(harvest_date) as month , count(*) as number_of_harvests
from yields
group by month;


-- 4. Advanced Analysis (Bonus)
-- • Find plots that have a below-average yield for their specific crop type but an aboveaverage water consumption compared to all other plots with the same crop. List the
-- plot_name, crop_type, yield_kg, and water_amount_liters.

WITH plot_stats AS (
  SELECT p.plot_id, p.plot_name, p.crop_type,
         (SELECT AVG(yield_kg) FROM yields y WHERE y.plot_id = p.plot_id) AS yield_kg,
         (SELECT COALESCE(SUM(water_amount_liters), 0)
          FROM irrigation_logs i WHERE i.plot_id = p.plot_id) AS water_amount_liters
  FROM plots p
),
with_crop_avg AS (
  SELECT *,
         AVG(yield_kg) OVER (PARTITION BY crop_type) AS crop_avg_yield,
         AVG(water_amount_liters) OVER (PARTITION BY crop_type) AS crop_avg_water
  FROM plot_stats
)
SELECT plot_name, crop_type, ROUND(yield_kg, 2) AS yield_kg, water_amount_liters
FROM with_crop_avg
WHERE yield_kg < crop_avg_yield AND water_amount_liters > crop_avg_water;
