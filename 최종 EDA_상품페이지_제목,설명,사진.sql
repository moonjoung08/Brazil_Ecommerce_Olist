USE olist_ecommerce;
/* ----------------------------Name----------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------- */
-- 카테고리별 판매량 TOP3 상품제목 길이
-- 상위 25% 판매자
WITH seller_sales AS (
	SELECT seller_id, SUM(price) AS total_price -- seller별 판매액
	FROM olist_order_items_dataset
	GROUP BY seller_id -- seller_id로 그룹핑
    ORDER BY total_price DESC -- 판매액이 높은 순으로 정렬
    LIMIT 774 -- 총 판매자 수 3095명 중 5%는 155명
	)
    
SELECT C2.product_category_name_english,
       FLOOR(product_name_lenght/10)*10, -- 글자수를 10단위로 그룹핑
	   COUNT(order_id), -- 판매량
       ROW_NUMBER() over(partition by C2.product_category_name_english order by COUNT(order_id) DESC) rnk -- 판매량 순위
FROM olist_products_dataset P
JOIN olist_order_items_dataset I ON P.product_id = I.product_id
JOIN product_category_name_translation C2 ON C2.product_category_name = P.product_category_name
WHERE I.seller_id IN (
	SELECT seller_id FROM seller_sales
    )
GROUP BY C2.product_category_name_english, FLOOR(product_name_lenght/10)*10
ORDER BY C2.product_category_name_english, COUNT(order_id) DESC;


-- 카테고리별 판매량 TOP3 상품제목 길이
-- 하위 75% 판매자
WITH seller_sales AS (
	SELECT seller_id, SUM(price) AS total_price -- seller별 판매액
	FROM olist_order_items_dataset
	GROUP BY seller_id -- seller_id로 그룹핑
    ORDER BY total_price -- 판매액이 낮은 순으로 정렬
    LIMIT 2321 -- 총 판매자 수 3095명 중 75%는 2321.25명
	)
SELECT C2.product_category_name_english,
       FLOOR(product_name_lenght/10)*10, -- 글자수를 10단위로 그룹핑
	   COUNT(order_id), -- 판매량
       ROW_NUMBER() over(partition by C2.product_category_name_english order by COUNT(order_id) DESC) rnk -- 판매량 순위
FROM olist_products_dataset P
JOIN olist_order_items_dataset I ON P.product_id = I.product_id
JOIN product_category_name_translation C2 ON C2.product_category_name = P.product_category_name
WHERE I.seller_id IN (
	SELECT seller_id FROM seller_sales
    )
GROUP BY C2.product_category_name_english, FLOOR(product_name_lenght/10)*10
ORDER BY C2.product_category_name_english, COUNT(order_id) DESC;



-- 카테고리별 name_length 최솟값, 최댓값, 평균, 총 건수
-- 상위 25% 판매자
WITH seller_sales AS (
	SELECT seller_id, SUM(price) AS total_price -- seller별 판매액
	FROM olist_order_items_dataset
	GROUP BY seller_id -- seller_id로 그룹핑
    ORDER BY total_price DESC -- 판매액이 높은 순으로 정렬
    LIMIT 774 -- 총 판매자 수 3095명 중 25%는 774.75명
	)
SELECT product_category_name_english,
	   COUNT(product_name_lenght) AS cnt,
       MIN(product_name_lenght) AS min,
       MAX(product_name_lenght) AS max,
       ROUND(AVG(product_name_lenght),2) AS avg       
FROM product_category_name_translation2 C
JOIN olist_products_dataset P ON C.product_category_name = P.product_category_name
JOIN olist_order_items_dataset I ON P.product_id = I.product_id
WHERE I.seller_id IN (
	SELECT seller_id FROM seller_sales
    )
GROUP BY product_category_name_english
ORDER BY cnt DESC;


-- 카테고리별 name_length 최솟값, 최댓값, 평균, 총 건수
-- 하위 75% 판매자
WITH seller_sales AS (
	SELECT seller_id, SUM(price) AS total_price -- seller별 판매액
	FROM olist_order_items_dataset
	GROUP BY seller_id -- seller_id로 그룹핑
    ORDER BY total_price -- 판매액이 낮은 순으로 정렬
    LIMIT 2321 -- 총 판매자 수 3095명 중 75%는 2321.25명
	)
