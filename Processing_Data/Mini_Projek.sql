--Memperbaiki tipe data
alter table olist_orders_dataset 
alter column order_purchase_timestamp
type timestamp
using order_purchase_timestamp::timestamp

alter table olist_orders_dataset 
alter column order_approved_at
type timestamp
using nullif(trim(order_approved_at), '')::timestamp

alter table olist_orders_dataset 
alter column order_delivered_carrier_date
type timestamp
using nullif(trim(order_delivered_carrier_date), '')::timestamp

alter table olist_orders_dataset 
alter column order_delivered_customer_date
type timestamp
using nullif(trim(order_delivered_customer_date), '')::timestamp

alter table olist_orders_dataset 
alter column order_estimated_delivery_date
type date
using order_estimated_delivery_date::date

alter table olist_order_items_dataset 
alter column shipping_limit_date
type timestamp
using shipping_limit_date::timestamp


--Primary dan Foreign key
alter table olist_order_items_dataset
add primary key (order_id, order_item_id)

alter table olist_order_items_dataset
add foreign key (order_id)
references olist_orders_dataset(order_id),
add foreign key (product_id)
references olist_products_dataset(product_id),
add foreign key (seller_id)
references olist_sellers_dataset(seller_id)

alter table olist_orders_dataset
add primary key (order_id),
add foreign key (customer_id)
references olist_customers_dataset (customer_id)

alter table olist_customers_dataset
add primary key (customer_id)

alter table olist_products_dataset
add primary key (product_id)

alter table olist_sellers_dataset
add primary key (seller_id)

--Cek Duplikat
select order_id, count(*) as jumlah
from olist_order_items_dataset
group by order_id
having count(*) > 1

select order_id, product_id, count(*) AS jumlah
from olist_order_items_dataset
group by
    order_id,
    product_id
having count(*) > 1

select order_id, count(*) as jumlah
from olist_orders_dataset
group by order_id
having count(*) > 1

select customer_id, count(*) as jumlah
from olist_customers_dataset
group by customer_id
having count(*) > 1

select product_id, count(*) as jumlah
from olist_products_dataset
group by product_id
having count(*) > 1

select seller_id, count(*) as jumlah
from olist_sellers_dataset
group by seller_id
having count(*) > 1

--Cek Missingvalue
select
count(*) filter (where order_id is null) as order_id_null,
count(*) filter (where customer_id is null) as customer_id_null,
count(*) filter (where order_status is null) as order_status_null,
    count(*) filter (where order_purchase_timestamp is null) as purchase_null,
    count(*) filter (where order_approved_at is null) as approved_null,
    count(*) filter (where order_delivered_carrier_date is null) as carrier_null,
    count(*) filter (where order_delivered_customer_date is null) as delivered_null,
    count(*) filter (where order_estimated_delivery_date is null) as estimated_null
from olist_orders_dataset

select
    count(*) filter (where order_id is null) as order_id_null,
    count(*) filter (where order_item_id is null) as order_item_id_null,
    count(*) filter (where product_id is null) as product_id_null,
    count(*) filter (where seller_id is null) as seller_id_null,
    count(*) filter (where shipping_limit_date is null) as shipping_limit_null,
    count(*) filter (where price is null) as price_null,
    count(*) filter (where freight_value is null) as freight_null
from olist_order_items_dataset

select
    count(*) filter (where customer_id is null) as customer_id_null,
    count(*) filter (where customer_unique_id is null) as unique_id_null,
    count(*) filter (where customer_zip_code_prefix is null) as zip_null,
    count(*) filter (where customer_city is null) as city_null,
    count(*) filter (where customer_state is null) as state_null
from olist_customers_dataset

select
    count(*) filter (where product_id is null) as product_id_null,
    count(*) filter (where product_category_name is null) as category_null,
    count(*) filter (where product_name_lenght is null) as name_length_null,
    count(*) filter (where product_description_lenght is null) as description_length_null,
    count(*) filter (where product_photos_qty is null) as photos_null,
    count(*) filter (where product_weight_g is null) as weight_null,
    count(*) filter (where product_length_cm is null) as length_null,
    count(*) filter (where product_height_cm is null) as height_null,
    count(*) filter (where product_width_cm is null) as width_null
from olist_products_dataset

select
    count(*) filter (where seller_id is null) as seller_id_null,
    count(*) filter (where seller_zip_code_prefix is null) as zip_null,
    count(*) filter (where seller_city is null) as city_null,
    count(*) filter (where seller_state is null) as state_null
from olist_sellers_dataset

--Filter Table (mengecek duplikat atau missing value)
select * from olist_orders_dataset
where customer_id  = 'fc3d1daec319d62d49bfb5e1f83123e9'

select * from olist_order_items_dataset
where order_id = '8272b63d03f5f79c56e9e4120aec44ef'

select * from olist_order_items_dataset
where product_id = '368c6c730842d78016ad823897a372db'

