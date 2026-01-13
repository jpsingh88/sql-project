/* Template */
SELECT 
    *    
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    -- retailer_id IN ('2002','3366')
    partner_id = 567
    AND created_at >= current_date - 3
LIMIT 50;

/* Template */
SELECT
    DISTINCT
    DATE(created_at) AS date,
    data:lookup_code::string               AS lookup_code,
    data:alcoholic::boolean                AS alcoholic,
    data:available::boolean                AS available,
    data:brand_name::string                AS brand_name,
    data:name::string                      AS name,
    data:cost_price_per_unit::float        AS cost_price_per_unit,
    data:cost_unit::string                 AS cost_unit,
    data:department::string                AS department,
    data:details::string                   AS details,
    
    DATE(data:loyalty_cost_price_start_at::string) AS loyalty_cost_price_start_at,
    DATE(data:loyalty_cost_price_end_at::string) AS loyalty_cost_price_end_at,
    
    data:max_in_cart::number               AS max_in_cart,
    
    -- Promotion (nested)
    DATE(data:promotion:promotion_start_at::string) AS promotion_start_at,
    DATE(data:promotion:promotion_end_at::string)   AS promotion_end_at,
    data:promotion:promotion_group_id::string AS promotion_group_id,
    data:promotion:promotion_type::string     AS promotion_type,

    -- Promotion Metadata (nested inside promotion)
    data:promotion:promotion_metadata:bundle_price::float        AS bundle_price,
    data:promotion:promotion_metadata:buy::number                AS buy,
    data:promotion:promotion_metadata:limit_per_order::number    AS limit_per_order,
    data:promotion:promotion_metadata:loyalty_members_only::number AS loyalty_members_only,
    data:promotion:promotion_metadata:qty_enforced::number       AS qty_enforced,

    DATE(data:sale_start_at::string)   AS sale_start_at,
    DATE(data:sale_end_at::string)     AS sale_end_at,
    data:sale_price_cents::number AS sale_price_cents,
    data:size::string            AS size,
    data:taxable::boolean        AS taxable,
    data:usa_snap_eligible::boolean AS usa_snap_eligible
FROM catalog.catalog.partner_file_normalized_data
WHERE  
    -- retailer_id = 2002
    partner_id = 567
    AND created_at >= current_date - 3
LIMIT 50;


/* Wakefern Promo Issue */
SELECT 
    DISTINCT
    data:lookup_code::STRING UPC,
    data:promotion:promotion_group_id::STRING promo_group_id,
    data:promotion:promotion_type::STRING promotion_type,
    data:promotion:promotion_metadata::STRING promotion_metadata,
    DATE(data:promotion:promotion_start_at::STRING) promotion_start,
    DATE(data:promotion:promotion_end_at::STRING) promotion_end,
    inventory_area_id IA,
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    -- partner_id = 138
    -- AND created_at >= current_date - 3
    promo_group_id != 'NO_PROMO'
    AND csv_file_id = '162427888'
ORDER BY promo_group_id desc
LIMIT 50;



/* MW Bowl and Basket product not found */

SELECT 
    DISTINCT
    DATE(created_at) date,
    csv_file_id,
    data:available::boolean                AS available,
    data:brand_name::string                AS brand_name,
    data:name::string                      AS name,
    data:lookup_code::float                AS UPC,
    inventory_area_id,
    pdp_metadata:input:filename::STRING filename
    -- *    
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    retailer_id  = 497
    AND data:lookup_code ILIKE '%411900677%'
    AND created_at >= current_date() - 2
LIMIT 100
;




/* Grocery outlet multiple UPC linked to 1 RRC */

WITH base AS (
    SELECT
        DISTINCT
        DATE(created_at) AS date,
        data:lookup_code::STRING AS UPC,
        data:retailer_reference_code::STRING AS RRC,
        data:brand_name::STRING AS brand_name,
        data:name::STRING AS name,
        -- data:remote_image_url::STRING AS Image_URL
    FROM catalog.catalog.partner_file_normalized_data
    WHERE  
        partner_id = 4493
        AND created_at >= current_date
),
counts AS (
    SELECT
        *,
        COUNT(DISTINCT UPC) OVER (PARTITION BY RRC) AS upc_count
    FROM base
)
SELECT *
FROM counts
WHERE upc_count > 1
ORDER BY RRC DESC, UPC DESC
LIMIT 50;






/* NSM Images */

SELECT 
    DISTINCT
    created_at,
    data:remote_image_url::STRING image_url,
    lead_code
    
    -- *    
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    retailer_id  = 308
    AND data:lookup_code = '000000094408'
    -- partner_id = 567
    -- AND created_at BETWEEN '2026-01-03' AND '2026-01-05'
    AND created_at >= current_date() - 10
    -- AND image_url ILIKE '%cdn.bristolfarms.com%'
-- LIMIT 100; 5197
ORDER BY created_at DESC
LIMIT 10
;



/* Wakefern Loyalty */

SELECT 
    DISTINCT
    DATE(created_at) AS date,
    data:lookup_code::string               AS lookup_code,
    retailer_id,
    data:brand_name::string                AS brand_name,
    data:name::string                      AS name,
    data:cost_price_per_unit::float        AS cost_price,
    data:sale_price_cents::number AS sale_price,
    data:loyalty_cost_price_cents::number AS loyalty_cp,
    DATE(data:sale_start_at::string)   AS sale_start,
    DATE(data:sale_end_at::string)     AS sale_end,
    -- DATE(data:loyalty_cost_price_start_at::string) AS loyalty_start,
    -- DATE(data:loyalty_cost_price_end_at::string) AS loyalty_cost_price_end_at,
    
    -- Promotion (nested)
    DATE(data:promotion:promotion_start_at::string) AS promo_start,
    DATE(data:promotion:promotion_end_at::string)   AS promo_end,   
    data:promotion:promotion_type::string     AS promo_type,
    data:promotion:promotion_metadata::STRING AS promo_metadata,
    

FROM
    catalog.catalog.partner_file_normalized_data
WHERE  

    -- retailer_id = 68
    partner_id = 573
    AND  created_at >= current_date - 3
    -- and pdp_metadata:scope:reinventory = 'true'
    -- AND data:lookup_code ILIKE '%74236526445%'
    -- AND loyalty_cp IS NOT NULL
    AND data:promotion:promotion_metadata:loyalty_members_only::number = '1'
ORDER BY date DESC
LIMIT 2;


/* CVS promo Issue */

