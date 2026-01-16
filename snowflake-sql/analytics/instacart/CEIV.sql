/* Template */
SELECT
    *
FROM
    catalog.catalog.current_elastic_item_view ceiv
WHERE
    retailer_id = 1573
    AND ceiv.data:retailer_promotion_details:discount_begins_at IS NOT NULL
    -- and item_id = '353023564486'
LIMIT 50;


/* Yoke's Dept ID */
SELECT
    -- *
    DISTINCT
    ceiv.data:retailer_lookup_code::STRING UPC,
    ceiv.data:item_department_id::STRING dept_id,
    ceiv.data:available::STRING available,
    -- ceiv.inventory_area_id::STRING IA,
    wl.location_code as store_id,
    DATE(ceiv.data:retailer_promotion_details:discount_begins_at::STRING) promotion_start,
    DATE(ceiv.data:retailer_promotion_details:discount_ends_at::STRING) promotion_end,
    ceiv.data:retailer_promotion_details:promotion_group_id::STRING promo_group_id,
    ceiv.data:retailer_promotion_details:rules[0]::STRING promo_type,
    ceiv.data:retailer_promotion_details:metadata::STRING promo_metadata

FROM
    catalog.catalog.current_elastic_item_view ceiv
JOIN
    instadata.rds_data.warehouse_locations wl
ON
    ceiv.inventory_area_id=wl.inventory_area_id and ceiv.retailer_id=wl.warehouse_id
WHERE
    ceiv.retailer_id = 2635
    -- and dept_id IS NULL
    and promo_group_id IS NOT NULL
    and ceiv.data:available = 'true'
ORDER BY store_id, dept_id
LIMIT 50;


/* NSM NLCM Image issue */
SELECT
    *
FROM
    catalog.catalog.current_elastic_item_view ciev
WHERE
    retailer_id = 308
    -- AND ciev.data:retailer_promotion_details:discount_begins_at IS NOT NULL
    -- and item_id = '353023564486'
LIMIT 5000;




/* Morton Williams Alchol */
SELECT
    *
FROM
    catalog.catalog.current_elastic_item_view
WHERE
    retailer_id = 497
    AND data:alcoholic = 'true'
    AND data:available = 'true'
    -- and item_id = '353023564486'
LIMIT 50;


/* CVS perfume issue */
SELECT 
    DISTINCT
    item_id,
    inventory_area_id,
    ciev.data:retailer_lookup_code::STRING UPC,
    ciev.data:retailer_reference_code::STRING RRC,
    -- ciev.data:available available,
    -- ciev.data:visible visible,
    ciev.data:cost_price_per_unit::STRING cost_price,
    -- ciev.data:sale_cost_price_per_unit::STRING sale_price,
    -- ciev.data:sale_allowed sale_allowed,
    -- DATE(ciev.data:sale_start_at::STRING) sale_start,
    -- DATE(ciev.data:sale_end_at::STRING) sale_end,
    DATE(ciev.data:retailer_promotion_details:discount_begins_at::STRING) promotion_start,
    DATE(ciev.data:retailer_promotion_details:discount_ends_at::STRING) promotion_end,
    -- ciev.data:retailer_promotion_details:promotion_group_id::STRING promo_group_id,
    ciev.data:retailer_promotion_details:name::STRING promo_type,
    ciev.data:retailer_promotion_details:rules::STRING promo_metadata,
    ciev.data:updated_at::STRING updated_at
FROM
    catalog.catalog.current_elastic_item_view ciev
WHERE
    retailer_id = 118
    AND RRC = '435360'
    -- AND data:retailer_department ILIKE '%Fragrance%'
    -- AND promo_type != 'Buy 1 Get 25.0% Off'
    AND promotion_end > current_date()
    AND data:available = 'true';
-- LIMIT 100;


/* Bristol Farms par_weight */
SELECT
    -- *
    -- DISTINCT
    data:retailer_lookup_code::STRING UPC,
    product_id IC_Product_ID,
    -- data:sale_price:currency:name Product_Name,
    data:par_weight::STRING par_weight
FROM
    catalog.catalog.current_elastic_item_view
WHERE
    retailer_id = 1296
    AND data:par_weight IS NOT NULL
    and data:available = 'true'
ORDER BY product_id ASC;
    -- and item_id = '353023564486'
-- LIMIT 50;

SELECT
    MIN(ceiv.data:retailer_lookup_code::STRING) AS UPC,
    ceiv.product_id AS IC_Product_ID,
    dp.product_name AS PRODUCT_NAME,
    AVG(ceiv.data:par_weight::FLOAT) AS average_par_weight,
    MAX(ceiv.data:par_weight::FLOAT) AS max_par_weight,
    MIN(ceiv.data:par_weight::FLOAT) AS min_par_weight