SELECT product_category_name_english,
	   COUNT(product_name_lenght) AS cnt,
       MIN(product_name_lenght) AS min,
       MAX(product_name_lenght) AS max,
       ROUND(AVG(product_name_lenght),2) AS avg       
FROM product_category_name_translation2 C
JOIN olist_products_dataset P ON C.product_category_name = P.product_category_name
JOIN olist_order_items_dataset I ON P.product_id = I.product_id
WHERE I.seller_id IN (
	SELECT seller_id FROM seller_sales
    )
GROUP BY product_category_name_english
ORDER BY cnt DESC;


/* ----------------------------Description----------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------- */

-- 카테고리별 판매량 TOP3 상품설명 길이
-- 상위 25% 판매자
WITH seller_sales AS (
	SELECT seller_id, SUM(price) AS total_price -- seller별 판매액
	FROM olist_order_items_dataset
	GROUP BY seller_id -- seller_id로 그룹핑
    ORDER BY total_price DESC -- 판매액이 높은 순으로 정렬
    LIMIT 774 -- 총 판매자 수 3095명 중 5%는 155명
	)
SELECT product_category_name_english,
       ROUND((product_description_lenght/100),0)*100 AS length, -- 100단위 상품설명
       COUNT(order_id) AS order_cnt, -- 판매량
       ROW_NUMBER() over(partition by C.product_category_name_english order by COUNT(order_id) DESC) rnk -- 판매량 순위
FROM olist_products_dataset P
JOIN olist_order_items_dataset I ON P.product_id = I.product_id
JOIN product_category_name_translation2 C ON P.product_category_name = C.product_category_name
WHERE I.seller_id IN (
	SELECT seller_id FROM seller_sales
    )
GROUP BY length, product_category_name_english
ORDER BY product_category_name_english, rnk;


-- 카테고리별 판매량 TOP3 상품설명 길이
-- 하위 75% 판매자
WITH seller_sales AS (
	SELECT seller_id, SUM(price) AS total_price -- seller별 판매액
	FROM olist_order_items_dataset
	GROUP BY seller_id -- seller_id로 그룹핑
    ORDER BY total_price  -- 판매액이 높은 순으로 정렬
    LIMIT 2321 -- 총 판매자 수 3095명 중 5%는 155명
	)
SELECT product_category_name_english,
       ROUND((product_description_lenght/100),0)*100 AS length, -- 100단위 상품설명
       COUNT(order_id) AS order_cnt, -- 판매량
       ROW_NUMBER() over(partition by C.product_category_name_english order by COUNT(order_id) DESC) rnk -- 판매량 순위
FROM olist_products_dataset P
JOIN olist_order_items_dataset I ON P.product_id = I.product_id
JOIN product_category_name_translation2 C ON P.product_category_name = C.product_category_name
WHERE I.seller_id IN (
	SELECT seller_id FROM seller_sales
    )
GROUP BY length, product_category_name_english
ORDER BY product_category_name_english, rnk;


-- 카테고리별 description_length 최솟값, 최댓값, 평균, 총 건수
-- 상위 25% 판매자
WITH seller_sales AS (
	SELECT seller_id, SUM(price) AS total_price -- seller별 판매액
	FROM olist_order_items_dataset
	GROUP BY seller_id -- seller_id로 그룹핑
    ORDER BY total_price DESC -- 판매액이 낮은 순으로 정렬
    LIMIT 774 -- 총 판매자 수 3095명 중 75%는 2321.25명
	)
SELECT product_category_name_english,
	   COUNT(product_description_lenght) AS cnt,
       MIN(product_description_lenght) AS min,
       MAX(product_description_lenght) AS max,
       ROUND(AVG(product_description_lenght),2) AS avg       
FROM product_category_name_translation2 C
JOIN olist_products_dataset P ON C.product_category_name = P.product_category_name
JOIN olist_order_items_dataset I ON I.product_id = P.product_id
WHERE I.seller_id IN (
	SELECT seller_id FROM seller_sales
    )
GROUP BY product_category_name_english
ORDER BY cnt DESC;