SELECT 
    DISTINCT
    DATE(created_at) date,
    csv_file_id,
    pdp_metadata:input:filename::STRING filename,
    data:lookup_code::STRING UPC,
    data:retailer_reference_code::STRING RRC,
    data:location_code::NUMBER store_id,
    data:cost_price_per_unit::STRING cost_price,
    data:description::STRING Name,
    DATE(data:promotion:promotion_start_at::STRING) promotion_start,
    DATE(data:promotion:promotion_end_at::STRING) promotion_end,
    data:promotion_group_id::STRING promo_group_id,
    data:promotion:promotion_metadata::STRING promotion_metadata,
    data:promotion:promotion_type::STRING promotion_type
    
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    -- retailer_id IN ('2002','3366')
    partner_id = 80
    AND created_at >= current_date - 1
    AND RRC = '313794'
ORDER BY date desc;
-- LIMIT 50;


/* Wakefern Promo sale issue */

SELECT 
    -- *
    DISTINCT
    DATE(created_at) date,
    -- -- data:location_code::STRING store,
    inventory_area_id IA,
    data:lookup_code::STRING UPC,
    -- -- data:available available,
    -- -- data:name::STRING name ,
    -- -- data:cost_price_per_unit cost_price,
    -- -- data:sale_price_cents::STRING sale_price,
    -- -- data:sale_start_at::STRING sale_start,
    -- -- data:sale_end_at::STRING sale_end,
    DATE(data:promotion:promotion_start_at)::STRING promotion_Start,
    DATE(data:promotion:promotion_end_at)::STRING  promotion_end,
    data:promotion:promotion_group_id::STRING  promotion_group_id,
    data:promotion:promotion_metadata::STRING  promotion_metadata,
    data:promotion:promotion_type::STRING  promotion_type,
    -- -- pdp_metadata:source:test_file test_file
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    -- partner_id = 2218
     retailer_id = 205
    AND data:promotion:promotion_group_id =  '7553005'
    AND pdp_metadata:scope:reinventory = 'true'
   
    AND created_at >= current_date - 15
ORDER BY date DESC
    LIMIT 1000;


    

/* Walgreens Promo Issue */

SELECT 
    *    
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    CSV_FILE_ID = '157536363'
    -- partner_id = 567
    -- AND created_at >= current_date - 3
LIMIT 50;


/* PWMW Promotion Issue */

SELECT 
    DISTINCT
    DATE(created_at) date,
    data:available::STRING available,
    data:brand_name::STRING brand_name,
    data:name::STRING product_name,
    data:cost_price_per_unit::STRING cost_price,
    data:sale_price_cents::STRING sale_price,
    DATE(data:sale_start_at::STRING) sale_Start,
    DATE(data:sale_end_at::STRING) sale_end,
    DATE(data:promotion_start_at::STRING) promo_start,
    DATE(data:promotion_end_at::STRING) promo_end,
    
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    -- retailer_id IN ('2002','3366')
    -- partner_id = 567
    retailer_id = 68
    AND created_at >= current_date - 3
    -- and data:lookup_code = '00078000082166'
    and data:lookup_code = '00012000504051'
    -- AND promo_end IS NOT NULL
ORDER BY date desc
LIMIT 50;


-- For Lunds promotion rejection

SELECT *
    -- CSV_FILE_ID,
    -- DATE(created_at) Date,
    -- data:promotion_start_at::STRING promotion_start_date,
    -- data:promotion_end_at::STRING promotion_end_date,
    -- data:promotion_metadata::STRING promotion_metadata,
    -- data:promotion_group_id::STRING promotion_group_id,
    
FROM
    catalog.catalog.partner_file_normalized_data
    -- instadata.rds_data.csv_files
WHERE  
    -- partner_id = 568 
    -- AND created_at >= current_date - 7
    CSV_FILE_ID = '157490774';
    -- AND data:promotion_start_at IS NOT NULL
-- LIMIT 20;

/* Wakefern/Shoprite reinventory failure */

SELECT 
    -- COUNT(*)  
    -- *
    distinct
    csv_file_id
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    -- retailer_id IN ('2002','3366')
    partner_id = 138
    AND created_at >= current_date - 1
    AND inventory_area_id = '306723'
    and pdp_metadata:scope:reinventory = 'true';
    -- and pdp_metadata:scope:reinventory = 'false';
    -- AND csv_file_id = 157020797;


/* NSM cost_unit alert */
SELECT 
    *    
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    partner_id = 381
    AND created_at >= current_date - 2
    AND data:lookup_code ILIKE '%020668500000%'
    -- csv_file_id = '148502131'
LIMIT 20;


/* Giant Eagle Inventory Issue */

SELECT 
    -- *
    DISTINCT
    csv_file_id,
    created_at,
    data,
    pdp_metadata:input:filename,
    pdp_metadata:scope:reinventory
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    -- retailer_id IN ('2002','3366')
    partner_id = 7979
    AND created_at >= current_date - 3
ORDER BY created_at asc
LIMIT 50;


/* Wakefern Sale price file */

SELECT 
    -- *
    DISTINCT
    csv_file_id,
    created_at,
    data:sale_start_at::STRING sale_start,
    data:sale_end_at::STRING sale_end
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    -- retailer_id IN ('2002','3366')
    partner_id = 2246
    AND created_at >= current_date - 15
    AND pdp_metadata:input:filename ILIKE '%WAG_Local_Feed_File_%'
    AND data:sale_start_at IS NOT NULL
ORDER BY created_at asc
LIMIT 50;

/* Grocery outlet */

SELECT 
    -- *  ,
    DISTINCT
    DATE(created_at) date,
    data:lookup_code::STRING UPC,
    data:retailer_reference_code::STRING RRC,
    data:brand_name::STRING brand_name,
    -- data:location_code::STRING store_id,
    data:name::STRING name,
    -- data:available available,
    -- data:department::STRING Department,
    -- data:remote_image_url::STRING Image_URL,
    data:cost_price_per_unit cost_price,
    data:cost_unit::STRING cost_unit,
    data:size::STRING size,
    data:size_uom::STRING size_uom,
    data:remote_image_url::STRING Image_URL,
    
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    partner_id = 4493
    AND created_at >= current_date - 1
    AND data:retailer_reference_code = '963764'
    -- AND UPC = '10810063711709'
ORDER BY
    date DESC
LIMIT 500;





/* Yokes commodity */

SELECT 
    DISTINCT
    data:name::STRING name,
    data:lookup_code::STRING UPC,
    -- data:location_code::STRING store_id,
    created_at,
    -- data:scannable_upc
    
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    retailer_id = 2635
    -- partner_id = 10976
    AND created_at >= current_date - 1
    -- csv_file_id = '156007089'
    AND name ILIKE '%organic%'