FROM
    catalog.catalog.current_elastic_item_view ceiv
JOIN
    instadata.dwh.dim_product dp
ON
    ceiv.product_id = dp.product_id 
    -- and ceiv.retailer_id = dp.classified_retailer_id
WHERE
    ceiv.retailer_id = 1296
    AND ceiv.data:par_weight IS NOT NULL
    AND ceiv.data:available = 'true'
GROUP BY
    IC_Product_ID, PRODUCT_NAME
ORDER BY
    UPC ASC;



/* Walgreens */
SELECT
    -- *
    DISTINCT
    ciev.item_id,
    ciev.data:retailer_lookup_code::STRING UPC,
    -- ciev.product_id PRODUCT_ID,
'https://dashboard.instacart.com/partners/2246/warehouses/1573/catalog/products/' || ciev.product_id || '/edit/stores?inventory_area_ids=' || ciev.inventory_area_id AS IPP,    
    -- 'https://www.instacart.com/store/walgreens/products/' || ciev.product_id || '/storefront' as marketplace,
    ciev.inventory_area_id IA,
    wl.location_code as store_id,
    ciev.data:available available,
    ciev.data:cost_price_per_unit::STRING cost_price,
    ciev.data:sale_cost_price_per_unit::STRING sale_price,
    ciev.data:sale_allowed sale_allowed,
    DATE(ciev.data:sale_start_at::STRING) sale_start,
    DATE(ciev.data:sale_end_at::STRING) sale_end,
    DATE(ciev.data:retailer_promotion_details:discount_begins_at::STRING) promotion_start,
    DATE(ciev.data:retailer_promotion_details:discount_ends_at::STRING) promotion_end,
    ciev.data:retailer_promotion_details:promotion_group_id::STRING promo_group_id
    
FROM
    catalog.catalog.current_elastic_item_view ciev
JOIN
    instadata.rds_data.warehouse_locations wl
ON
    ciev.inventory_area_id=wl.inventory_area_id and ciev.retailer_id=wl.warehouse_id
WHERE
    ciev.retailer_id = 1573
    AND sale_allowed = 'true'
    AND ciev.data:available = 'true'
    AND cost_price > sale_price
    -- AND store_id = '10029'
    AND sale_end >= current_date()
ORDER BY store_id;
    
-- LIMIT 50;
;

/* Grocery Outlet Image Issue */
SELECT
    *
FROM
    catalog.catalog.current_elastic_item_view
WHERE
    retailer_id = 1871
    AND data:retailer_reference_code = '603966'
LIMIT 50;


/* Sam's club current available items */
SELECT
    *
FROM
    catalog.catalog.current_elastic_item_view
WHERE
    retailer_id = 352
    AND data:available = false
LIMIT 50;


SELECT
    item_id,
    product_id,
    data:retailer_promotion_details:discount_begins_at::STRING promotion_start,
    data:retailer_promotion_details:discount_ends_at::STRING promotion_end,
    data:retailer_promotion_details:promotion_group_id::STRING promo_group_id,
FROM
    catalog.catalog.current_elastic_item_view
WHERE
    retailer_id = 419
    AND data:retailer_lookup_code = '00012000005596'
LIMIT 50;



/* NSM container_type */
SELECT
    *
FROM
    catalog.catalog.current_elastic_item_view
