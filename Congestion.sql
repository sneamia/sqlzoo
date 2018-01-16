/* Congestion Charging
	https://sqlzoo.net/wiki/Congestion_Charging */

/* - Congestion Easy */
/* -- Question 1 */
select keeper.name, keeper.address from keeper inner join vehicle on keeper.id=vehicle.keeper where vehicle.id='SO 02 PSP' group by keeper.name, keeper.address;

/* -- Question 2 */
select count(*) from camera;

/* -- Question 3 */
select image.camera, image.whn, image.reg from image where image.camera=10  and image.whn < '2007-02-26';

/* -- Question 4 */
select image.camera, count(*) from image
  where camera not in (15, 16, 17, 18, 19)
  group by camera;

/* -- Question 5 */
 -- Names and addresses 
select keeper.name, keeper.address from keeper inner join (
select * from permit inner join vehicle
  on vehicle.id=permit.reg
  where sDate= '2007-01-30') as temp1 on temp1.keeper=keeper.id
  group by keeper.name, keeper.address
  order by keeper.name asc;

-- Vehicles with keeper ID with registrations starting on 1/30/2007 
select * from permit inner join vehicle
  on vehicle.id=permit.reg
  where sDate= '2007-01-30';

-- Vehicles with registrations starting on 1/30/2007
select * from permit where sDate = '2007-01-30';

/* - Congestion Medium */
/* -- Question 1 */
select name, address from image inner join (select vehicle.id as reg, keeper.name, keeper.address from keeper inner join vehicle on keeper.id=vehicle.keeper group by vehicle.id, keeper.name, keeper.address) as reg_owner on image.reg=reg_owner.reg where image.camera in (1, 18) group by name, address;

 -- Reg to owner
select vehicle.id as reg, keeper.name, keeper.address from keeper inner join vehicle on keeper.id=vehicle.keeper group by vehicle.id, keeper.name, keeper.address;

 -- Reg caught by 1 or 18 
select image.reg from image where image.camera in (1, 18) group by reg;

/* -- Question 2*/
 -- Count of vehicles by owner 
select keeper, count (*) as count from vehicle group by keeper;

 -- Names and addresses of owners with over 5 vehicles 
select name, address from keeper inner join (select keeper, count (*) as count from vehicle group by keeper) as vehicle_count on keeper.id=vehicle_count.keeper where vehicle_count.count >5;

/* -- Question 3*/
select reg, sum(
	case
		when chargeType = 'Daily' then sDate + interval 1 day > '2007-02-01' and sDate <= '2007-02-01'
		when chargeType = 'Weekly' then sDate + interval 1 week > '2007-02-01' and sDate <= '2007-02-01'
		when chargeType = 'Monthly' then sDate + interval 1 month > '2007-02-01' and sDate <= '2007-02-01'
		when chargeType = 'Annual' then sDate + interval 1 year > '2007-02-01' and sDate <= '2007-02-01'
	end) as current from permit group by reg;

/* -- Question 4*/
select whn, reg, name from image left outer join (
	select vehicle.id, name from keeper inner join vehicle on keeper.id = vehicle.keeper
	) as names on image.reg = names.id
	where camera = '10' and whn < '2007-02-26' and whn >= '2007-02-25';

/* -- Question 5*/
select name, vehicle_count from (
	select name, keeper.id from (
		select keeper, sum(permit_count) as permit_count from (
			select reg, count(*) as permit_count from permit group by reg
		) as count_by_vehicle left outer join vehicle on count_by_vehicle.reg=vehicle.id group by keeper
	) as permit_counts left outer join keeper on keeper.id=keeper
	where permit_count > 2
) as names left outer join (
	select keeper, count(*) as vehicle_count from vehicle group by keeper
) as counts on names.id=counts.keeper where vehicle_count > 4;

-- Check
select name, reg, sDate from keeper left outer join vehicle on keeper.id=keeper
	left outer join permit on vehicle.id=reg
	where name = 'Inconspicuous, Iain'
	order by reg, sDate;