-- 카테고리별 description_length 최솟값, 최댓값, 평균, 총 건수
-- 하위 75% 판매자
WITH seller_sales AS (
	SELECT seller_id, SUM(price) AS total_price -- seller별 판매액
	FROM olist_order_items_dataset
	GROUP BY seller_id -- seller_id로 그룹핑
    ORDER BY total_price -- 판매액이 낮은 순으로 정렬
    LIMIT 2321 -- 총 판매자 수 3095명 중 75%는 2321.25명
	)
SELECT product_category_name_english,
	   COUNT(product_description_lenght) AS cnt,
       MIN(product_description_lenght) AS min,
       MAX(product_description_lenght) AS max,
       ROUND(AVG(product_description_lenght),2) AS avg       
FROM product_category_name_translation2 C
JOIN olist_products_dataset P ON C.product_category_name = P.product_category_name
JOIN olist_order_items_dataset I ON I.product_id = P.product_id
WHERE I.seller_id IN (
	SELECT seller_id FROM seller_sales
    )
GROUP BY product_category_name_english
ORDER BY cnt DESC;

/* ----------------------------Photo----------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------- */
-- 카테고리별 판매량 TOP3 사진개수
-- 상위 25% 판매자
WITH seller_sales AS (
	SELECT seller_id, SUM(price) AS total_price -- seller별 판매액
	FROM olist_order_items_dataset
	GROUP BY seller_id -- seller_id로 그룹핑
    ORDER BY total_price -- 판매액이 높은 순으로 정렬
    LIMIT 2321 -- 총 판매자 수 3095명 중 5%는 155명
	)
SELECT P.product_category_name,
   ROUND(product_photos_qty, 0),
   COUNT(order_id), -- 판매량
   ROW_NUMBER() over(partition by P.product_category_name order by COUNT(order_id) DESC) rnk -- 판매량 순위
FROM olist_products_dataset P
LEFT JOIN product_category_name_translation2 C ON C.product_category_name = P.product_category_name
LEFT JOIN olist_order_items_dataset I ON I.product_id = P.product_id
WHERE I.seller_id IN (
	SELECT seller_id FROM seller_sales
    )
GROUP BY P.product_category_name, product_photos_qty
ORDER BY P.product_category_name, COUNT(order_id) DESC;


WITH seller_sales AS (
	SELECT seller_id, SUM(price) AS total_price -- seller별 판매액
	FROM olist_order_items_dataset
	GROUP BY seller_id -- seller_id로 그룹핑
    ORDER BY total_price DESC -- 판매액이 높은 순으로 정렬
    LIMIT 774 -- 총 판매자 수 3095명 중 5%는 155명
	)
SELECT P.product_category_name,
	   COUNT(product_photos_qty) AS cnt,
       MIN(product_photos_qty) AS min,
       MAX(product_photos_qty) AS max,
       ROUND(AVG(product_photos_qty),2) AS avg       
FROM olist_products_dataset P
LEFT JOIN product_category_name_translation2 C ON C.product_category_name = P.product_category_name
LEFT JOIN olist_order_items_dataset I ON I.product_id = P.product_id
WHERE I.seller_id IN (
	SELECT seller_id FROM seller_sales
    )
GROUP BY P.product_category_name
ORDER BY cnt DESC;


/* ---------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------- */
-- 카테고리별 제품 개수
-- 제품개수 자체가 너무 적으면 선택지가 별로 없어서 구매한건지, 상품페이지가 적절해서 많이 구매한건지 확실하지 않아 제외하기 위함
WITH seller_sales AS (
	SELECT seller_id, SUM(price) AS total_price -- seller별 판매액
	FROM olist_order_items_dataset
	GROUP BY seller_id -- seller_id로 그룹핑
    ORDER BY total_price DESC -- 판매액이 높은 순으로 정렬
    LIMIT 774 -- 총 판매자 수 3095명 중 25%는 773.75명
	)
select product_category_name, COUNT(P.product_id)
FROM olist_products_dataset P
JOIN olist_order_items_dataset I ON P.product_id = I.product_id
WHERE I.seller_id IN (
	SELECT seller_id FROM seller_sales
    )
GROUP BY product_category_name
ORDER BY product_category_name;


/* ---------------------------------------전체 판매자---------------------------------------------
--------------------------------------------------------------------------------------------- */
-- 카테고리별 전체 제품 개수
SELECT product_category_name, COUNT(DISTINCT product_id)
FROM olist_products_dataset
GROUP BY product_category_name
ORDER BY product_category_name;