WHERE
    retailer_id = 308
    AND data:available = true
    AND data:retailer_lookup_code IN (
                                        '00088586010330',
'00088586010347',
'00088586010354',
'00088586010378',
'00892931000828',
'00892931000835',
'00853451008022',
'00853451008039',
'00853451008107',
'00853451008183',
'00853451008275',
'00853451008282',
'00864621000128',
'00864621000166',
'00864621000180',
'00864621000197',
'00096925002014',
'00096925002021',
'00096925002038',
'00096925310010',
'00096925310034',
'00096925313042',
'00810411010006',
'00810411010013',
'03292350250007',
'00852392003912',
'00852892003887',
'00852892003894',
'00852892003900',
'00852892003924',
'00852892003931',
'00852892003948',
'00852892003955',
'00860056002102',
'00860056002119',
'00611482102726',
'00611482102825',
'00758821222117',
'00726452010038',
'00850784003205',
'00850784003212',
'00854657002159',
'00854657002166',
'03085465700211',
'30854657002150',
'00859139000388',
'00859139000395',
'00859139000425',
'00899602002037',
'00899602002044',
'00899602002051',
'00854269008181',
'00854269008198',
'00854269008211',
'00854269008228',
'00854269008396',
'00854269008419',
'00082242018005',
'00410001019220',
'00739958163238',
'00739958163252',
'00739958164242',
'00739958164648',
'00739958165027',
'00085000027134',
'00085000027141',
'00856716007006',
'00856716007020',
'00856716007082',
'00856716007099',
'00856716007105',
'00856716007112',
'00856716007129',
'00856716007136',
'00669576017005',
'00669576017012',
'00669576017029',
'00669576017036',
'00669576017050',
'00669576017067',
'00669576017074',
'04262360520857',
'04262360520871',
'00798304360530',
'00854909007000',
'00854909007017',
'00854909007024',
'00854909007093',
'00854909007109',
'00850019008005',
'00850019008012',
'00850019008029',
'00851009008029',
'00848375004564',
'00848375004649',
'00848375004991',
'00848375005004',
'00848375005011',
'00848375005127',
'00848375005134',
'00848375005141',
'00848375006865',
'00848375008432',
'00848375008449',
'00848375008456',
'00848375008463',
'00850010697017',
'00850095006483',
'00850095006766',
'00851937007538',
'00860000325110',
'00860000325127',
'00860000325134',
'00860000325141',
'00860000325158',
'00860000325165',
'00853706002195',
'00853706002225',
'00853706002287',
'00853706002294',
'00892591000145',
'00892591000169',
'00631471002011',
'00631473001531',
'00860007907500',
'00860007907517',
'00860007907562',
'00865317000323',
'00865317000330',
'00865317000354',
'00865317000392',
'00860000929158',
'00860001347302',
'00644216531820',
'00866871000095',
'00840600111795',
'00840600112075',
'00840600117742',
'00840600117759',
'00085200020447',
'00085200020461',
'05602281912505',
'05602281912581',
'00852411007730',
'00852411007747',
'00852411007754',
'00089832921189',
'00089832921301',
'00089832922117',
'00089832922124',
'00089832922131',
'00089832922148',
'00089832922155',
'00089832922162',
'00848375006032',
'00848375006049',
'00848375006056',
'08033116405454',
'08033116406413',
'08033116406444',
'18033116402801',
'18033116402818',
'00089832921776',
'00089832921806',
'00086891086187',
'00850016847003',
'00850016847027',
'00637057976806',
'00865141000216',
'00730429000038',
'00730429221136',
'00089832920663',
'00089832920984',
'00089832922735',
'00856036001043',
'00856036001067',
'00856036001074',
'00856036001098',
'00856036001197',
'00856036001203',
'00856036001210',
'00856036001227',
'00856036001517',
'00856036001562',
'00856036001579',
'04260196280273',
'04260196281270',
'00180937000288',
'00180937000295',
'00857484003023',
'00857484003047',
'00850784003441',
'00669576017043',
'00854667006369',
'00080600100102',
'00860718000248',
'00860718000262',
'00860718000279',
'00860718000293',
'00642461047677',
'00850017944015',
'00850017944022',
'00850017944039',
'00850017944046',
'00850017944053',
'00850017944060',
'00865851000407',
'00866701000080',
'00866701000097',
'00850643000536',
'00850643000567',
'00748528765697',
'00748528765710',
'00748528765949',
'00860006002824',
'00860006002831',
'00860006002848',
'00850034517001',
'00850034517018',
'00850034517025',
'00850034517032',
'00850034517049',
'00850034517056',
'00850034517063',
'00850034517070',
'00850034517087',
'00850034517094',
'00850034517223',
'00850034517230',
'00850034517247',
'00850034517254',
'00850034517261',
'00850034517278',
'00850034517285',
'00848375008708',
'00848375008715',
'00085000031919',
'00850041779423',
'00850041779485',
'00866483000063',
'00866483000070',
'00848375005196',
'00848375005899',
'00850063392266',
'00072546039615',
'04930391140121',
'08802521124898',
'08802521202343',
'08802521202350',
'08802521203890',
'08802521203906',
'08802521210003',
'00853725008000',
'00853725008024',
'00853725008031',
'00853725008048',
'00853725008055',
'00853725008062',
'00853725008079',
'00853725008086',
'00747846122502',
'00747846902500',
'00850002934618',
'00850002934625',
'00850002934632',
'00850002934687',
'00850002934984',
'00850017944633',
'00850017944718',
'00850017944749',
'00850017944756',
'00850063392136',
'00850063392143',
'00850063392273',
'00859597004010',
'00859597004096',
'00859597004140'
    
    );
-- LIMIT 50;



SELECT
    *
FROM
    catalog.catalog.current_elastic_item_view
WHERE
    retailer_id = 118
    -- AND data:retailer_promotion_details:discount_begins_at IS NOT NULL
    -- AND data:retailer_lookup_code = '00766684897991'
LIMIT 50;



SELECT
    data:retailer_promotion_details:discount_begins_at::STRING promotion_start,
    ceiv.data:retailer_promotion_details:discount_ends_at::STRING promotion_end,
    ceiv.data:retailer_promotion_details:promotion_group_id::STRING promo_group_id,
    -- ceiv.data:has_retailer_promotion promotion_status,
    item_id,