AND data:lookup_code RLIKE '^0*(9\d{5})$'
LIMIT 50;



/* Grocery outlet */

SELECT 
    -- *  
    DISTINCT
    DATE(created_at) date,
    data:lookup_code::STRING UPC,
    data:retailer_reference_code::STRING RRC,
    data:brand_name::STRING brand_name,
    data:name::STRING name,
    data:department::STRING Department,
    data:remote_image_url::STRING Image_URL,
    
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    -- retailer_id IN ('2002','3366')
    partner_id = 4493
    AND created_at >= current_date - 2
    AND data:retailer_reference_code = '603966'
    -- AND UPC IN ('00751666150850',
    --             '00854505005035',
    --             '00729062120821',
    --             '00803944304957',
    --             '00699058601644',
    --             '00699058643460',
    --             '00816239013533',
    --             '00854758002201',
    --             '00664789042004',
    --             '00674526720744',
    --             '00011110222985',
    --             '00000000000060',
    --             '00684924030055',
    --             '00689259001619',
    --             '00073150121550',
    --             '00803944306692')
ORDER BY
    Date DESC
LIMIT 50;


/* Yoke's scan issue */

SELECT 
    *    
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    retailer_id = 2635
    -- partner_id = 10976
    AND created_at >= current_date - 1
    AND data:lookup_code::STRING ILIKE '%940115%'
    -- , '932837')
LIMIT 50;


/* Brookshire Reasor RRC Issue */
SELECT 
    DISTINCT
    created_at,
    data:name::STRING name,
    data:lookup_code::STRING UPC,
    data:retailer_reference_code::STRING RRC,
    retailer_id,
    -- data:private_label_item::STRING Private_label,
    pdp_metadata:input:filename::STRING filename
    -- *    
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    -- partner_id = 472
    retailer_id = 278
    AND created_at >= current_date - 2
    -- csv_file_id = '155043746'
    -- AND UPC ILIKE '%9282521081%'
    AND RRC IS NOT NULL
    -- AND retailer_id IS NOT NULL
    -- AND Private_label IS NOT NULL
LIMIT 10;




/* NSM sale issue */
SELECT 
    *    
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    -- retailer_id = 436
    partner_id = 381
    -- retailer_id IN ('2002','3366')
    -- csv_file_id = '154772540'
    AND data:lookup_code ILIKE '%26758600000%'
    AND created_at >= current_date - 5
    -- AND data:lookup_code ILIKE '%94427%'
    -- AND data:lookup_code ILIKE '%94552%'
LIMIT 50;



/* Roche Bro - Visibilty Issue */

SELECT 
    DISTINCT
    data:lookup_code,
    data:available,
    data:name,
    data:cost_price_per_unit
    -- *    
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    -- retailer_id IN ('2002','3366')
    -- partner_id = 10976
    csv_file_id = '154234418'
    and data:lookup_code IN ('79044', '79037', '250544000007')
    -- AND created_at >= current_date - 3
LIMIT 50;


/* NSM Image issue */

SELECT 
    DISTINCT
    DATE(created_at) date,
    data:lookup_code::STRING UPC,
    data:retailer_reference_code::STRING RRC,
    data:name::STRING Name,
    data:available::STRING available,
    data:size::STRING Size,
    data:size_uom::STRING size_uom,
    data:cost_unit::STRING cost_unit,
    data:cost_price_per_unit::STRING cost_price_per_unit,
    
    data:remote_image_url::STRING Image_URL,
    -- data:location_code::STRING store_id,
    csv_file_id,
    pdp_metadata:scope:retailer_id
    
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    -- retailer_id IN ('2002','3366')
    partner_id = 381
    AND created_at >= current_date - 2
    -- AND data:lookup_code ILIKE '%2038960000%'
    AND UPC IN ('020802100000','020319600000','020319500000','020839700000')
ORDER BY date ASC, UPC asc
LIMIT 50;



/* Wakefern/Morton Williams In-house product UPC list */

SELECT 
    -- *
    DISTINCT
    pfnd.data:brand_name::STRING  brand_name,
    pfnd.data:name::STRING  name,
    pfnd.data:lookup_code::STRING  UPC,
    pfnd.data:available::STRING available,
    -- data:cost_price_per_unit::STRING  cost_price_per_unit,
    pfnd.data:cost_unit::STRING  cost_unit,
    wl.location_code as store_id,
    -- data:location_code::STRING store_id,
    -- data:size::STRING  size,
    -- data:size_uom::STRING  size_uom,
    -- data:location_code as store_id,
    -- pfnd.inventory_area_id IA,
    -- csv_file_id,
    DATE(pfnd.created_at) date,
    pfnd.pdp_metadata:input:filename::STRING filename
FROM
    catalog.catalog.partner_file_normalized_data pfnd
JOIN    
    instadata.rds_data.warehouse_locations wl
ON
    pfnd.retailer_id=wl.warehouse_id and pfnd.inventory_area_id=wl.inventory_area_id
WHERE  
    -- partner_id = 567
    pfnd.retailer_id = 497
    AND DATE(pfnd.created_at) = current_date 
    -- AND data:lookup_code ILIKE '%27005000000%'
    -- AND data:lookup_code ILIKE '%27002400000%'
AND (pfnd.data:brand_name ILIKE 'Boars Head' 
OR pfnd.data:brand_name ILIKE 'Boar''s Head')-- AND data:brand_name ILIKE '%boars head%'
    -- AND cost_price_per_unit = '15.99'
    AND pfnd.data:cost_unit = 'each'
ORDER BY store_id ASC;
-- LIMIT 100;




/* Walgreen Promotion Mapping */
SELECT 
    -- *  
    -- DISTINCT
    row_number,
    data:lookup_code::STRING UPC,
    data:cost_price_per_unit::STRING COST_PRICE,
    data:sale_price_cents::STRING SALE_PRICE,
    data:sale_start_at::STRING SALE_START,
    data:sale_end_at::STRING SALE_END,
    data:promotion:promotion_group_id::STRING PROMO_GROUP,
    data:promotion:promotion_type::STRING PROMO_TYPE,
    data:promotion:promotion_start_at::STRING PROMO_START,
    data:promotion:promotion_end_at::STRING PROMO_END,
    data:promotion:promotion_metadata::STRING PROMO_METADATA
    
    -- data:sale_type::STRING SALE_TYPE,  
    -- data:sale_price::STRING SALE_PRICE,
    -- data:sale_scale::STRING SALE_SCALE,
    -- data:sales_multiplier::STRING SALES_MULTIPLIER,
    -- data:quantity::STRING QUANTITY,
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    -- partner_id = 2246
    -- AND created_at >= current_date - 2
     csv_file_id = '153749611'
     -- AND SALE_PRICE IS NOT NULL
     AND PROMO_END IS NOT NULL
     -- AND SALE_END IS NOT NULL
