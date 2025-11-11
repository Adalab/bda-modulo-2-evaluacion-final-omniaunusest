USE sakila;

/* 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.*/

SELECT DISTINCT title
	FROM film;

/* 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".*/
SELECT title AS 'film', rating AS 'classified as'
	FROM film
    WHERE rating = 'PG-13';

/* 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.*/
SELECT title AS 'film', description
	FROM film
    WHERE description LIKE '%amazing%';
    
/* 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.*/
SELECT title AS 'film', length AS 'min.'
	FROM film
    WHERE length >= 120
    ORDER BY length ASC;

/* 5. Recupera los nombres de todos los actores.*/
SELECT CONCAT(first_name, ' ', last_name) AS 'actor name'
	FROM actor;
    
/* 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.*/
SELECT CONCAT(first_name, ' ', last_name) AS 'actor name'
	FROM actor
    WHERE last_name = 'Gibson';
    
/* 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.*/
SELECT CONCAT(first_name, ' ', last_name) AS 'actor name', actor_id
	FROM actor
    WHERE actor_id >=10 AND actor_id <= 20;
    
		/* ---- también podríamos consultarlo de esta otra manera ---- */

SELECT CONCAT(first_name, ' ', last_name) AS 'actor name', actor_id
	FROM actor
    WHERE actor_id BETWEEN 10 AND 20;
    
/* 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su
clasificación.*/
SELECT title AS 'film', rating AS 'classified as'
	FROM film
    WHERE rating NOT IN ('R', 'PG-13');
    
/* 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la
clasificación junto con el recuento*/
SELECT rating AS 'classified as', COUNT(*) AS 'total'
	FROM film
    GROUP BY rating;

/* 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su
nombre y apellido junto con la cantidad de películas alquiladas*/
SELECT c.customer_id AS 'customer ID',
	CONCAT(c.first_name, ' ', c.last_name) AS 'customer name',
    COUNT(r.rental_id) AS 'total rentals'
	FROM rental AS r
    LEFT JOIN customer AS c ON r.customer_id = c.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name;
		
/* 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría
junto con el recuento de alquileres.*/
SELECT c.name AS 'category', COUNT(r.rental_id) AS 'total rentals'
	FROM category AS c
    LEFT JOIN film_category
		ON c.category_id = film_category.category_id
    LEFT JOIN film AS f
		ON film_category.film_id = f.film_id
	LEFT JOIN inventory AS i
        ON f.film_id = i.film_id
	LEFT JOIN rental AS r
        ON i.inventory_id = r.inventory_id
        
	GROUP BY c.name;

	/* ---- elegimos el LEFT JOIN para contar también con las categorías
			que pudieran no tener alquileres, pero podría usarse perfectamente
            un JOIN de no necesitarlo. --- */
            
/* 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y
muestra la clasificación junto con el promedio de duración. */
SELECT rating AS 'classified as', ROUND(AVG(length)) AS 'average min.'
	FROM film
    GROUP by rating;
    
    /* --- para mejor legibilidad redondeamos la duración a una cifra de números enteros --- */
            
/* 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".*/
SELECT CONCAT(a.first_name, ' ', a.last_name) AS 'actor name', f.title AS film
	FROM actor AS a
    JOIN film_actor 
		ON a.actor_id = film_actor.actor_id
	JOIN film AS f
		ON film_actor.film_id = f.film_id
	WHERE f.title = 'Indian Love';
    
		/* ---- podríamos haber usado
				WHERE f.title = 'Indian Love'
                pero se ha priorizado encontrar coincidencias independientemente
                de si el nombre aparece incluido con mayúsculas o minúsculas ---- */
	
/* 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.*/
SELECT title AS film
	FROM film
    WHERE description LIKE '%dog%' OR '%cat%';
    
/* 15. Hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor.*/
SELECT actor_id, CONCAT(first_name, ' ', last_name) AS 'actor name'
	FROM actor
    WHERE actor_id NOT IN(SELECT actor_id
							FROM film_actor);
                
			/* ---- 0 rows returned ---- */

