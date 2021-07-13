-- Создадим временные таблицы с тестовыми данными 

WITH clients (Client_ID, Date_Birth, City_client_ID, Registration_Date) AS 
-- ID клиента, Дата рождения, ID города клиента, Дата регистрации
(
    VALUES (1, '1990-06-13' :: date, 1, '2020-11-01' :: date)
    UNION ALL 
    VALUES (2, '1987-01-10':: date, 2, '2021-01-15' :: date)
    UNION ALL 
    VALUES (3, '2001-03-03':: date, 3, '2021-03-23' :: date)
), 
cities (City_ID, City, City_client_ID, City_client) AS 
-- ID города акции, Название города, ID города клиента, Название города клиента
(
    VALUES (1, 'Moscow', 1, 'Moscow')
    UNION ALL 
    VALUES (2, 'Perm', 2, 'Perm')
    UNION ALL 
    VALUES (3, 'Tula', 3, 'Tula')
),
deals (Dial_offer_id, Dial_offer_name, Category_ID, Category_name, Partner_ID, Partner_name) AS 
-- ID акции, Название акции, ID категории, Название категории, ID партнер, Название партнера
(
    VALUES (1, 'New_price', 1, 'Popular', 1, 'Ozon')
    UNION ALL 
    VALUES (2, 'New_arrival', 2, 'New', 2, 'Wildberries')
    UNION ALL 
    VALUES (3, 'Sale', 3, 'Old', 3, 'Market')
),
purchases (Purchase_Date, Purchase_ID, Category_ID, Partner_ID, Client_ID, City_ID, Price, Quantity, Deal_offer_id, Status) AS 
-- Дата покупки, ID покупки, ID категории, ID партнера, ID клиента, ID города, Цена товара, Количество товара, ID акции, Статус заказа
(
    VALUES ('2020-11-05' :: date, 1, 1, 1, 1, 1, 1299,  3, 1, 2)
    UNION ALL 
    VALUES ('2021-02-17' :: date, 2, 2, 2, 2, 2, 599, 5, 2, 2)
    UNION ALL 
    VALUES ('2021-05-02' :: date, 3, 3, 3, 3, 3, 2499, 2, 3, 2)
    UNION ALL 
    VALUES ('2021-06-01' :: date, 4, 1, 1, 1, 1, 1299,  3, 1, 2)
)

-- Основной запрос 

SELECT  p.Purchase_Date, 
        p.Purchase_ID, 
        cl.Client_ID, 
        date_part('year',age(cl.Date_Birth)) Client_Age, 
        (current_date - cl.Registration_Date) Client_Registration_Age, 
        CASE 
            WHEN ROW_NUMBER () OVER (PARTITION BY p.Client_ID ORDER BY p.Purchase_Date) = 1 THEN 'new'
            WHEN ROW_NUMBER () OVER (PARTITION BY p.Client_ID ORDER by p.Purchase_Date) > 1 THEN 'old'
            ELSE NULL 
        END Client_type,
        ci.City_client, 
        ci.City, 
        d.Dial_offer_name, 
        d.Category_name, 
        d.Partner_name, 
        (p.Price * p.Quantity) Revenue,
        p.Quantity
FROM    purchases p 
        INNER JOIN clients cl 
            ON p.Client_ID = cl.Client_ID
        INNER JOIN deals d 
            ON p.Deal_offer_id = d.Dial_offer_id 
        INNER JOIN cities ci 
            ON cl.City_client_ID = ci.City_client_ID
WHERE   p.Status = 2
        AND p.Purchase_Date BETWEEN '2018-01-01' AND '2018-12-01' -- указанные даты диапазона включены
            



