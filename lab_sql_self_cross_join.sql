-- 1. Get all pairs of actors that worked together.
select * from sakila.film_actor a1
join sakila.film_actor a2
on a1.film_id = a2.film_id
and a1.actor_id > a2.actor_id  -- the same as != (not equal to) 
order by a1.film_id, a1.actor_id, a2.actor_id;

select a1.film_id, f.title, a1.actor_id, concat(a3.first_name, ' ', a3.last_name) as 'actor_1', a2.actor_id, concat(a4.first_name, ' ', a4.last_name) as 'actor_2'
from sakila.film_actor a1
join sakila.film f
on a1.film_id = f.film_id
join sakila.film_actor a2
on a1.film_id = a2.film_id
and a1.actor_id > a2.actor_id  -- the same as != (not equal to)
join sakila.actor a3
on a1.actor_id = a3.actor_id 
join sakila.actor a4 
on a2.actor_id = a4.actor_id
order by a1.film_id, f.title, a1.actor_id, a2.actor_id, a3.first_name, a3.last_name, a4.first_name, a4.last_name;

-- 2. Get all pairs of customers that have rented the same film more than 3 times.
select r.customer_id, concat(c.first_name, ' ', c.last_name) as customer_name, i.film_id, f.title
from sakila.rental r
join sakila.inventory i 
on r.inventory_id = i.inventory_id
join sakila.customer c 
on r.customer_id = c.customer_id
join sakila.film f
on i.film_id = f.film_id;

select c.customer_id, concat(c.first_name, ' ', c.last_name) as customer_name, i.film_id, f.title, count(i.film_id) as rental_count
from sakila.customer c
join sakila.rental r
on c.customer_id = r.customer_id
join sakila.inventory i 
on r.inventory_id = i.inventory_id
join sakila.film f
on i.film_id = f.film_id
group by c.customer_id, i.film_id
having count(i.film_id) >= 3
order by c.customer_id;

select cr1.customer_id, count(cr1.film_id) as customer1_rental, cr2.customer_id, count(cr2.film_id) as customer2_rental
from (select r.customer_id, i.film_id
		from sakila.rental r
		join sakila.inventory i 
		on r.inventory_id = i.inventory_id) cr1
join (select r.customer_id, i.film_id
		from sakila.rental r
		join sakila.inventory i 
		on r.inventory_id = i.inventory_id) cr2
on cr1.film_id = cr2.film_id
and cr1.customer_id > cr2.customer_id
group by cr1.customer_id, cr2.customer_id
having count(cr1.film_id) >= 3 and count(cr2.film_id) >= 3;

select cr1.title, cr1.customer_id, cr1.customer_name, count(cr1.film_id) as customer1_rental, cr2.customer_id, cr2.customer_name, count(cr2.film_id) as customer2_rental
from (select r.customer_id, concat(c.first_name, ' ', c.last_name) as customer_name, i.film_id, f.title
		from sakila.rental r
		join sakila.inventory i 
		on r.inventory_id = i.inventory_id
		join sakila.customer c 
		on r.customer_id = c.customer_id
		join sakila.film f
		on i.film_id = f.film_id) cr1
join (select r.customer_id, concat(c.first_name, ' ', c.last_name) as customer_name, i.film_id, f.title
		from sakila.rental r
		join sakila.inventory i 
		on r.inventory_id = i.inventory_id
		join sakila.customer c 
		on r.customer_id = c.customer_id
		join sakila.film f
		on i.film_id = f.film_id) cr2
on cr1.film_id = cr2.film_id
and cr1.customer_id > cr2.customer_id
group by cr1.customer_id, cr2.customer_id, cr1.film_id
having count(cr1.film_id) >= 3 and count(cr2.film_id) >= 3;

-- 3. Get all possible pairs of actors and films.
create temporary table actor_details
select concat(first_name, ' ', last_name) as 'actor_name' from sakila.actor;

create temporary table film_details
select distinct title as film from sakila.film;

select * from film_details
cross join actor_details;