ORDER BY row_number asc;
    -- AND data:sale_type IN ('2', '0','1','3');
-- LIMIT 100;




/* Wakefern Location_data */

SELECT 
    DISTINCT
    data:location_code::STRING store_id,
    retailer_id
    -- data:location_data
    -- *    
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    -- retailer_id IN ('2002','3366')
    partner_id = 138
    -- retailer_id = 163
    AND created_at >= current_date - 15
    AND data:location_data IS NOT NULL
    
    -- AND inventory_area_id IN ('3437, ')
ORDER BY store_id ASC;
-- LIMIT 50;



/* Roche Bro promo issue */

SELECT 
    *
    -- DISTINCT
    -- data:name AS name,
    -- data:lookup_code AS UPC
    -- -- data:sku AS sku
    -- *    
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    -- partner_id = 2218
    retailer_id = 1526
    AND csv_file_id = '153125767'
    -- AND data:lookup_code  = '72745001277'
    AND data:cost_price_per_unit <= '0.05'
    -- AND data:name LIKE '%Blueberries%'  -- Corrected typo
    -- AND created_at >= current_date - 2
    -- AND csv_file_id = '148502131'  -- Uncomment if needed
LIMIT 20;



/* NSM Multiple UPC/RRC */

SELECT 
    DISTINCT
    -- *    
    data:lookup_code::STRING UPC,
    data:retailer_reference_code::STRING RRC,
    created_at::STRING Date
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    retailer_id = 308
    -- partner_id = 10976
    AND created_at >= current_date - 90
    -- AND UPC IN ('00042272014316', '00004227201431')
    AND RRC = '1654887'
LIMIT 5;


/* Roche Bro Blueberries issue */

SELECT 
    DISTINCT
    data:name AS name,
    data:lookup_code AS UPC
    -- data:sku AS sku
    -- *    
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    -- partner_id = 2218
    retailer_id = 1526
    AND data:name LIKE '%Blueberries%'  -- Corrected typo
    AND created_at >= current_date - 2
    -- AND csv_file_id = '148502131'  -- Uncomment if needed
LIMIT 20;



/* Roche_Bros banana availability */

SELECT 
    *
    -- DISTINCT
    -- DATE(created_at) date,
    -- partner_id P_ID,
    -- retailer_id R_ID,
    -- data:lookup_code::STRING UPC,
    -- data:available available,
    -- data:name::STRING name ,
    -- data:cost_price_per_unit cost_price
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    retailer_id = 1526
    -- partner_id = 2218
    AND created_at BETWEEN '2025-04-01' AND '2025-06-30'
    AND data:lookup_code ILIKE '%20342800000%'
    AND data:available = true
    -- AND data:lookup_code = '55130'
-- order by DATE DESC
LIMIT 1;



/* Roche_Bros utz chips*/

SELECT 
    *
    -- DISTINCT
    -- DATE(created_at) date,
    -- data:location_code::STRING store,
    -- inventory_area_id IA,
    -- data:lookup_code::STRING UPC,
    -- data:available available,
    -- data:name::STRING name ,
    -- data:cost_price_per_unit cost_price,
    -- data:sale_price_cents::STRING sale_price,
    -- data:sale_start_at::STRING sale_start,
    -- data:sale_end_at::STRING sale_end,
    -- data:promotion:promotion_start_at promotion_Start,
    -- data:promotion:promotion_end_at promotion_end,
    -- data:promotion:promotion_group_id promotion_group_id,
    -- pdp_metadata:source:test_file test_file
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    -- retailer_id = 1526
    partner_id = 2218
    -- AND retailer_id = 1526
    AND created_at >= current_date - 3
    -- AND csv_file_id = '152868622'
    -- AND sale_start IS NOT NULL;
    -- AND created_at >= '2025-10-19'
    -- AND created_at < '2025-10-26'
    -- AND data:promotion:promotion_start_at IS NOT NULL
    -- AND data:lookup_code  IN ('41780271877', '41780271662', '41780271839', '41780350985', '41780271815', '41780271822')
    -- AND data:lookup_code IN ('12000001130', '13000001137', '14100077138', '18000004027');
    -- '13000001137', '14100077138', '18000004027')
    AND data:lookup_code = '16000219960'
    and inventory_area_id = '85689';
    -- AND data:sale_end_at IS NOT NULL
    -- AND data:lookup_code  = '71537021318'
    -- ORDER BY DATE DESC
-- QUALIFY COUNT(*) OVER (PARTITION BY data:promotion:promotion_group_id) > 1;


/* Rosauers Supermarkets */

SELECT 
    *    
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    -- retailer_id IN ('2002','3366')
    partner_id = 5343
    AND created_at >= current_date - 2
    AND data:lookup_code LIKE '85842500555'
LIMIT 50;



/* Wakefern associated banners for locations_data */

SELECT 
    DISTINCT
    retailer_id

FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    partner_id = 138
    AND created_at >= current_date - 30
    AND data:location_data IS NOT NULL
LIMIT 50;




/* Yoke's missing aisle information */

SELECT 
    DISTINCT
    data:location_data,
    data:lookup_code::STRING,
    inventory_area_id
    -- *    
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    retailer_id = 2635
    -- partner_id = 10976
    AND created_at >= current_date - 2
    -- AND data:lookup_code = '00013562300112'
LIMIT 50;




/* PW Item not available issue */

SELECT 
    -- *  
    data:available,
    data:location_code,
    data:name,
    inventory_area_id,
    created_at,
    csv_file_id
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    -- retailer_id = 68
    partner_id = 639
    AND created_at >= current_date - 3
    -- AND data:lookup_code = '00254937000002'
    AND inventory_area_id = 24096
LIMIT 20;



/* Walmart Reuse UPC Issue */

SELECT 
    -- *
    DISTINCT
    -- csv_file_id File,
    -- lead_code,
    DATE(created_at) date,
    data:lookup_code::STRING UPC,
    data:retailer_reference_code::STRING RRC,
    data:location_code store,
    -- code_set_version,
    -- locale_id,
    data:name Name,
    data:department Department,
    data:details Details,
    pdp_metadata:normalization:column_map_id column_Map
    
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    retailer_id = 462
    -- partner_id = 10976
    AND created_at >= current_date - 2
    AND data:lookup_code = '4812'
    AND data:department IS NOT NULL
    AND RRC != '982055'
