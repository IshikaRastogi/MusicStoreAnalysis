--Deriving insights from the data:

--SENIOR MOST EMPLOYEE BASED on THE JOB TITLE
select * from EMPLOYEE
order by LEVELS desc
limit 1;

--COUNTRIES WHICH HAVE THE MOST INVOICES
select COUNT(*), billing_country 
from invoice i 
group by billing_country
order by COUNT desc;

--TOP 3 VALUES of TOTAL INVOICES
select TOTAL from INVOICE I
order by TOTAL desc 
limit 3;

--WHICH CITY HAS THE BEST CUSTOMERS? WE WOULD LIKE TO THROW A PROMOTIONAL MUSIC FESTIVAL IN THE CITY WE MADE THE MOST MONEY.
--WRITE A QUERY THAT RETURNS ONE CITY THAT HAS THE HIGHEST SUM OF INVOICE TOTALS.RETURN BOTH THE CITY NAME AND THE SUM OF ALL INVOICE TOTALS.
select BILLING_CITY, SUM(TOTAL) as INVOICE_TOTAL from invoice i 
group by billing_city
order by INVOICE_TOTAL desc

--WHO IS THE BEST CUSTOMER? THE CUSTOMER WHO HAS SPENT THE MOST MONEY IS THE BEST CUSTOMER.
--WRITE A QUERY THAT RETURNS THE PERSON WHO SPENT THE MOST MONEY.
select C.customer_id ,C.FIRST_NAME, C.LAST_NAME, SUM(I.TOTAL) as INVOICE_TOTAL 
from CUSTOMER C, INVOICE I
where C.customer_id = I.customer_id 
group by C.customer_id 
order by INVOICE_TOTAL desc
limit 1;

--WRITE A QUERY TO RETURN THE EMAIL,FIRST NAME, LAST NAME & GENRE OF ALL ROCK MUSIC LISTENERS.
--RETURN YOUR LIST ORDERED ALPHABETICALLY BY EMAIL STARTING WITH A
select distinct c.first_name as FirstName, c.last_name as Lastname, c.email as Email from customer c 
join invoice i on c.customer_id =i.customer_id 
join invoice_line il on i.invoice_id =il.invoice_id 
where track_id in
(select track_id from track 
join genre on track.genre_id= genre.genre_id
where genre.name ='Rock')
order by email 

--Let's invite the artists who have written the most rock music in our dataset. Write a 
--query that returns the Artist name and total track count of the top 10 rock bands
select artist.artist_id , artist.name, count(artist.artist_id) as number_of_songs
from track 
join album on album.album_id =track.album_id 
join artist  on artist.artist_id =album.artist_id 
join genre on genre.genre_id = track.genre_id 
where genre.name ='Rock'
group by artist.artist_id 
order by number_of_songs desc 
limit 10;

--Return all the song names that have a song length longer than the average song length.
select name, milliseconds 
from track 
where milliseconds > (
select avg(milliseconds) as avg_track_length
from track )
order by milliseconds desc;

--Find how much amount spent by each customer on artists? Write a query to return 
--customer name, artist name and total spent 
--(using cte)
with best_selling_artist as(
	select artist.artist_id as artist_id, artist.name as artist_name,
	sum(invoice_line.unit_price*invoice_line.quantity) as total_sales
	from invoice_line 
	join track on track.track_id =invoice_line.track_id 
	join album on album.album_id = track.album_id 
	join artist on artist.artist_id =album.artist_id 
	group by 1
	order by 3 desc
	limit 1
)
select c.customer_id, c.first_name, c.last_name, bsa.artist_name,
SUM(il.unit_price*il.quantity) as amount_spent
from invoice i
join customer c on c.customer_id=i.customer_id 
join invoice_line il on il.invoice_id=i.invoice_id 
join track t on t.track_id=il.track_id 
join album alb on alb.album_id =t.album_id 
join best_selling_artist bsa on bsa.artist_id= alb.artist_id 
group by 1,2,3,4
order by 5 desc;


--We want to find out the most popular music Genre for each country.
--( We determine the most popular genre as the genre with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where the maximum 
--number of purchases is shared return all Genres)
with popular_genre as 
(
	select count(invoice_line.quantity) as purchases, customer.country,genre.name, genre.genre_id,
	row_number() over(partition by customer.country order by count(invoice_line.quantity) desc) as RowNo
	from invoice_line 
	join invoice on invoice.invoice_id = invoice_line.invoice_id 
	join customer on customer.customer_id = invoice.customer_id 
	join track on track.track_id = invoice_line.track_id 
	join genre on genre.genre_id= track.genre_id 
	group by 2,3,4
	order by 2 asc, 1 desc
)
select * from popular_genre where RowNo<=1


--Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the country along with the top customer and how 
--much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount
WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1