-- 카테고리별 전체 판매자 개수
SELECT product_category_name, COUNT(seller_id)
FROM olist_products_dataset P
LEFT JOIN olist_order_items_dataset I ON P.product_id = I.product_id
GROUP BY product_category_name
ORDER BY product_category_name;


-- 카테고리별 description_length 최솟값, 최댓값, 평균, 총 건수
SELECT P.product_category_name,
	   COUNT(product_description_lenght) AS cnt,
       MIN(product_description_lenght) AS min,
       MAX(product_description_lenght) AS max,
       ROUND(AVG(product_description_lenght),2) AS avg       
FROM olist_products_dataset P
LEFT JOIN product_category_name_translation2 C ON C.product_category_name = P.product_category_name
LEFT JOIN olist_order_items_dataset I ON I.product_id = P.product_id
GROUP BY P.product_category_name
ORDER BY cnt DESC;

-- 카테고리별 name_length 최솟값, 최댓값, 평균, 총 건수
SELECT P.product_category_name,
	   COUNT(product_name_lenght) AS cnt,
       MIN(product_name_lenght) AS min,
       MAX(product_name_lenght) AS max,
       ROUND(AVG(product_name_lenght),2) AS avg       
FROM olist_products_dataset P
LEFT JOIN product_category_name_translation2 C ON C.product_category_name = P.product_category_name
LEFT JOIN olist_order_items_dataset I ON I.product_id = P.product_id
GROUP BY P.product_category_name
ORDER BY cnt DESC;


-- 카테고리별 photo 최솟값, 최댓값, 평균, 총 건수
SELECT P.product_category_name,
	   COUNT(product_photos_qty) AS cnt,
       MIN(product_photos_qty) AS min,
       MAX(product_photos_qty) AS max,
       ROUND(AVG(product_photos_qty),2) AS avg       
FROM olist_products_dataset P
LEFT JOIN product_category_name_translation2 C ON C.product_category_name = P.product_category_name
LEFT JOIN olist_order_items_dataset I ON I.product_id = P.product_id
GROUP BY P.product_category_name
ORDER BY cnt DESC;


-- 카테고리별 description 판매량 TOP3
SELECT P.product_category_name,
       ROUND((product_description_lenght/100),0)*100 AS length, -- 100단위 상품설명
       COUNT(order_id) AS order_cnt, -- 판매량
       ROW_NUMBER() over(partition by P.product_category_name order by COUNT(order_id) DESC) rnk -- 판매량 순위
FROM olist_products_dataset P
LEFT JOIN product_category_name_translation2 C ON C.product_category_name = P.product_category_name
LEFT JOIN olist_order_items_dataset I ON I.product_id = P.product_id
GROUP BY P.product_category_name, length
ORDER BY P.product_category_name, rnk;

-- 카테고리별 name 판매량 TOP3
SELECT P.product_category_name,
       FLOOR(product_name_lenght/10)*10, -- 글자수를 10단위로 그룹핑
	   COUNT(order_id), -- 판매량
       ROW_NUMBER() over(partition by P.product_category_name order by COUNT(order_id) DESC) rnk -- 판매량 순위
FROM olist_products_dataset P
LEFT JOIN product_category_name_translation2 C ON C.product_category_name = P.product_category_name
LEFT JOIN olist_order_items_dataset I ON I.product_id = P.product_id
GROUP BY P.product_category_name, FLOOR(product_name_lenght/10)*10
ORDER BY P.product_category_name, COUNT(order_id) DESC;


-- 카테고리별 Photo 판매량 TOP3
SELECT P.product_category_name,
       ROUND(product_photos_qty, 0),
	   COUNT(order_id), -- 판매량
       ROW_NUMBER() over(partition by P.product_category_name order by COUNT(order_id) DESC) rnk -- 판매량 순위
FROM olist_products_dataset P
LEFT JOIN product_category_name_translation2 C ON C.product_category_name = P.product_category_name
LEFT JOIN olist_order_items_dataset I ON I.product_id = P.product_id
GROUP BY P.product_category_name, product_photos_qty
ORDER BY P.product_category_name, COUNT(order_id) DESC;




/*--------------------총 판매량을 기준으로 최적의 길이라고 주장할 수 없다면 또 무슨 기준으로 봐야할까?--------------------------*/
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