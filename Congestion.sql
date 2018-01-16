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