ORDER BY date desc
LIMIT 50;



/* ShopRite/Wakefern Alcoholic attribute */

SELECT 
    DISTINCT
    csv_file_id,
    data:alcoholic::STRING,
    data:restrictedsaletype::STRING,
    pdp_metadata:normalization:column_map_id
    
        
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    -- retailer_id IN ('2002','3366')
    partner_id = 138
    AND created_at >= current_date - 3
    AND pdp_metadata:normalization:column_map_id IN ('66991', '66992', '68207')
LIMIT 500;



/* PWMW */

SELECT 
    distinct
    data:location_code,
    *    
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    -- retailer_id IN ('2002','3366')
    partner_id = 639
    AND created_at >= current_date - 3
    AND data:location_code IN ('7','38','41') 
LIMIT 500;


/* Kohl's product pricing Issue */

SELECT 
    -- *  
    csv_file_id CSV,
    DATE(created_at) date,
    data:available::STRING available,
    data:cost_price_per_unit::STRING cost_price,
    data:sale_price_cents::STRING sale_price,
    DATE(data:sale_start_at)::STRING sale_start,
    DATE(data:sale_end_at)::STRING sale_end,
    data:location_code::STRING store_id,
    data:lookup_code::STRING UPC
    
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    partner_id = 7008
    -- AND created_at >= current_date - 90
    AND created_at >= DATE '2025-07-25' -- start of July
    AND created_at < DATE '2025-08-15'  -- end of Sept
    AND inventory_area_id = '152513'
    AND data:lookup_code = '400795130195'
    
LIMIT 500;



/* Yokes - Check for Alcoholic products */

SELECT 
    -- *
    created_at,
    data:lookup_code::STRING UPC,
    data:available::STRING available,
    data:size::STRING size,
    data:size_uom::STRING size_uom,
    -- inventory_area_id IA
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    -- retailer_id IN ('2002','3366')
    partner_id = 7571
    AND created_at >= current_date - 7
    -- AND data:lookup_code = '00000000040624'
    AND data:lookup_code IN ('000000004688', '00000000040884', '00000000046886', '000000003054', '000000003465')
    -- AND inventory_area_id = '153242'
    -- AND data:alcoholic = 'true'
    -- AND data:location_data IS NOT NULL
    -- AND data:location_data:aisle LIKE ('ORGANIC-32')
LIMIT 100;



/* Yokes - Issue with size */

SELECT 
    DISTINCT 
    data:location_data,
    data:location_data:Aisle::STRING aisle,
    -- data:location_data:area::STRING area,
    -- data:location_data:section::STRING section,
    data:location_data:Location::STRING location,
    data:location_data:Shelf::STRING shelf,
    
    created_at,
    pdp_metadata:normalization:column_map_id column_map
    -- data:lookup_code::STRING UPC,11
    -- data:available::STRING available,
    -- data:size::STRING size,
    -- data:size_uom::STRING size_uom,
    -- inventory_area_id IA
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    -- retailer_id IN ('2002','3366')
    partner_id = 138
    AND created_at >= current_date - 10
    -- AND data:lookup_code = '00000000047135'
    -- AND data:lookup_code = '00000000045964'
    -- AND inventory_area_id = '153264'
    AND data:location_data IS NOT NULL
    -- AND data:location_data:Aisle LIKE ('PRODUCE-30')
LIMIT 200;




/* Save Mart - file for 1 UPC */

SELECT 
    DISTINCT
    csv_file_id CSV,
    created_at DATE,
    data:lookup_code::STRING UPC,
    data:retailer_reference_code::STRING RRC
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    partner_id = 621
    AND created_at >= current_date - 30
    -- AND data:lookup_code = '210'
    AND data:retailer_reference_code IS NULL
    AND data:lookup_code = '0098487957719'
LIMIT 100;



/* Niemann Foods Inc - check location code */

SELECT 
    *
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    -- retailer_id = 505
    partner_id = 709
    AND csv_file_id = '148773993'
    -- AND created_at >= current_date - 20
    -- AND data:lookup_code = '00766684897991'
    -- AND data:promotion_start_at IS NOT NULL
    -- AND inventory_area_id = '142709'
LIMIT 50;


/* Niemann Foods Inc - check file for 1 IA */

SELECT 
    DISTINCT
    created_at
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    -- retailer_id = 505
    partner_id = 709
    AND created_at >= current_date - 20
    -- AND data:lookup_code = '00766684897991'
    -- AND data:promotion_start_at IS NOT NULL
    AND inventory_area_id = '142709'

LIMIT 50;

/* Niemann Foods Inc - file received per IA */ 

SELECT 
    DISTINCT
    pfnd.inventory_area_id,
    wl.location_code store_id,
    wl.name name,
    wl.active Active_Status
FROM
    catalog.catalog.partner_file_normalized_data pfnd
JOIN
    instadata.rds_data.warehouse_locations wl
ON
    pfnd.retailer_id = wl.warehouse_id    AND pfnd.inventory_area_id = wl.inventory_area_id
    
WHERE  
    pfnd.retailer_id IN ('616','2584',' 3366','2002')
    -- partner_id = 709
    AND pfnd.created_at >= current_date - 1
    -- AND STORE_ID = '568'
ORDER BY store_id::INTEGER ASC;    
LIMIT 50;


SELECT 
    -- DISTINCT
    -- csv_file_id,
    -- created_at,
    -- lead_code,
    -- data:retailer_reference_code::STRING,
    pfnd.data:lookup_code::STRING UPC,
    ceiv.item_id item_id,
    pfnd.data:location_code::STRING store_id,
    ceiv.data:retailer_promotion_details:discount_begins_at::STRING promotion_start,
    ceiv.data:retailer_promotion_details:discount_ends_at::STRING promotion_end,
    ceiv.data:retailer_promotion_details:promotion_group_id::STRING promo_group_id,
    ceiv.data:has_retailer_promotion promotion_status
    -- data:available,
    -- retailer_id,
    -- data:size::STRING
FROM
    catalog.catalog.partner_file_normalized_data pfnd
JOIN 
    catalog.catalog.current_elastic_item_view ceiv
ON
    pfnd.data:lookup_code = ceiv.data:retailer_lookup_code AND pfnd.retailer_id = ceiv.retailer_id
WHERE  
    pfnd.retailer_id = 1946
    AND promotion_start > '2025-09-15'
    -- AND promo_group_id = '1'
    -- pfnd.partner_id = 307
    -- AND created_at >= '2025-04-04'
    -- AND data:lookup_code = '00810291001002'
    -- AND pdp_metadata:scope:reinventory = 'true'
    AND pfnd.csv_file_id = '146826122';
    
    -- AND ceiv.data:
