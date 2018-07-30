use sakila;
-- dispaly first name and last name
select first_name, last_name from actor; 
-- dispaying actor name on single column
select CONCAT(first_name, ' ', last_name) as 'Actor Name' from   actor;

-- display first name, last name and Id of an actor based on the first name
select actor_id, first_name, last_name from actor
	where first_name='Joe';

-- names of actors whose last name contains the letter 'GEN'
select first_name, last_name from actor
	having last_name like '%GEN%';
    
-- last name contains letters 'LI' and order them by last and frist names. 

select first_name, last_name from actor
	having last_name like '%LI%'
order by 2,1 desc; 

-- using the IN function to diaplay country Afghanistan, Bangladesh and China 
select country_id, country
	from country 
	where country_id in (1, 12, 23);
    
 -- add column middle_name b/n first name and last name 
select * from actor limit 10;

alter table actor 
add column middle_name varchar(20) after first_name; 
    
-- changing the datatype into blob 
alter table actor modify middle_name BLOB; 

-- deleting a column middle name

alter table actor drop column middle_name;

-- last name counts

select last_name, count(last_name) as `count of last_names`
	from   actor
group by last_name;

-- last_names shared by at least 2 actors 

select * from actor where last_name in
     (select last_name from actor group by last_name having count(last_name)>1)
order by last_name;

-- query to change a row (value) wrongly recorded first_name

select actor_id, first_name, last_name from actor 
	where last_name='WILLIAMS';   
update actor
	set first_name = 'HARPO'
where first_name = 'GROUCHO' and last_name='WILLIAMS' and actor_id = 172;

-- changing the actor first name to its original value

update actor
	set first_name = 'GROUCHO'
where first_name = 'HARPO' and last_name='WILLIAMS' and actor_id = 172;

-- recreate a schema for the address table or I can use the create table command 

-- create schema address_schema Autorization me;

-- first name, last name and address of staff memebers 
select s. first_name, s.last_name, a.address
from staff s
join address a on s.address_id=a.address_id; 

-- the total amount rung by each staff member 

select s.staff_id, cast(p.payment_date as date), sum(p.amount) as total_by_staff_memebr
from staff s
join payment p on s.staff_id=p.staff_id
where cast(p.payment_date as date)
between '2005-07-31' and '2005-09-01'
group by s.staff_id;

-- the total amount rung by each staff member for August 2005

select staff_id, sum(amount) as total_amount from payment
where cast(payment_date AS DATE)
between '2005-07-31' and '2005-09-07'
group by staff_id;

-- list each film and # actors listed for that film.

select count(fa.actor_id) as total_number_of_actors, f.title as film_title
from film_actor fa
inner join film f on fa.film_id=f.film_id
group by f.title
order by total_number_of_actors desc;

-- the number of copies for Hunchback Impossibe 
select f.title as film_title, count(i.inventory_id) number_of_copies from inventory i
join film f on f.film_id=i.film_id 
where f.title='Hunchback Impossible';

-- total amount paid by each customer 

select c.first_name, c.last_name,sum(p.amount) as Total_Amount_Paid
from customer c
join payment p on c.customer_id=p.customer_id
group by c.customer_id
order by c.last_name;

-- subqueries to dispaly films starting in Q or K

select f.title, l.name from film f, language l
  where f.title like 'Q%' or f.title like 'K%' and 
  l.name=(select l.name from language l where l.name='English');
  
--  subqueries to dispaly actors staring in 'Alone Trip'

select a.first_name, a.last_name, f.title from actor a, film f
  where f.title=(select f.title from film f where f.title='Alone Trip');
  
-- marketing campaign in Canada 

select c.first_name, c.last_name, c.email, a.address
from customer c
join address a on c.address_id=a.address_id
where a.location='OLD'; 


select c.first_name, c.last_name, c.email, a.district from customer c, address a
  where a.district=(select a.district from address a where a.location='Canada');

-- all movies catagorized as family movies 

select title, rating from film 
  where rating='G';
  
-- most frequently rented movies by frequency 

select * from rental limit 10;

select r.inventory_id, count(r.rental_date) as frequency, r.return_date from rental r
  group by r.inventory_id
order by count(r.rental_date) desc;

-- Revenue by store 


select s.store_id,sum(p.amount) as Total_Revenue
from payment p
join staff s  on s.staff_id=p.staff_id
group by s.store_id
order by s.store_id;

-- store info 



select s.store_id, a.location, a.district, a.city_id 
from store s
join address a  on a.address_id=s.address_id;

-- top 5 genres on gross revenue 
select c.name as Genres, sum(p.amount) as Total_Revenue from film f 
join film_category fc on f.film_id=fc.film_id
join inventory i on f.film_id=i.film_id
join rental r on r.inventory_id=i.inventory_id
join category c on fc.category_id=c.category_id
join payment p on p.rental_id=r.rental_id
group by c.name
order by Total_Revenue desc limit 5;

-- create a view on top 5 genres on gross revenue 

create view top_5_genres_gross_revenue as 
select c.name as Genres, sum(p.amount) as Total_Revenue from film f 
join film_category fc on f.film_id=fc.film_id
join inventory i on f.film_id=i.film_id
join rental r on r.inventory_id=i.inventory_id
join category c on fc.category_id=c.category_id
join payment p on p.rental_id=r.rental_id
group by c.name
order by Total_Revenue desc limit 5;

-- the view created above can be found on the left panel under the view section. 

-- deleting a view 
drop view top_5_genres_gross_revenue;










 