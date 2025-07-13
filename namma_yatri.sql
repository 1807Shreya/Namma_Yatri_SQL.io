create database namma_yatri
use namma_yatri

CREATE TABLE  trips(
	tripid integer,
	faremethod integer,
	fare integer,
	loc_from integer,
	loc_to integer,
	driverid integer,
	custid integer,
	distance integer,
	duration integer); 
 
CREATE TABLE  trips_details1(
	tripid	integer,
    loc_from integer,
    searches integer,
    searches_got_estimate integer,
    searches_for_quotes integer,
    searches_got_quotes	integer,
    customer_not_cancelled	integer,
    driver_not_cancelled integer,
    otp_entered integer,
    end_ride integer); 
    
CREATE TABLE  trips_details2(
	tripid	integer,
    loc_from integer,
    searches integer,
    searches_got_estimate integer,
    searches_for_quotes integer,
    searches_got_quotes	integer,
    customer_not_cancelled	integer,
    driver_not_cancelled integer,
    otp_entered integer,
    end_ride integer); 
    
CREATE TABLE  trips_details3(
	tripid	integer,
    loc_from integer,
    searches integer,
    searches_got_estimate integer,
    searches_for_quotes integer,
    searches_got_quotes	integer,
    customer_not_cancelled	integer,
    driver_not_cancelled integer,
    otp_entered integer,
    end_ride integer); 

CREATE TABLE  trips_details4 (tripid integer,
	loc_from integer,
    searches integer,	
    searches_got_estimate integer,
    searches_for_quotes	integer,
    searches_got_quotes	integer,
    customer_not_cancelled integer,
    driver_not_cancelled integer,
    otp_entered	integer,
    end_ride integer);

insert into trips_details4 
select * from trips_details1
union
select * from trips_details2
union
select * from trips_details3;

CREATE TABLE loc( id INT, assembly1 varchar(200)); 

CREATE TABLE payment( id INT, method varchar(200)); 

CREATE TABLE duration( id INT, duration varchar(200)); 




 -- total trips
 SELECT COUNT(distinct tripid) 
FROM trips_details4;

-- total drivers
SELECT COUNT(distinct driverid)
FROM trips;

-- total earnings
SELECT SUM(fare) total_earnings
FROM trips;

-- total Completed trips
SELECT * FROM trips_details4;

SELECT SUM(end_ride) completed_trips
FROM trips_details4;

-- total searches
SELECT  SUM(searches) searches
FROM trips_details4;

-- total searches which got estimate
SELECT SUM(searches_got_estimate)
FROM trips_details4;

-- total searches for quotes
SELECT SUM(searches_for_quotes)
FROM trips_details4;

-- total drivers cancelled
SELECT COUNT(*) - SUM(driver_not_cancelled) total_drivers_cancelled
FROM trips_details4;

-- total otp entered
SELECT SUM(otp_entered) otp_entered
FROM trips_details4;

-- total end ride
SELECT SUM(end_ride) total_end_ride
FROM trips_details4;

-- AVG distance per trip
SELECT AVG(distance) AVG_distance_per_trip
FROM trips;

 -- AVG fare per trip 
SELECT AVG(fare) AVG_fare_per_trip
FROM trips;

-- distance travelled
SELECT SUM(distance) total_distance_travelled
FROM trips;

-- which is the most used payment method
SELECT a.method FROM payment a 
inner join
	(SELECT faremethod, COUNT(DISTINCT tripid) as cnt
	FROM trips
	GROUP BY faremethod 
	ORDER BY cnt DESC LIMIT 1)
b on a.id=b.faremethod  ;

-- what is the highest payment done & its method 
SELECT faremethod, SUM(fare) total_fare
FROM trips
GROUP BY faremethod 
ORDER BY total_fare DESC LIMIT 1;

SELECT a.method FROM payment a
INNER JOIN
    (SELECT faremethod, SUM(fare) as highest_fare
	FROM trips
	GROUP BY faremethod
	ORDER BY highest_fare DESC LIMIT 1)
b ON a.id=b.faremethod
;

-- which 2 locations had most trips
SELECT * FROM	
    (SELECT *, dense_rank() OVER(order by most_trips desc) rnk
	FROM
		(SELECT loc_from,loc_to, COUNT(DISTINCT tripid) most_trips
		FROM trips
		GROUP BY loc_from, loc_to) a)
	b
WHERE rnk=1;

-- top 5 earning drivers by total fare
select * from
	(select *, dense_rank() over(order by top_earning_drivers desc ) rnk	
	from
		(select driverid, sum(fare) top_earning_drivers
		from trips
		group by driverid)a)b
where rnk<=5;

-- top 5 Drivers by Max Single Fare
select driverid, max(fare) maxfare
from trips
group by driverid
order by maxfare desc limit 5;

-- which duration had more trips
select * from	
    (select *, rank() over(order by max_trips desc) rnk
	from
		(select duration, count(tripid) max_trips
		from trips
		group by duration)a)b
where rnk=1;

-- which driver & customer pair had more orders
select*from trips;

select * from
	(select *, rank() over(order by total_orders desc) rnk
	from
		(select custid, driverid, count(*) total_orders
		from trips
		group by custid, driverid) a
	) b
where rnk = 1;

-- search to estimate rate
select sum(searches_got_estimate)*100/sum(searches) "search to estimate rate"
from trips_details4;

-- estimate to search for quote rates
select sum(searches_for_quotes)*100 /sum(searches_got_estimate) "estimate to search for quote rates"
from trips_details4;

-- quote to booking rate
select * from trips_details4;

select sum(searches_got_quotes)*100 /sum(searches_for_quotes) "quote to booking rate"
from trips_details4;

-- booking cancellation rate
select 
	round(
			(sum(searches_got_quotes)-sum(end_ride))*100 / nullif(sum(searches_got_quotes),0), 
		2
	) as "booking cancellation rate"
from trips_details4;

-- which area got highest trips in which duration
select * from trips

select * from
	(select *, rank() over(partition by duration order by cnt desc) rnk
	from
		(select  loc_from, duration, count(distinct tripid) cnt
		from trips
		group by loc_from, duration)z
	)y
where rnk=1;

-- which area got the highest fares, cancellations, trips
select* from
	(select *, rank() over(order by fare desc) rnk
	from
		(select loc_from, sum(fare) fare
		from trips
		group by loc_from) m
	) n
where rnk=1;

-- can1
select* from
	(select *, rank() over(order by cancellations desc) rnk
	from
		(select loc_from, 
         sum(searches_got_quotes) - sum(driver_not_cancelled) - sum(customer_not_cancelled) cancellations
		from trips_details4
		group by loc_from) a
	) b
where rnk = 1;

-- can2
select* from
	(select *, rank() over(order by can desc ) rnk
	from
		(select loc_from , count(driver_not_cancelled) as can
		from trips_details4
		group by loc_from )a
	) b 
where rnk =1;

select * from
(select *, dense_rank() over(partition by loc_from order by rides desc) rnk
from
	(select loc_from, sum(end_ride) rides
	from trips_details4
	group by loc_from)a
) b
where rnk=1

-- which duration got the highest trips, fairs
select * from trips

select * from
	(select *, rank() over(order by fare desc) rnk
    from
		(select duration, sum(fare) fare
		from trips
		group by duration) a
	) b
where rnk =1;


select * from
	(select *, rank() over(order by trips desc) rnk
    from
		(select duration, count(distinct tripid) trips
		from trips
		group by duration) a
	) b
where rnk =1;