select * from olist_customers_dataset
where customer_unique_id ='4546caea018ad8c692964e3382debd19'

--Outlier kolom price
--q1 dan q3
with batas as (
select
percentile_cont(0.25) within group (order by price) as q1,
percentile_cont(0.75) within group (order by price) as q3
from olist_order_items_dataset)
-- baris dengan outlier
select o.*
from olist_order_items_dataset o
cross join batas b
where o.price < b.q1 - 1.5 * (b.q3 - b.q1)
or o.price > b.q3 + 1.5 * (b.q3 - b.q1)
order by o.price desc
-- jumlah outlier
select count(*) as jumlah_outlier
from olist_order_items_dataset, batas
where price < q1 - 1.5 * (q3 - q1)
or price > q3 + 1.5 * (q3 - q1)
   
--Outlier weight
--batas q1 dan q3
with batas as (
select
percentile_cont(0.25) within group (order by product_weight_g) as q1,
percentile_cont(0.75) within group (order by product_weight_g) as q3
from olist_products_dataset)
-- baris dengan outlier
select o.*
from olist_products_dataset o
cross join batas b
where o.product_weight_g < b.q1 - 1.5 * (b.q3 - b.q1)
or o.product_weight_g > b.q3 + 1.5 * (b.q3 - b.q1)
order by o.product_weight_g desc

--Outlier volume prouct (length*height*width)
--mencari volume
with product_volume as (
select *,
product_length_cm *
product_height_cm *
product_width_cm as volume_cm3
from olist_products_dataset
where product_length_cm is not null
and product_height_cm is not null
and product_width_cm is not null
),
-- batas q1 dan q3
batas as (
select
percentile_cont(0.25) within group (order by volume_cm3) as q1,
percentile_cont(0.75) within group (order by volume_cm3) as q3
from product_volume
)
--baris dengan outlier
select
pv.*
from product_volume pv
cross join batas b
where pv.volume_cm3 < b.q1 - 1.5 * (b.q3 - b.q1)
or pv.volume_cm3 > b.q3 + 1.5 * (b.q3 - b.q1)
order by pv.volume_cm3 desc


--persebaran order status
select order_status, count(*) as jumlah from olist_orders_dataset
group by order_status
order by count(*) desc


--produk yang paling laku (unit yang terjual dan revenue)
select p.product_category_name, count(o.*) as jumlah, round(sum(oi.price)::numeric,2) as revenue from olist_orders_dataset o
left join olist_order_items_dataset oi on o.order_id=oi.order_id 
left join olist_products_dataset p on oi.product_id=p.product_id
where o.order_status in ('delivered','shipped')
group by p.product_category_name
order by count(o.*) desc

--seller dengan order status canceled
select s.seller_id, count(*) as jumlah, round(sum(oi.price)::numeric,2) as price from olist_orders_dataset o
left join olist_order_items_dataset oi on o.order_id=oi.order_id
left join olist_sellers_dataset s on oi.seller_id=s.seller_id
where o.order_status in ('canceled','unavailable')
group by s.seller_id
order by jumlah desc

--customer dengan transaksi terbanyak
select c.customer_unique_id, count(*) as jumlah_transaksi from olist_orders_dataset o
left join olist_customers_dataset c on o.customer_id=c.customer_id
where o.order_status in ('delivered','shipped')
group by c.customer_unique_id
order by jumlah_transaksi desc


select o.* from olist_orders_dataset o
left join olist_order_items_dataset oi on o.order_id=oi.order_id
left join olist_sellers_dataset s on oi.seller_id=s.seller_id
where s.seller_id is null

WITH item_per_order AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        COUNT(oi.order_item_id) AS jumlah_barang
    FROM olist_orders_dataset o
    JOIN olist_customers_dataset c
        ON o.customer_id = c.customer_id
    JOIN olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status IN ('delivered', 'shipped')
    GROUP BY
        c.customer_unique_id,
        o.order_id
)

SELECT
    customer_unique_id,
    COUNT(DISTINCT order_id) AS jumlah_transaksi,
    MAX(jumlah_barang) AS max_barang_satu_transaksi
FROM item_per_order
GROUP BY customer_unique_id
ORDER BY jumlah_transaksi desc

WITH item_per_order AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        COUNT(oi.order_item_id) AS jumlah_barang,
        SUM(oi.price) AS total_spend_order
    FROM olist_orders_dataset o
    JOIN olist_customers_dataset c
        ON o.customer_id = c.customer_id
    JOIN olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status IN ('delivered', 'shipped')
    GROUP BY
        c.customer_unique_id,
        o.order_id
)

SELECT
    customer_unique_id,
    COUNT(DISTINCT order_id) AS jumlah_transaksi,
    SUM(jumlah_barang) AS total_barang,
    MAX(jumlah_barang) AS max_barang_satu_transaksi,
    ROUND(SUM(total_spend_order)::numeric, 2) AS total_spend
FROM item_per_order
GROUP BY customer_unique_id
ORDER BY total_spend DESC;