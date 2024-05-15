-- 카테고리별 상품제목 길이별 상품개수 분포 및 길이별 판매율
SELECT P.product_category_name,
	   FLOOR(P.product_name_lenght/10)*10 AS length, -- 글자수를 10단위로 그룹핑
	   COUNT(DISTINCT P.product_id) AS prd_cnt, -- 상품개수
       COUNT(P.product_id) AS ord_cnt, -- 판매량
       ROUND(COUNT(P.product_id)/COUNT(DISTINCT P.product_id),1) as ord_per_prd
FROM olist_products_dataset P
JOIN olist_order_items_dataset I ON P.product_id = I.product_id
JOIN product_category_name_translation C ON C.product_category_name = P.product_category_name
GROUP BY P.product_category_name, length
ORDER BY P.product_category_name, length;



select *
from product_category_name_translation
WHERE product_category_name_english = 'fashion_bags_accessories';

SELECT *
FROM olist_ORDER_ITEMS_DATASET;

-- order_id별 카테고리 수, 상품 종류 수 (단, 상품이 2개 이상 주문된 주문에 한함)
SELECT DISTINCT order_id, seller_id, GROUP_CONCAT(DISTINCT product_category_name) AS category_name
FROM olist_order_items_dataset I
JOIN olist_products_dataset P ON I.product_id = P.product_id
WHERE order_id IN (
	SELECT order_id,
	       COUNT(DISTINCT product_category_name) AS category_cnt,
	   	 GROUP_CONCAT(DISTINCT product_category_name) AS category_name,
	       COUNT(DISTINCT seller_id) AS seller_cnt
	FROM olist_order_items_dataset I
	JOIN olist_products_dataset P ON I.product_id = P.product_id
	GROUP BY order_id
	HAVING COUNT(DISTINCT product_category_name) > 1 AND -- 카테고리가 2개 이상인 주문
		GROUP_CONCAT(DISTINCT product_category_name) IS NOT NULL AND -- 카테고리 분류 안된 상품 제외
        COUNT(DISTINCT seller_id) > 1 -- 2명 이상의 판매자
	)
GROUP BY order_id, seller_id;


SELECT DISTINCT customer_unique_id, seller_id, GROUP_CONCAT(DISTINCT product_category_name) AS category_name
FROM olist_order_items_dataset I
JOIN olist_products_dataset P ON I.product_id = P.product_id
JOIN olist_orders_dataset O ON O.order_id = I.order_id
JOIN olist_customers_dataset C ON O.customer_id = C.customer_id
WHERE customer_unique_id IN (
	SELECT customer_unique_id, I.order_id
	--        COUNT(DISTINCT product_category_name) AS category_cnt,
	--   	   GROUP_CONCAT(DISTINCT product_category_name) AS category_name,
	--        COUNT(DISTINCT seller_id) AS seller_cnt
	FROM olist_order_items_dataset I
	JOIN olist_products_dataset P ON I.product_id = P.product_id
    JOIN olist_orders_dataset O ON O.order_id = I.order_id
    JOIN olist_customers_dataset C ON O.customer_id = C.customer_id
	GROUP BY customer_unique_id, I.order_id
	HAVING COUNT(DISTINCT product_category_name) > 1 AND
		GROUP_CONCAT(DISTINCT product_category_name) IS NOT NULL AND
		COUNT(DISTINCT seller_id) = 1
	)
GROUP BY customer_unique_id, seller_id;


-- order_id별 카테고리 수, 상품 종류 수 (단, 상품이 2개 이상 주문된 주문에 한함)
SELECT order_id,
        COUNT(DISTINCT product_category_name) AS category_cnt,
        COUNT(DISTINCT I.product_id) AS product_cnt
FROM olist_order_items_dataset I
JOIN olist_products_dataset P ON I.product_id = P.product_id
GROUP BY order_id
HAVING COUNT(DISTINCT product_category_name) > 0 AND
	   COUNT(I.product_id) > 1
ORDER BY product_cnt;
    
    
    select *
    from olist_order_items_dataset
    where order_id = '002f98c0f7efd42638ed6100ca699b42'