-- ORDER BY created_at desc
-- LIMIT 500;



SELECT 
    *
    -- CSV_FILE_ID,
    -- data:lookup_code,
    -- created_at,
    -- data:available,
    -- data:location_code,
    -- pdp_metadata:scope:reinventory,
    -- -- pdp_metadata:source:test_file
    
FROM
    catalog.catalog.partner_file_normalized_data
WHERE  
    retailer_id = 2635
    -- partner_id = 138
    AND created_at >= current_date - 120
    -- AND pdp_metadata:normalization:column_map_id = '54474'
    AND data:lookup_code IN ('4079', '4567','3320','00033383699998','40792') 
    -- csv_file_id = '144510459'
    -- data:location_code = '1042'
    -- AND normalization_run_id = '148122827';
LIMIT 10;







SELECT *
    -- DISTINCT pdp_metadata:normalization:column_map_id,
    -- pdp_metadata:input:filename,
    -- data,
    -- pdp_metadata
FROM
    catalog.catalog.partner_file_normalized_data
WHERE
    partner_id = 621
    and retailer_id = 294
        AND created_at >= current_date - 2
        -- AND data:lookup_code::string = '00253058000007' 
        -- AND pdp_metadata:input:filename NOT LIKE '%united%'
        -- AND pdp_metadata:normalization:column_map_id IN 
        -- ('67095', '65639', '67098')
        -- ('65643', '65641', '53158')
-- ORDER BY 1
LIMIT 10;


-- For Ace ICE

SELECT 
    DISTINCT CSV_FILE_ID,
    created_at,
    data:name::STRING as Product_Name,
    data:lookup_code::STRING as UPC,
    data:cost_price_per_unit::STRING as Cost_Price,
    data:cost_unit::STRING as Cost_Unit,
    data:size::STRING as Size,
    data:location_code::STRING as Store_ID,
    inventory_area_id as IA,
    pdp_metadata:input:filename::STRING as FILENAME
FROM
    catalog.catalog.partner_file_normalized_data
    -- instadata.rds_data.csv_files
WHERE  
    partner_id = 568 
    AND created_at >= current_date - 7
    AND data:lookup_code::string = '00750230000058'
    -- AND data:lookup_code::string IN ('00000000040270', '00000000040470', '00000000042800', '00000000042820', '00000000042830', '00000000042840', '00000000042850', '00000000042870', '00000000044910', '00000000044920', '00000000044930', '00000000044940', '00000000044950', '00000000044960', '00240270000007', '00240470000005', '00242800000006', '00242820000000', '00242830000007', '00242840000004', '00242850000001', '00242870000005', '00244281000001', '00244289000003', '00244491000006', '00244492000005', '00244494000003', '00244495000002', '00244496000001', '00244910000006', '00244920000003', '00244930000000', '00244940000007', '00244950000004', '00244960000001', '40270', '40470', '42800', '42820', '42830', '42840', '42850', '42870', '44910', '44920', '44930', '44940', '44950', '44960')
    -- AND (data:size != '1 LB' AND data:size != '1 lb') 
LIMIT 50;



-- For Onion

SELECT 
    DISTINCT CSV_FILE_ID,
    created_at,
    data:name::STRING as Product_Name,
    data:lookup_code::STRING as UPC,
    data:cost_price_per_unit::STRING as Cost_Price,
    data:cost_unit::STRING as Cost_Unit,
    data:size::STRING as Size,
    data:location_code::STRING as Store_ID,
    inventory_area_id as IA,
    pdp_metadata:input:filename::STRING as FILENAME
FROM
    catalog.catalog.partner_file_normalized_data
    -- instadata.rds_data.csv_files
WHERE  
    partner_id = 568 
    AND created_at >= current_date - 60
    -- /July 10 -  July 30/
    AND data:lookup_code::string = '00244163000006'
    -- AND (data:size != '1 LB' AND data:size != '1 lb') 
    AND data:cost_unit != 'lb'
LIMIT 50;



-- For Tomato

SELECT 
    DISTINCT CSV_FILE_ID,
    created_at,
    data:name::STRING as Product_Name,
    data:lookup_code::STRING as UPC,
    data:cost_price_per_unit::STRING as Cost_Price,
    data:cost_unit::STRING as Cost_Unit,
    data:size::STRING as Size,
    data:location_code::STRING as Store_ID,
    inventory_area_id as IA,
    pdp_metadata:input:filename::STRING as FILENAME
FROM
    catalog.catalog.partner_file_normalized_data
    -- instadata.rds_data.csv_files
WHERE  
    partner_id = 568 
    AND created_at >= current_date - 60
    AND data:lookup_code::string = '00244064000006'
    -- AND (data:size != '1 LB' AND data:size != '1 lb') 
    AND data:cost_unit != 'lb'
LIMIT 50;



-- For Red Plum

SELECT 
    DISTINCT CSV_FILE_ID,
    created_at,
    data:name::STRING as Product_Name,
    data:lookup_code::STRING as UPC,
    data:cost_price_per_unit::STRING as Cost_Price,
    data:cost_unit::STRING as Cost_Unit,
    data:size::STRING as Size,
    data:location_code::STRING as Store_ID,
    inventory_area_id as IA,
    pdp_metadata:input:filename::STRING as FILENAME
FROM
    catalog.catalog.partner_file_normalized_data
    -- instadata.rds_data.csv_files
WHERE  
    partner_id = 568 
    AND created_at >= current_date - 60
    AND data:lookup_code::string IN 
        ('00000000044340', '00000000044440', '00244042000004', '00244340000003', '00244434000001', '00244440000002', '00244444000008', '44340', '44440')
    -- AND (data:size != '1 LB' AND data:size != '1 lb') 
    AND data:cost_unit != 'lb'
LIMIT 50;



-- For Bacon Burger

SELECT 
    DISTINCT CSV_FILE_ID,
    created_at,
    data:name::STRING as Product_Name,
    data:lookup_code::STRING as UPC,
    data:cost_price_per_unit::STRING as Cost_Price,
    data:cost_unit::STRING as Cost_Unit,
    data:size::STRING as Size,
    data:location_code::STRING as Store_ID,
    inventory_area_id as IA,
    pdp_metadata:input:filename::STRING as FILENAME
FROM
    catalog.catalog.partner_file_normalized_data
    -- instadata.rds_data.csv_files
WHERE  
    partner_id = 568 
    AND created_at >= current_date - 30
    AND data:lookup_code::string = '00256406000001'
    -- AND (data:size != '1 LB' AND data:size != '1 lb') 
    AND data:cost_unit = 'lb'
