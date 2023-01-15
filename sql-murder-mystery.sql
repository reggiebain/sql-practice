-- My solution to the SQL Murder Mystery posed by https://mystery.knightlab.com/
-- Do not simply copy/paste this solution. This was a really fun and helpful exercise for learning/practicing SQL
-- Huge thanks to those who put this activity together. 

-- First pull the crime scene report
with report as(
	select * from crime_scene_report
	where city = 'SQL City' and type = 'murder' and date like '20180115%'
),
witness1 as(
	select * from person
	where address_street_name = 'Northwestern Dr'
	order by address_number desc
),
-- Get second witness testimony
witness2 as(
 	select * from person
  	where address_street_name = 'Franklin Ave' and name like 'Annabel%'
),
-- Combine tables to get witness testimonies
testimonies as (
	select * 
	from interview i
	join person p on i.person_id = p.id
	where p.name in ('Morty Schapiro', 'Annabel Miller', 'Jeremy Bowers')
),
-- Get people with gold membershp at get fit now, went on Jan 9 with id 48Z...
check_ins as (
	select * 
	from get_fit_now_check_in c 
  		join get_fit_now_member m on c.membership_id = m.id
  		join person p on p.name = m.name
  		join drivers_license dl on dl.id = p.license_id
	where c.check_in_date = '20180109'and membership_id like '48Z%'
)
--select * from income i join person p on i.ssn = p.ssn order by i.annual_income desc limit 10
select * 
from facebook_event_checkin fb 
	join person p on p.id = fb.person_id
	join drivers_license dl on dl.id = p.license_id
where fb.event_name like '%SQL Symphony Concert%' and fb.date like '201712%'
	and dl.hair_color = 'red' and dl.car_make = 'Tesla' and dl.car_model = 'Model S'
	and dl.gender = 'female' and dl.height between 65 and 67