/* 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.*/
SELECT title, release_year AS 'release year'
	FROM film
    WHERE release_year BETWEEN 2006 AND 2010;
				
/* 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".*/
SELECT f.title AS film, c.name
	FROM film AS f
    JOIN film_category
		ON f.film_id = film_category.film_id
    JOIN category AS c
		ON film_category.category_id = c.category_id
	WHERE c.name = 'Family';
    
		/* ---- respondemos al caso de que la petición se refiera a la misma categoría 'Family' y no a la película 'Family',
			hacemos una comprobación de que tal película exista, por si acaso ---- */
    
    SELECT title
		FROM film
        WHERE title LIKE '%Family';
        
		/* ---- ... ---- */
        
/*18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.*/
	SELECT CONCAT(a.first_name, ' ', a.last_name) AS 'actor name', COUNT(film_actor.film_id) AS '# films'
		FROM actor AS a
        JOIN film_actor
			ON a.actor_id = film_actor.actor_id
		GROUP BY a.actor_id, a.first_name, a.last_name
        HAVING COUNT(film_actor.film_id) >= 10;
    
    /* ---- usamos HAVING en lugar de WHERE porque queremos FILTRAR después de agrupar + contar ---- */
    
/* 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la
tabla film. */
SELECT title AS 'film', rating AS 'classified as', length AS 'min.'
	FROM film
    WHERE rating = 'R' AND length > 120;

/* 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y
muestra el nombre de la categoría junto con el promedio de duración. */
SELECT c.name AS 'category', ROUND(AVG(f.length)) AS 'average min.'
	FROM category AS c
    JOIN film_category 
		ON c.category_id = film_category.category_id
	JOIN film AS f
		ON film_category.film_id = f.film_id
	GROUP BY c.name
    HAVING AVG(f.length) > 120;

		/* ---- ¿podríamos haber usado una subconsulta? sí, pero no es lo más óptimo. ---- */

/* 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto
con la cantidad de películas en las que han actuado. */
SELECT CONCAT(a.first_name, ' ', a.last_name) AS 'actor name', COUNT(film_actor.film_id) AS '# films'
		FROM actor AS a
        JOIN film_actor
			ON a.actor_id = film_actor.actor_id
		GROUP BY a.actor_id, a.first_name, a.last_name
        HAVING COUNT(film_actor.film_id) >= 5;

/* 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una
subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las
películas correspondientes. */
SELECT DISTINCT f.title AS 'film', DATEDIFF(r.return_date, r.rental_date) AS 'days on rent'
	FROM film AS f
    JOIN inventory AS i
		ON f.film_id = i.film_id
	JOIN rental AS r
		ON i.inventory_id = r.inventory_id
	WHERE
		r.rental_id IN (SELECT rental_id
							FROM rental
							WHERE DATEDIFF(return_date, rental_date) > 5);

			/* ---- elegimos DISTINCT para no obtener resultados repetidos para una misma película,
					sino -a criterio personal- evitar la reiteración de la duración de los alquileres*/

/* 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría
"Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la
categoría "Horror" y luego exclúyelos de la lista de actores. */
SELECT CONCAT(a.first_name, ' ', a.last_name) AS 'actor name', 'Not in Horror' AS 'genre'
	FROM actor AS a
    WHERE a.actor_id NOT IN (SELECT DISTINCT film_actor.actor_id
								FROM film_actor
                                JOIN film_category
									ON film_actor.film_id = film_category.film_id
								JOIN category AS c
									ON film_category.category_id = c.category_id
								WHERE c.name = 'Horror');

/* 24. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en
la tabla film. */
SELECT f.title AS 'film', c.name AS 'genre', f.length AS 'min.'
	FROM film AS f
    JOIN film_category
		ON f.film_id = film_category.film_id
	JOIN category AS c
		ON film_category.category_id = c.category_id
	WHERE c.name = 'comedy' AND f.length > 180;

			/*(((((( B O N U S )))))) 
            
25.Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos. */








