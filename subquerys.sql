-- 1.Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT 
    COUNT(DISTINCT inventory_id) AS inventory_count
FROM
    inventory
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            film
        WHERE
            title = 'Hunchback Impossible');
	
-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.
Select 
	title, 
    length
from 
	film 
where  length > (SELECT
		AVG(length) as avg_length 	
	from 
		film);

-- 3. Use a subquery to display all actors who appear in the film "Alone Trip"


SELECT 
	actor_id,
    concat(first_name,' ',last_name) as actor_name
from 
	actor
where  actor_id IN (select 
	actor_id
from 
	film_actor
where 
	film_id =(select 
					film_id
				from 
					film
				where 
					title = 'Alone Trip')
                    );
-- Bonus:
-- 4.Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.


select title
from film
where film_id IN(select film_id
				from film_category
				where 	category_id IN (SELECT category_id
										from category
										where name='Family'
                                        )
				);
	
-- 5.Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.
SELECT 
	concat(c.first_name,' ',c.last_name) as actor_name,
    c.email
from customer c
	join address a 
		on c.address_id = a.address_id
	join city ci 
		on a.city_id = ci.city_id
where ci.country_id IN(select country_id
						from country
						where country = 'Canada');
                        
-- 6.Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. 
	-- First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.
    
SELECT 
	f.title
FROM film f
JOIN film_actor fa 
	ON f.film_id = fa.film_id
WHERE fa.actor_id = (
    SELECT actor_id
    FROM film_actor
    GROUP BY actor_id
    ORDER BY COUNT(film_id) DESC
    LIMIT 1
);
    
-- 7.Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.

SELECT 
	DISTINCT f.title
FROM rental r
JOIN inventory i 
	ON r.inventory_id = i.inventory_id
JOIN film f 
	ON i.film_id = f.film_id
WHERE r.customer_id = (
    SELECT customer_id
    FROM payment
    GROUP BY customer_id
    ORDER BY SUM(amount) DESC
    LIMIT 1
);
-- 8.Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.

SELECT 
	customer_id,
    sum(amount) as total_amount_spent
from payment 
group by 
	customer_id
having sum(amount) > (
	SELECT 
		round(AVG(total_spent),2) as average_spent
	FROM
		(select 
			customer_id, 
			sum(amount) as total_spent
		from
			payment
		group by 
			customer_id
		) as customer_totals
	);