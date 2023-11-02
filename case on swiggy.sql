-- Q1 find the customer who have never ordered

select name from 
usere 
where user_id not in (select user_id from orders); -- called nested query

-- Q2 find Average price/ dish

select f_id,avg(price) from menu group by f_id;

SELECT food.f_name, AVG(price) AS 'avg_Price'
FROM menu
JOIN food ON menu.f_id = food.f_id
GROUP BY menu.f_id, food.f_name;

-- Q3 find maximum avg_price/dish

SELECT food.f_name, AVG(price) AS 'avg_Price'
FROM menu
JOIN food ON menu.f_id = food.f_id
GROUP BY menu.f_id, food.f_name, menu.price
ORDER BY menu.price DESC
LIMIT 0, 50000;

-- Q4  Find the top restautant in terms of number of orders foe a give (jun)month 

-- first we extract month from date column.

select * ,monthname(date) from orders;

select * ,monthname(date) from orders where monthname(date)="may";

select r_id,count(*) as "month"
from orders
where monthname(date) like 'may'
group by r_id
order by count(*) desc limit 1;

-- Q5 restautant with monthly sales> x (thrshold value) for

SELECT r.r_name, sub.revenue
FROM (
    SELECT orders.r_id, SUM(orders.amount) AS revenue
    FROM orders 
    WHERE MONTHNAME(orders.date) = 'June'
    GROUP BY orders.r_id
    HAVING revenue > 500
) AS sub
JOIN restaurent r ON sub.r_id = r.r_id
ORDER BY sub.revenue DESC
LIMIT 50000;

-- Q6 show all the orders with order details for perticular customer in a perticular data range

-- for example i whant to know about 'Nitish' order history in given range (10 jun to 15 jully)

select * from orders where user_id=4
and (date>'2022-06-10' and date < '2022-07-10');

-- find in which restaurent "nitish" orders food and which food they order?

select orders.order_id,restaurent.r_name,food.f_name
from orders
join restaurent
on restaurent.r_id=orders.r_id
join order_details 
on orders.order_id=order_details.order_id
join food
on food.f_id=order_details.f_id
where user_id=(select user_id from usere where name like 'Nitish')
and (date> '2022-06-10' and date < '2022-07-10');

-- similar for 'Neha' from date (5 jully to 10 aug)

select orders.order_id,restaurent.r_name,food.f_name
from orders
join restaurent
on restaurent.r_id=orders.r_id
join order_details 
on orders.order_id=order_details.order_id
join food
on food.f_id=order_details.f_id
where user_id=(select user_id from usere where name like 'Neha')
and (date>'2022-07-10' and date < '2022-08-10');

-- find restaurants with max repeated customers

select r_id,count(*) as 'loyal_customer'
from(
   select user_id,r_id,count(*) as 'visit' 
   from orders 
   group by user_id,r_id
   having visit >1
   )t
   group by r_id
   order by loyal_customer desc limit 1;
   
   -- Q9 Month over month revenue growth of swiggy

	select monthname(date) as "month",sum(amount)
   from orders
   group by month;
   
   select month,((revenue - prev)/prev)*100 from (
     with sales as
     ( 
        select monthname(date) as 'month',sum(amount) as "revenue"
        from orders
        group by month
        order by month(date)
        )
        
        select month,revenue,lag(revenue,1) over(order by revenue) as 'prev' from sales
        )t;