LIMIT 50;



-- For Fresh Short Rib Blend Steakhouse Burger

SELECT 
    DISTINCT CSV_FILE_ID,
    created_at,
    data:name::STRING as Product_Name,
    data:lookup_code::STRING as UPC,
    data:cost_price_per_unit::STRING as Cost_Price,
    data:cost_unit::STRING as Cost_Unit,
    data:size::STRING as Size,
    data:location_code::STRING as Store_ID,
    inventory_area_id as IA,
    pdp_metadata:input:filename::STRING as FILENAME
FROM
    catalog.catalog.partner_file_normalized_data
    -- instadata.rds_data.csv_files
WHERE  
    partner_id = 568 
    AND created_at >= current_date - 60
    AND data:lookup_code::string = '00251753000001'
    AND (data:size = '8 ct' AND data:size = '8 Ct' AND data:size = '8ct' AND data:size = '8Ct') 
    -- AND data:cost_unit != 'each'
    -- AND size != '8 oz'
    -- AND Size = '8 ct'
LIMIT 5000;



-- For Shrimp Kabobs

SELECT 
    DISTINCT CSV_FILE_ID,
    created_at,
    data:name::STRING as Product_Name,
    data:lookup_code::STRING as UPC,
    data:cost_price_per_unit::STRING as Cost_Price,
    data:cost_unit::STRING as Cost_Unit,
    data:size::STRING as Size,
    data:location_code::STRING as Store_ID,
    inventory_area_id as IA,
    pdp_metadata:input:filename::STRING as FILENAME
FROM
    catalog.catalog.partner_file_normalized_data
    -- instadata.rds_data.csv_files
WHERE  
    partner_id = 568 
    AND created_at >= current_date - 60
    AND data:lookup_code::string IN ('00256585000007', '00256838000000','00256838000006','00256579000006')
    -- AND (data:size != '1 LB' AND data:size != '1 lb') 
    -- AND data:cost_unit != 'each'
    AND data:size NOT LIKE '%oz%'
    -- AND (data:size = '2 ct' AND data:size = '2 Ct')
LIMIT 500;






SELECT 
    *
FROM
    catalog.catalog.partner_file_normalized_data
WHERE
    -- retailer_id = 205
    partner_id = 709
    AND created_at >= DATEADD (DAY, -60, CURRENT_TIMESTAMP())
    AND pdp_metadata:normalization:column_map_id != '54132'
LIMIT 10;


SELECT 
    DISTINCT data:lookup_code::STRING as UPC,
    data:restricted_reasons,
    p.*
    
FROM 
    catalog.catalog.partner_file_normalized_data p,
    TABLE(FLATTEN(input => p.data:restricted_reasons)) AS f
WHERE
    p.partner_id = 80
    AND p.created_at >= DATEADD(DAY, -2, CURRENT_TIMESTAMP())
    AND p.data:restricted_otc = TRUE
    AND f.value = 'NRT'
LIMIT 5;


SELECT 
    DISTINCT CSV_FILE_ID,
    -- -- pdp_metadata,
    -- pdp_metadata:input:filename,
    data:location_code,
    -- *
FROM
    catalog.catalog.partner_file_normalized_data
WHERE
    retailer_id = 1296
    AND csv_file_id IN ('141297095','141302113','140931825')
    -- AND data:lookup_code = '004400005222'
    -- partner_id = 138
    -- AND data:location_code IN ('266','473') 
    -- AND data:lookup_code = '008901433255'
    -- AND data:retailer_reference_code = '2548435'
    AND created_at >= DATEADD (DAY, -5, CURRENT_TIMESTAMP())
LIMIT 150;


SELECT 
     *
FROM
    catalog.catalog.partner_file_normalized_data
WHERE
    -- retailer_id = 1296
    partner_id = 138
    -- AND csv_file_id = '141289814'
    AND pdp_metadata:normalization:column_map_id = 66991
    -- AND data:promotion:promotion_end_at
    AND CAST(
    GET_PATH (data, 'promotion.promotion_end_at') AS DATE
  ) BETWEEN CURRENT_DATE
  AND DATEADD (DAY, 1, CURRENT_DATE)
  AND NOT GET_PATH (data, 'promotion.promotion_end_at') IS NULL
    -- AND created_at >= DATEADD (DAY, -5, CURRENT_TIMESTAMP())
LIMIT 10;



SELECT 
    DISTINCT CSV_FILE_ID, 
    data:location_code,
    normalization_run_id,
    inventory_area_id,
    *
    
FROM
    catalog.catalog.partner_file_normalized_data
WHERE
    -- retailer_id = 246
    partner_id = 7571
    AND created_at >= DATEADD (DAY, -15, CURRENT_TIMESTAMP())
    -- AND created_at >= '2025-06-30'
    -- AND pdp_metadata:input:filename NOT LIKE '%rosie%'
    AND pdp_metadata:normalization:column_map_id = '66659'
    AND data:location_code IS NOT NULL
    -- AND pdp_metadata:scope:reinventory = 'true'
    -- AND data:location_code = '242'
    -- AND data:location_code IN (242, 58, 198, 186, 199, 215)
    -- AND normalization_run_id = '140828242'
        -- AND row_number = '74284'
    -- GROUP BY data:location_code, 
LIMIT 150;



SELECT retailer_id, lead_code, inventory_area_id, data:retailer_reference_code as RRC
FROM
    catalog.catalog.partner_file_normalized_data
WHERE
    retailer_id = 173 // Chef's Store
    AND created_at >= DATEADD (DAY, -30, CURRENT_TIMESTAMP())
    -- AND normalization_run_id = '137718844'
LIMIT 100;





SELECT 
    DISTINCT pdp_metadata:normalization:column_map_id as column_map_id,
    csv_file_id, 
    created_at
FROM
    catalog.catalog.partner_file_normalized_data
WHERE
    retailer_id = 308
    AND created_at >= DATEADD (DAY, -30, CURRENT_TIMESTAMP())
LIMIT 1000;


SELECT 
    csv_file_id, 
    pdp_metadata:normalization:column_map_id AS column_map_id,
    data:alcoholic as Alcoholic,
    data:location_code as Location_Code    
FROM
    catalog.catalog.partner_file_normalized_data
WHERE
    retailer_id = 1956
    AND normalization_run_id = '136648482'
    AND data:alcoholic = true
LIMIT 100;


/* Albertsons column map cleanup - unique column map used */
SELECT 
    DISTINCT GET_PATH (pdp_metadata, 'normalization.column_map_id') AS column_map_id,
    csv_file_id, 
    GET_PATH (pdp_metadata, 'input.filename') AS filename