FROM
    catalog.catalog.current_elastic_item_view ceiv
WHERE
    ceiv.retailer_id = 118
    -- ceiv.retailer_id = 1946
    AND promotion_start > '2025-09-23'
    -- AND promotion_start IS NOT NULL
    -- AND promo_group_id IN ('101','151')
LIMIT 50;

SELECT
    item_id,
    product_id,
    inventory_area_id,
    retailer_id,
    data:available::STRING,
    data:retailer_lookup_code::STRING,
    data:visible::STRING,
    data:in_assortment::STRING,
    data:alcoholic::STRING
FROM
    catalog.catalog.current_elastic_item_view
WHERE
    retailer_id = 205
    -- OR retailer_id = 3219
    AND data:retailer_lookup_code = '00085000019658';
    -- AND data:alcoholic = TRUE
    -- AND data:available = TRUE
    -- AND data:visible = TRUE;
    -- AND data:has_retailer_promotion = TRUE;
    -- AND data:usa_snap_eligible = TRUE
-- LIMIT 50;






SELECT
    data:sale_start_at,
    data:sale_end_at,
    *
FROM
    catalog.catalog.current_elastic_item_view
WHERE
    retailer_id = 8766
    AND data:on_sale = TRUE
    -- AND data:sale_start_at < current_date
    -- AND data:sale_end_at > current_date
    -- AND data:retailer_lookup_code = '818423029979'
    
LIMIT 50;



SELECT
    item_id,
    data:retailer_lookup_code,
    data:available,
    data:sale_start_at,
    data:sale_end_at,
    data:cost_price_per_unit,
    data:sale_cost_price_per_unit,
    
FROM
    catalog.catalog.current_elastic_item_view
WHERE
    retailer_id = 29
    -- AND data:retailer_lookup_code = '818423029979'
    AND item_id IN (
'216658279026',
'1064178363922',
'584364957',
'2848230420',
'584382461',
'584362917',
'575834700080',
'3418287563',
'3065035931',
'377483384490',
'584426767',
'263186288430',
'638851908997',
'584360842',
'584369457',
'1734079544',
'925302112423',
'65089879989'
    )

-- AND data:retailer_lookup_code IN (
-- '725342260737',
-- '4001638098946',
-- '044082032115',
-- '036192122152',
-- '725342260713',
-- '829696000534',
-- '052603056120',
-- '036192122107',
-- '725342280711',
-- '741391953918',
-- '077326470176',
-- '829696000534',
-- '850030824028',
-- '044082530413',
-- '4001638098595',
-- '088702015614',
-- '728229014317',
-- '044082034416',
-- '858641003849',
-- '793232222158',
-- '725342285617',
-- '860008410849',
-- '089836185242',
-- '793232222080',
-- '725342280711',
-- '725342260713',
-- '044082032214'

-- )
    
LIMIT 50;






SELECT 
    inventory_area_id,
    data:available,
    data:visible,
    COUNT (item_id)
FROM
    catalog.rivercat.current_item_view
    -- catalog.catalog.current_item_view
WHERE
    retailer_id = 611
    AND inventory_area_id IN ('308363', '308360')
    -- AND data:available = 'true'
    -- AND data:visible = 'true'
GROUP BY inventory_area_id, data:available, data:visible;


SELECT 
    id,
    item_id,
    product_id,
    data:retailer_lookup_code::STRING as UPC,
    inventory_area_id,
    data:available,
    data:in_assortment,
    data:searchable,
    data:visible as VISIBLE,
    -- data:cost,
    -- data:cost_unit,
    data:display_size::STRING
    
FROM catalog.catalog.current_elastic_item_view
WHERE
    retailer_id = 505
    AND data:retailer_lookup_code = '00253058000007'
    -- AND item_id = '90823641872'
    -- AND data:available = TRUE
    -- AND data:visible = TRUE
ORDER BY 2,1 desc
LIMIT 100;




SELECT
    product_id,
    data:available,
    -- COUNT (data:available)
    *    
FROM
    catalog.catalog.current_elastic_item_view
WHERE
    retailer_id = 173
    AND product_id IN ('29544463', '17328915')
-- GROUP BY product_id, data:available;
LIMIT 500;



SELECT
    DISTINCT product_id as PRODUCT_ID,
    COUNT (data:available) as STATUS,
    data:retailer_reference_code as RRC,
    -- item_id,
    -- inventory_area_id
    -- *
    -- COUNT (data:available)    
FROM
    catalog.catalog.current_elastic_item_view
WHERE
    retailer_id = 173
    AND data:available = 'false'
    AND RRC IS NOT NULL
    -- AND product_id IN ('29544463', '17328915')
GROUP BY PRODUCT_ID, RRC;
-- LIMIT 1000;