FROM
    catalog.catalog.partner_file_normalized_data
WHERE
    partner_id = 386
    AND created_at >= DATEADD (DAY, -7, CURRENT_TIMESTAMP())
    -- AND NOT CAST(
    --         GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    --         ) ILIKE '%delta%'
    -- AND NOT GET_PATH (pdp_metadata, 'input.filename') IS NULL
--     AND column_map_id IN (65854,65664,65663,65662,65661,65660,65659,65658,65657,65656,65655,65654,65653,65652,65651,65650,65649,65648,65647,65646,65645,65644,65643,65642,65641,65640,
-- 65639,65637,65636,64671,63670,60424,57632,53170,53158)
    AND column_map_id = '65662'
LIMIT 100;


SELECT DISTINCT CSV_FILE_ID, partner_id, created_at, inventory_area_id, lead_code , data:lookup_code, data:available
FROM
    catalog.catalog.partner_file_normalized_data
WHERE
    retailer_id = 3359
    AND inventory_area_id = 299283
LIMIT 10;


SELECT DISTINCT CSV_FILE_ID, partner_id, created_at, inventory_area_id, lead_code , data:lookup_code, data:available, data:cost_price_per_unit, data:brand_name, data:name, data:size
from catalog.catalog.partner_file_normalized_data
WHERE 
    retailer_id = 12
    AND lead_code = 'rrc_0000000000000071'
    AND created_at >= DATEADD (DAY, -2, CURRENT_TIMESTAMP())
    AND data:lookup_code = '4099100043341'
-- and inventory_area_id = 115018
-- and INVENTORY_AREA_ID  = 168468
-- , 288457, 288449, 288428, 289092)
LIMIT 1000;


/* Generated by Snowflake Copilot */
SELECT
  DISTINCT GET_PATH (data, 'size') AS product_size,
  COUNT(*) AS count,
  data:name, data:brand_name, csv_file_id, created_at 
FROM
  catalog.catalog.partner_file_normalized_data
WHERE
  retailer_id = 12
  AND lead_code = 'rrc_0000000000000071'
  AND created_at >= DATEADD (DAY, -2, CURRENT_TIMESTAMP())
  AND NOT GET_PATH (data, 'size') IS NULL
GROUP BY
  GET_PATH (data, 'size'), csv_file_id, created_at, data:brand_name, data:name, data:size
ORDER BY
  product_size;


/* To identify which files are sending incorrect sizing data, we can analyze the data by grouping and counting sizes per csv_file_id */
SELECT
  csv_file_id,
  inventory_area_id,
  GET_PATH (data, 'size') AS product_size,
  COUNT(*) AS product_count,
  MIN(created_at) AS file_created_at,
  COUNT(DISTINCT GET_PATH (data, 'lookup_code')) AS unique_products
FROM
  catalog.catalog.partner_file_normalized_data
WHERE
  retailer_id = 12
  AND created_at >= DATEADD (DAY, -7, CURRENT_TIMESTAMP())
  AND lead_code = 'rrc_0000000000000071'
  AND NOT GET_PATH (data, 'size') IS NULL
GROUP BY
  csv_file_id,
  inventory_area_id,
  GET_PATH (data, 'size')
HAVING
  product_count > 1
ORDER BY
  csv_file_id,
  product_size;


SELECT 
    partner_id, 
    csv_file_id, 
    created_at, 
    inventory_area_id,
    lead_code, 
    data, 
    GET_PATH (data, 'skin_type') AS skin_type,
    -- GET_PATH (
    --     GET_PATH (data, 'variant_attributes'),
    --     'product_sku_swatch'
    --     ) AS product_sku_swatch
from 
    catalog.catalog.partner_file_normalized_data
WHERE 
    retailer_id = 1493
    AND created_at >= DATEADD (DAY, -30, CURRENT_TIMESTAMP())

    -- AND data:product_sku_skintype IS NOT NULL
    -- AND csv_file_id = 133657522
LIMIT 1000;


  
/* show distinct data per inventory area */
SELECT
  DISTINCT inventory_area_id,
  partner_id,
  csv_file_id,
  lead_code,
  GET_PATH (data, 'lookup_code') AS lookup_code,
  GET_PATH (data, 'available') AS available,
  GET_PATH (data, 'cost_price_per_unit') AS cost_price
FROM
  catalog.catalog.partner_file_normalized_data
WHERE
  retailer_id = 1603
  AND inventory_area_id IN (168468, 288457, 288449, 288428, 289092)
  AND created_at >= DATEADD (DAY, -7, CURRENT_TIMESTAMP())
  AND created_at < CURRENT_TIMESTAMP()
LIMIT
  10;

  
  /* Generated by Snowflake Copilot */
SELECT
  partner_id,
  csv_file_id,
  created_at,
  inventory_area_id,
  lead_code,
  data,
  GET_PATH (data, 'product_sku_skintype') AS product_sku_skintype
FROM
  catalog.catalog.partner_file_normalized_data
WHERE
  retailer_id = 1493
  -- AND csv_file_id = 133672618
  AND created_at >= DATEADD (DAY, -3, CURRENT_TIMESTAMP());

  
  
  /* Generated by Snowflake Copilot */
SELECT
  DISTINCT csv_file_id,
  -- inventory_area_id,
  MIN(created_at) AS file_timestamp,
  GET_PATH (data, 'size') AS product_size,
  GET_PATH (data, 'lookup_code') AS lookup_code,
  GET_PATH (data, 'name') AS product_name
  -- COUNT(*) AS records_count,
  -- filename

FROM
  catalog.catalog.partner_file_normalized_data
WHERE
  retailer_id = 12
  AND lead_code = 'rrc_0000000000000071'
  AND created_at >= DATEADD (DAY, -2, CURRENT_TIMESTAMP())
  AND GET_PATH (data, 'size') ILIKE '%12 oz%'
GROUP BY
  csv_file_id,
  -- inventory_area_id,
  GET_PATH (data, 'size'),
  GET_PATH (data, 'lookup_code'),
  GET_PATH (data, 'name');

  
/* Generated by Snowflake Copilot */
SELECT
  GET_PATH (data, 'location_code'),
  GET_PATH (data, 'available'),
  *
FROM
  catalog.catalog.partner_file_normalized_data
WHERE
  retailer_id = 173
  AND GET_PATH (data, 'lookup_code') = '008901433255'
  AND created_at BETWEEN CAST('2025-06-26' AS TIMESTAMPTZ)
  AND CAST('2025-07-07' AS TIMESTAMPTZ)
LIMIT
  150;







