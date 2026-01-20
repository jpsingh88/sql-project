/* Template */
SELECT 
    *    
FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    partner_id = 381
    AND created_at >= current_date - 2
    -- csv_file_id = '148502131'
LIMIT 20;



/* Template */
SELECT 
    *    
FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    partner_id = 381
    AND created_at >= current_date - 2
    -- csv_file_id = '148502131'
LIMIT 20;


/* Wakefern Loyalty price issue */
SELECT 
    *    
FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    partner_id = 138
    AND created_at >= current_date - 2
    AND pdp_metadata:scope:reinventory = 'true'
    AND data:sku ILIKE '%74236526445%'
    -- csv_file_id = '148502131'
LIMIT 20;


/* CVS perfume issue */
SELECT 
    DISTINCT
    DATE(created_at) date,
    csv_file_id,
    pdp_metadata:input:filename::STRING filename,
    data:prim_upc_nbr::STRING UPC,
    data:retailer_reference_code::STRING RRC,
    data:store_nbr::NUMBER store_id,
    -- data:description::STRING Name,
    data:promotion_start_at::STRING promotion_start,
    data:promotion_end_at::STRING promotion_end,
    -- data:promotion_group_id::STRING promo_group_id,
    data:promotion_metadata::STRING promotion_metadata,
    data:promotion_type::STRING promotion_type,
    data:reduced::STRING reduced,
    data:sale_offer_type::STRING sale_offer_type,
    data:sku_nbr_list::STRING sku_nbr_list
FROM
    catalog.catalog.partner_file_raw_data
WHERE
    -- retailer_id = 118
    partner_id = 80
    AND created_at >= current_date - 1
    -- AND data:retailer_lookup_code ILIKE '%746480038132%';
    -- AND data:prim_upc_nbr = '801100380920'
    AND RRC = '435360'
ORDER BY date desc;
-- LIMIT 200;



/* Grocery Outlet Image Issue */
SELECT 
    *    
FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    partner_id = 4493
    AND created_at >= current_date - 2
    -- csv_file_id = '148502131'
    AND data:internal_item_id = '226027'
LIMIT 20;


/* PWMW Promotion Issue */
SELECT 
    DISTINCT
    DATE(created_at) date,
    data:lookup_code::STRING UPC,
    -- data:available::STRING available,
    data:brand_name::STRING brand_name,
    data:item_name::STRING product_name,
    data:price::STRING cost_price,
    data:sale_price::STRING sale_price,
    DATE(data:sale_start_at::STRING) sale_Start,
    DATE(data:sale_end_at::STRING) sale_end,
    DATE(data:promotion_start_at::STRING) promo_start,
    DATE(data:promotion_end_at::STRING) promo_end,
    
FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    partner_id = 639
    -- retailer_id = 68
    AND created_at >= current_date - 3
    and UPC IN ('00078000082166','00012000504051')
    -- AND promo_end IS NOT NULL
ORDER BY date desc
-- LIMIT 50;
;



-- For Lunds promotion rejection

SELECT 
    DISTINCT
    -- CSV_FILE_ID,
    DATE(created_at) Date,
    data:lookup_code::STRING UPC,
    -- data:store_identifier::STRING store_id,
    data:promotion_start_at::STRING promotion_start_date,
    data:promotion_end_at::STRING promotion_end_date,
    data:promotion_metadata::STRING promotion_metadata,
    data:promotion_group_id::STRING promotion_group_id,
    
FROM
    catalog.catalog.partner_file_raw_data
    -- instadata.rds_data.csv_files
WHERE  
    -- partner_id = 568 
    -- AND created_at >= current_date - 7
    CSV_FILE_ID = '157490774'
    AND data:promotion_metadata IS NULL
    AND promotion_start_date IS NOT NULL;
-- LIMIT 20;


/* NSM cost_unit alert */
SELECT 
    *    
FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    partner_id = 381
    AND created_at >= current_date - 2
    AND data:item_upc = '020668500000'
    -- csv_file_id = '148502131'
LIMIT 20;




/* Walgreens Sale vs Promo */

SELECT
    row_number,
    data:store_code::NUMBER store_code,
    data:upc::STRING upc,
    data:wic::STRING rrc,
    -- data:is_alcohol::STRING is_alcohol,
    -- data:is_available::STRING is_available,
    data:price::STRING price,
    data:sale_price::STRING sale_price,
    data:sale_type::STRING sale_type,
    data:ut::STRING ut,
    data:sales_multiplier::STRING sales_multiplier,
    data:sale_scale::STRING sale_scale,
    -- data:usa_snap_eligible::STRING usa_snap_eligible
FROM
    catalog.catalog.partner_file_raw_data pfrd
WHERE
    -- partner_id = 2246
    csv_file_id = '156624014'
    AND data:sale_type IN ('1', '3')
    AND price != sale_price
ORDER BY
    row_number asc;
    -- LIMIT 100;


/* NoFrills Sale */
SELECT 
    DISTINCT
    data:upc,
    data:brand_name,
    data:item_name,
    data:price,
    data:sale_price,
    data:sale_start_at,
    data:sale_end_at

FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    partner_id = 369
    AND created_at >= current_date - 2
    AND data:upc ILIKE '%6609612330%'
    -- csv_file_id = '148502131'
LIMIT 20;


/* NSM/NLCM EAN Ingestion */
SELECT 
    -- *
    data:banner_category_desc::STRING Category,
    data:item_brand_name::STRING brand_name,
    data:item_longdesc::STRING DESCRIPTION,
    data:item_upc::STRING UPC,
    data:banner_item_id::STRING Prev_RRC,
    pdp_metadata:input:filename::STRING filename
FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    partner_id = 381
    -- AND created_at >= current_date - 2
    -- AND data:item_upc ILIKE '%25843500000%'
    AND data:item_upc ILIKE '%2202226000%'
    -- csv_file_id = '148502131'
    AND Prev_RRC IS NOT NULL
LIMIT 10;



/* Brookshire Reasor RRC Issue */
SELECT 
    DISTINCT
    data:item_name::STRING name,
    data:lookup_code::STRING UPC,
    data:retailer_reference_code::STRING RRC,
    data:private_label_item::STRING Private_label,
    pdp_metadata:input:filename::STRING filename
    -- *    
FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    partner_id = 472
    AND created_at >= current_date - 2
    -- csv_file_id = '155043746'
    AND UPC ILIKE '%9282521081%'
    -- AND RRC IS NULL
    -- AND Private_label IS NOT NULL
LIMIT 10;


/* NSM sale issue */
SELECT 
    DISTINCT
    csv_file_id,
    data:item_upc::STRING UPC,
    data:promo_effective_start_date::STRING SALE_START,
    data:promo_effective_end_date::STRING SALE_END,
    data:promo_price_marketplace::STRING SALE_PRICE,
    data:name::STRING NAME,
    pdp_metadata:input:filename::STRING filename
    
FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    partner_id = 381
    AND data:item_upc ILIKE '%26700100000%'
    AND created_at >= current_date - 15
    -- retailer_id IN ('2002','3366')
    -- csv_file_id = '154631529'
    -- AND data:item_upc ILIKE '%94427%'
LIMIT 50;



/* NSM image issue */
SELECT 
    DISTINCT
    csv_file_id,
    DATE(created_at) date,
    data:item_upc::STRING UPC,
    -- data:retailer_reference_code::STRING RRC,
    data:item_longdesc::STRING Name,
    data:available::STRING available,
    data:unit_size::STRING Size,
    data:item_uom::STRING size_uom,
    data:item_scale_flag::STRING cost_unit,
    data:reg_price_marketplace::STRING cost_price,
    
    data:remote_image_url::STRING Image_URL,
    pdp_metadata:input:filename::STRING Filename
    -- data:store_id::STRING store_id
    
FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    -- retailer_id IN ('2002','3366')
    partner_id = 381
    AND created_at >= current_date - 3
    AND data:item_upc ILIKE '%2070310000%'
    -- AND UPC IN ('020577700000', '020549600000', '000000001165')
ORDER BY Filename asc, date ASC
LIMIT 50;


SELECT * FROM catalog.catalog.partner_file_raw_data
WHERE  partner_id = 381
    AND created_at >= current_date - 3
    AND data:item_upc = '020764300000'
    AND pdp_metadata:input:filename ILIKE '%NSM%'
    LIMIT 10;


/* Yoke's Delta File Issue  */
SELECT 
    DISTINCT
    pdp_metadata:input:filename,
    csv_file_id
    -- *    
FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    partner_id = 7571
    AND created_at BETWEEN '2025-11-05' AND '2025-11-08'
    AND pdp_metadata:input:filename ILIKE '%delta%'
    -- csv_file_id = '148502131'
LIMIT 200;



/* Sam's Club Item drop count */
select distinct 
        retailer_id, 
        count_if (pfnd_avail) as current_avail,
        count_if (raw_avail) as raw_avail
from catalog.tmp.tmp_sams_raw_avail_data t 
group by 1;

select distinct 
    pfnd.retailer_id, 
    pfnd.inventory_area_id,
    pfnd.lead_code,
    pfnd.data:lookup_code::STRING UPC,
    ceiv.product_id, 
    ceiv.item_id,
    pfnd.data:available::boolean as pfnd_avail,
    pf.data:available::boolean as raw_avail
from catalog.catalog.partner_file_normalized_data pfnd
join catalog.catalog.partner_file_raw_data pf using (row_number, csv_file_id)
join catalog.catalog.retailer_code_products rcp using (retailer_id, code_set_version)
join catalog.catalog.current_elastic_item_view ceiv using (retailer_id, product_id, inventory_area_id)
where partner_id = 287
-- and pf.created_at > current_date - 1
and rcp.code = pfnd.lead_code
and pfnd.retailer_id = 352
and pfnd.csv_file_id = 158851023
qualify row_number () over (partition by pfnd.lead_code, pfnd.inventory_area_id order by pfnd.id desc) = 1;




/* Wakefern - cost_price 0 */
SELECT 
    DISTINCT
    csv_file_id CSV_ID,
    COUNT(data:itemcode),
    -- ::STRING UPC,
    -- data:salequantity::STRING sale_quantity,
    -- data:quantityrequired::STRING quantity_req,
    -- data:picklistitem::STRING pick_list_item,
    -- data:unitprice::STRING unit_price,
    data:storenumber Store_ID,
    file_type
    -- pdp_metadata:input:filename::STRING
    
    -- data:itemdescription::STRING Item_Name
    -- *    
FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    partner_id = 138
    AND created_at >= current_date - 2
    -- AND csv_file_id = '152835128'
    AND data:unitprice = '0'
    AND file_type != 'generated_from_partner_api'
GROUP BY CSV_ID, Store_ID, file_type
LIMIT 500;



/* Walgreen Promotion Mapping */
SELECT 
    -- *  
    DISTINCT
    row_number,
    data:upc::STRING UPC,
    data:price::FLOAT COST_PRICE,
    data:sale_type::STRING SALE_TYPE,  
    data:sale_price::FLOAT SALE_PRICE,
    data:sale_scale::STRING SALE_SCALE,
    data:sales_multiplier::STRING SALES_MULTIPLIER,
    data:quantity::STRING QUANTITY,
    pdp_metadata:input:filename::STRING filename
FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    partner_id = 2246
    -- AND created_at >= current_date - 2
    AND csv_file_id IN ('155086775', '154993009')
    -- , '154850775', '154690225', '154569979', '154405316', '154273918', '154129290', '154045431', '153884314', '153757661',
-- '153644325','153504103','153386597','153275369', '153147175', '153047661')
    AND data:sale_type = '2'
    -- AND pdp_metadata:input:filename ILIKE '%WAG_Local_Feed%'
    -- AND  SALE_PRICE > COST_PRICE
ORDER BY row_number asc
LIMIT 10;





/* Roche Bro Blueberries raw name */
SELECT *
    -- DISTINCT
    -- data:item_name AS name,
    -- data:lookup_code AS UPC,
    -- data:sku AS sku
    -- *    
FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    partner_id = 2218
    AND data:item_name LIKE '%Blueberries%'  -- Corrected typo
    AND created_at >= current_date - 2
    -- AND csv_file_id = '148502131'  -- Uncomment if needed
LIMIT 20;



/* Roche_Bros */

SELECT 
    *
    -- DISTINCT
    -- DATE(created_at) date,
    -- -- -- -- -- partner_id P_ID,
    -- -- -- -- -- retailer_id R_ID,
    -- data:lookup_code::STRING UPC,
    -- data:store_id::STRING store_id,
    -- data:item_name::STRING name,
    -- data:available::STRING available,
    -- data:displayecom::STRING displayecom, 
    -- data:store_id::STRING store_id,
    -- data:cost_price_per_unit::STRING cost_price,
    -- data:promotion_start_at::STRING promotion_start,
    -- data:promotion_end_at::STRING promotion_end,
    -- data:promotion_type::STRING promotion_type,
    -- data:promotion_metadata::STRING promotion_metadata,
    -- data:promotion_group_id::STRING promotion_id,
    -- data:sale_start_at::STRING sale_start,
    -- data:sale_end_at::STRING sale_end,
    -- data:sale_price::STRING sale_price
    
FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    -- retailer_id = 1526
    partner_id = 2218
    AND created_at >= current_date - 3
     -- csv_file_id = '153857567'
    AND data:lookup_code  = '16000219960'
    AND data:store_id = '120'
    -- AND data:cost_price_per_unit <= '0.05'
    -- AND data:displayecom = '1'
    -- AND data:available = true
    -- AND data:lookup_code  = '898248001572'
    -- AND data:promotion_start_at IS NOT NULL
    -- AND data:lookup_code = '55130'
-- order by DATE DESC
LIMIT 100;




/* Tops Market Incorrect Price */

SELECT 
    DISTINCT
    data:upc::STRING UPC,
    data:price::STRING Cost_Price
    
FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    partner_id = 378
    AND created_at >= current_date - 3
    and data:price < '0.05'
LIMIT 500;




/* PWMW Store_ID issue */
SELECT 
    DISTINCT
    -- created_at,
    data:store_identifier::INTEGER
    -- *    
FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    partner_id = 639
    AND created_at >= current_date - 7
    -- csv_file_id = '148502131'
    -- AND data:store_identifier
-- ORDER BY data:store_identifier::INTEGER ASC;
LIMIT 200;



/* Kohl's product pricing Issue */

SELECT 
    -- *  
    csv_file_id CSV,
    DATE(created_at) date,
    data:storefront_availability::STRING available,
    data:price::STRING cost_price,
    data:sale_price::STRING sale_price,
    data:your_price::STRING in_store_price,
    DATE(data:sale_price_effective_date)::STRING sale_start,
    DATE(data:sale_price_end_date)::STRING sale_end
    -- data:gtin::STRING UPC
FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    partner_id = 7008
    AND pdp_metadata:input:filename LIKE ('%product%')
    -- AND created_at >= current_date - 5
    AND created_at >= DATE '2025-07-30' 
    AND created_at < DATE '2025-08-02'  
    AND data:gtin = '400795130195'
LIMIT 500;


-- For Save Mart
SELECT 
    DISTINCT
    created_at,
    -- data:item_name::STRING name,
    data:lookup_code::STRING UPC,
    data:retailer_reference_code::STRING RRC,
    data:available::STRING available,
    data:in_assortment::STRING in_assortment,
    data:sfp_available::STRING SFP_AVAILABLE,
    data:store_identifier::STRING STORE_ID
    
FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    partner_id = 621
    AND created_at >= current_date - 15
    AND rrc = '283' 
    AND in_assortment = 'FALSE'
    -- csv_file_id = '148502131'
-- GROUP BY
--     store_id, available, in_assortment, sfp_available
LIMIT 50;





-- Lunds
SELECT 
    *    
FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    partner_id = 568
    AND created_at >= current_date - 7
    AND data:lookup_code = '00018169433010'
    AND data:promotion_start_at IS NOT NULL
    -- csv_file_id = '146222589'
LIMIT 20;



-- Niemann Food Inc
SELECT 
    DISTINCT
    -- csv_file_id,
    created_at,
    -- data:location_code::STRING,
    pdp_metadata:scope:inventory_area_id
        
FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    partner_id = 709
    AND created_at >= current_date - 15
    AND pdp_metadata:scope:inventory_area_id = '142709'
    -- csv_file_id = '146222589'
LIMIT 20;


SELECT 
    *    
FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    partner_id = 568
    AND created_at >= current_date - 120
    AND data:lookup_code = '00766684897991'
    -- csv_file_id = '146222589'
LIMIT 5;


SELECT 
    DISTINCT
    wl.location_code store_id,
    wl.name name
    
FROM
    catalog.catalog.partner_file_raw_data pfrd
JOIN
    catalog.catalog.current_partner_retailers_view cprv
ON
    pfrd.partner_id = cprv.partner_id
JOIN
    instadata.rds_data.warehouse_locations wl
ON
    cprv.retailer_id = wl.warehouse_id AND pfrd.data:store_identifier = wl.location_code
WHERE  
    pfrd.partner_id = 709
    AND wl.warehouse_id = 616
    AND wl.active = 'TRUE' 
    AND pfrd.created_at >= current_date - 7;
    -- csv_file_id = '146222589'
-- LIMIT 20;



SELECT 
    *
FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    partner_id = 307
    AND created_at >= current_date - 30
    AND csv_file_id = '146826141'
     -- AND data:a_d = '0'
     -- AND data:promotion_metadata IS NOT NULL;
-- LIMIT 10;





SELECT 

    data:cost_price_per_unit::STRING cost_price,
    data:in_store_price::STRING in_store_price,
    data:sale_start_at::STRING sale_start,
    data:sale_end_at::STRING sale_end
FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    partner_id = 10976
    AND created_at >= current_date - 10
    AND cost_price = in_store_price
    -- AND pdp_metadata:input:filename LIKE '%L155%'
LIMIT 100;


SELECT 
data:cost_price_per_unit::STRING,
data:in_store_price::STRING,
csv_file_id
    -- *
FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    partner_id = 10976
    AND created_at >= current_date - 2
    AND data:cost_price_per_unit != data:in_store_price
LIMIT 100;
    

SELECT 
    *
FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    partner_id = 709
    AND PARSE_JSON(data):snap IS NOT NULL
--    AND PARSE_JSON(data):sale IS NOT NULL
    -- AND created_at >= current_date - 5
LIMIT 10;


SELECT 
    data:store_identifier,
    data:available,
    COUNT (data:lookup_code)
FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    partner_id = 621 
    AND created_at >= current_date - 5
    AND data:store_identifier IN ('421', '422')
GROUP BY data:store_identifier, data:available;



SELECT 
    DISTINCT CSV_FILE_ID,
    created_at,
    data:item_name::STRING,
    data:lookup_code::STRING,
    data:price::STRING,
    data:size::STRING,
FROM
    catalog.catalog.partner_file_raw_data
    -- instadata.rds_data.csv_files
WHERE  
    partner_id = 568 
    AND created_at >= current_date - 2
    AND data:lookup_code::string IN ('00000000040270', '00000000040470', '00000000042800', '00000000042820', '00000000042830', '00000000042840', '00000000042850', '00000000042870', '00000000044910', '00000000044920', '00000000044930', '00000000044940', '00000000044950', '00000000044960', '00240270000007', '00240470000005', '00242800000006', '00242820000000', '00242830000007', '00242840000004', '00242850000001', '00242870000005', '00244281000001', '00244289000003', '00244491000006', '00244492000005', '00244494000003', '00244495000002', '00244496000001', '00244910000006', '00244920000003', '00244930000000', '00244940000007', '00244950000004', '00244960000001', '40270', '40470', '42800', '42820', '42830', '42840', '42850', '42870', '44910', '44920', '44930', '44940', '44950', '44960')
    -- AND data:size != '1 LB'
LIMIT 5;



select
    DISTINCT csv_file_id,
    data
from 
    catalog.catalog.partner_file_raw_data
where
    partner_id = 568
    AND created_at >= current_date - 120
    AND data:remote_image_url IS NOT NULL
    LIMIT 2;
 






SELECT 
    DISTINCT data:item_name,
    
FROM
    catalog.catalog.partner_file_raw_data
    -- instadata.rds_data.csv_files
WHERE  
    partner_id = 500
    AND created_at >= DATEADD (DAY, -3, CURRENT_TIMESTAMP())
    -- AND data:lookup_code = '69804096'
    AND data:item_name LIKE '%Red Grapes%'
LIMIT 15;





SELECT 
    *
FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    partner_id = 161
    AND created_at >= DATEADD(DAY, -3, CURRENT_TIMESTAMP())
    AND data:location_data:ranked_locations[0].fixLocAbbreviated IS NOT NULL
    AND data:location_data:ranked_locations[0].locationType IS NOT NULL
LIMIT 2;







/* For Albertsons Promotion Metadata Column map */

SELECT 
    -- DISTINCT data:store_id,
    -- *
    COUNT (CSV_FILE_ID),
    -- data,
    data:promotion_metadata_new,
    data:promotion_metadata
FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    partner_id = 386
    -- AND csv_file_id = '141379348'
    AND pdp_metadata:scope:reinventory = true
    AND (
        data:promotion_metadata IS NOT NULL 
        OR data:promotion_metadata_new IS NOT NULL 
        )
    AND created_at >= DATEADD (DAY, -1, CURRENT_TIMESTAMP())
GROUP BY COUNT (CSV_FILE_ID),data:promotion_metadata_new,data:promotion_metadata

LIMIT 100;





SELECT 
    DISTINCT data:store_id,
    -- *
    -- DISTINCT CSV_FILE_ID,
    -- data,
    -- data:nrt_identifier
FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    partner_id = 885
    AND csv_file_id = '141302113'
    -- AND pdp_metadata:scope:retailer_id = '10'
    AND created_at >= DATEADD (DAY, -1, CURRENT_TIMESTAMP())
    -- AND data:abs_reg_retail_qty = true
LIMIT 100;



SELECT 
    DISTINCT CSV_FILE_ID,
    data,
    data:nrt_identifier
FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    partner_id = 80
    AND data:nrt_identifier <> '0'
    -- AND pdp_metadata:scope:retailer_id = '10'
    AND created_at >= DATEADD (DAY, -1, CURRENT_TIMESTAMP())
    -- AND data:abs_reg_retail_qty = true
LIMIT 100;



SELECT 
    csv_file_id,
    data:upc,
    data:brand
    
FROM
    catalog.catalog.partner_file_raw_data
WHERE  
    partner_id = 291
    AND created_at >= DATEADD (DAY, -90, CURRENT_TIMESTAMP())
    AND data:upc = '0003700071477'
LIMIT 2;





SELECT
    csv_file_id, data:promotion_group_id, data:promotion:start_at, data:promotion_end_at, data:promotion_metadata, data:promotion_group_id, data:promotion_type, data:lookup_code
FROM
    catalog.catalog.partner_file_raw_data
WHERE
    partner_id = 639
    AND created_at >= DATEADD (DAY, -5, CURRENT_TIMESTAMP())
    AND normalization_run_id = '140828242'
    AND row_number IN (10000282718,
10000286572,
10000286695,
10000286837,
10000287119,
10000287596,
10000287760,
10000287769,
10000287770,
10000287780,
10000287787,
10000288640,
10000288641,
10000288664,
20000046134,
20000059267,
20000059268)
    -- AND data:promotion_group_id IS NOT NULL
LIMIT 20;




SELECT 
    csv_file_id,
    data:fac as store_id,
    data,
    -- created_at,
    -- pdp_metadata:input:filename, 
    -- pdp_metadata:scope:retailer_id      
FROM
    catalog.catalog.partner_file_raw_data
WHERE
    partner_id = 386
    -- AND pdp_metadata:scope:retailer_id = 375
    AND pdp_metadata:scope:reinventory = 'false'
    AND created_at >= DATEADD (DAY, -5, CURRENT_TIMESTAMP())
LIMIT 5000;

SELECT csv_file_id, data:fac as store_id, ANY_VALUE(data) as sample_data
FROM catalog.catalog.partner_file_raw_data
WHERE partner_id = 386
AND pdp_metadata:scope:reinventory = 'false'
AND created_at >= DATEADD (DAY, -5, CURRENT_TIMESTAMP())
GROUP BY csv_file_id, store_id
LIMIT 1000;

SELECT csv_file_id, data:fac as store_id
FROM catalog.catalog.partner_file_raw_data
WHERE partner_id = 386
-- AND pdp_metadata:scope:reinventory = 'true'
AND pdp_metadata:input:filename ILIKE '%pak_n_save%'
AND created_at >= DATEADD (DAY, -2, CURRENT_TIMESTAMP())
GROUP BY csv_file_id, store_id
LIMIT 10;



SELECT 
    CSV_FILE_ID, 
    CREATED_AT, 
    data, 
    pdp_metadata, 
    CAST(GET_PATH (pdp_metadata, 'input.filename') AS TEXT) AS filename
    
FROM
    catalog.catalog.partner_file_raw_data
WHERE
    partner_id = 386
    AND created_at >= DATEADD (DAY, -2, CURRENT_TIMESTAMP())
    and csv_file_id = '134750647'
    AND NOT CAST(
    GET_PATH (pdp_metadata, 'input.filename') AS TEXT
  ) ILIKE '%delta%'
  AND NOT GET_PATH (pdp_metadata, 'input.filename') IS NULL    
LIMIT 200;

/* Generated by Snowflake Copilot */
SELECT
  DISTINCT CAST(
    GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) AS filename,
    CSV_FILE_ID, 
    CREATED_AT, 
FROM
  catalog.catalog.partner_file_raw_data
WHERE
  partner_id = 386
  AND created_at >= DATEADD (DAY, -2, CURRENT_TIMESTAMP())
  AND 
  AND NOT CAST(
    GET_PATH (pdp_metadata, 'input.filename') AS TEXT
  ) ILIKE '%delta%'
  AND NOT GET_PATH (pdp_metadata, 'input.filename') IS NULL
ORDER BY
  filename;



  
/* Generated by Snowflake Copilot */
SELECT
  DISTINCT CAST(
    GET_PATH (pdp_metadata, 'input.filename') AS TEXT
  ) AS filename
FROM
  catalog.catalog.partner_file_raw_data
WHERE
  partner_id = 386
  AND created_at >= DATEADD (DAY, -2, CURRENT_TIMESTAMP())
  AND NOT CAST(
    GET_PATH (pdp_metadata, 'input.filename') AS TEXT
  ) ILIKE '%delta%'
  AND (
    CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%OMS_Promo_file%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%combined_king%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%combined_balduccis%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%pak_n_save%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%star__market%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%albertsons%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%jewel-osco%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%tom-thumb%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%safeway-organics%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%haggen%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%balduccis%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%carrs%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%albertsons.market%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%scm%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%randalls%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%shaw%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%acme%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%shaws%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%pavilions%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%combined_vons%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%ams%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%united%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%united-supermarkets%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%amigos%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%market-street%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%combined_safeway%'
  )
ORDER BY
  filename;


  
/* Generated by Snowflake Copilot */
SELECT
  DISTINCT csv_file_id,
  CAST(
    GET_PATH (pdp_metadata, 'input.filename') AS TEXT
  ) AS filename,
  CAST(GET_PATH (data, 'product_group_id') AS TEXT) AS product_group_id,
  CAST(GET_PATH (data, 'promotion_type') AS TEXT) AS promotion_type,
  CAST(GET_PATH (data, 'promotion_group_id') AS TEXT) AS promotion_group_id,
  CAST(GET_PATH (data, 'promotion_start_date') AS TEXT) AS promotion_start_date,
  CAST(GET_PATH (data, 'promotion_end_date') AS TEXT) AS promotion_end_date,
  CAST(GET_PATH (data, 'promotion_metadata') AS TEXT) AS promotion_metadata,
  CAST(
    GET_PATH (data, 'promotion_metadata_new') AS TEXT
  ) AS promotion_metadata_new
FROM
  catalog.catalog.partner_file_raw_data
WHERE
  partner_id = 386
  AND created_at >= DATEADD (DAY, -2, CURRENT_TIMESTAMP())
  AND NOT CAST(
    GET_PATH (pdp_metadata, 'input.filename') AS TEXT
  ) ILIKE '%delta%'
  AND NOT CAST(
    GET_PATH (pdp_metadata, 'input.filename') AS TEXT
  ) ILIKE '%tam_internal%'
  AND NOT GET_PATH (data, 'promotion_metadata_new') IS NULL
  AND (
    CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%OMS_Promo_file%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%combined_king%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%combined_balduccis%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%pak_n_save%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%star__market%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%albertsons%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%jewel-osco%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%tom-thumb%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%safeway-organics%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%haggen%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%balduccis%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%carrs%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%albertsons.market%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%scm%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%randalls%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%shaw%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%acme%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%shaws%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%pavilions%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%combined_vons%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%ams%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%united%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%united-supermarkets%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%amigos%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%market-street%'
    OR CAST(
      GET_PATH (pdp_metadata, 'input.filename') AS TEXT
    ) ILIKE '%combined_safeway%'
  )
ORDER BY
  filename;

  
/* Generated by Snowflake Copilot */
SELECT
  CSV_FILE_ID,
  CREATED_AT,
  CAST(
    GET_PATH (pdp_metadata, 'input.filename') AS TEXT
  ) AS filename
FROM
  catalog.catalog.partner_file_raw_data
WHERE
  partner_id = 386
  AND created_at >= DATEADD (DAY, -10, CURRENT_TIMESTAMP())
  AND GET_PATH (pdp_metadata, 'input.filename') ILIKE '%combined_jewel_osco_3234__version_2__2025-06-02.csv%'
LIMIT 5;




SELECT 
    CSV_FILE_ID, 
    CREATED_AT, 
    -- data, 
    -- pdp_metadata, 
    CAST(GET_PATH (pdp_metadata, 'input.filename') AS TEXT) AS filename
    
FROM
    catalog.catalog.partner_file_raw_data
WHERE
    partner_id = 7296
    AND created_at >= DATEADD (DAY, -5, CURRENT_TIMESTAMP());
/* Generated by Snowflake Copilot */
SELECT
  DISTINCT CSV_FILE_ID,
  data,
  CAST(GET_PATH (data, 'nrt_identifier') AS VARCHAR) AS nrt_identifier
FROM
  catalog.catalog.partner_file_raw_data
WHERE
  partner_id = 80
  AND CAST(GET_PATH (data, 'nrt_identifier') AS VARCHAR) <> '0'
  AND NOT CAST(GET_PATH (data, 'nrt_identifier') AS VARCHAR) IS NULL
  AND created_at >= DATEADD (DAY, -1, CURRENT_TIMESTAMP())
LIMIT
  100;

  
/* Generated by Snowflake Copilot */
SELECT
  DISTINCT CSV_FILE_ID,
  created_at,
  data,
  CAST(GET_PATH (data, 'nrt_identifier') AS VARCHAR) AS nrt_identifier
FROM
  catalog.catalog.partner_file_raw_data
WHERE
  partner_id = 80
  -- AND CAST(GET_PATH (data, 'nrt_identifier') AS VARCHAR) IN('0', '1')
  -- AND NOT CAST(GET_PATH (data, 'nrt_identifier') AS VARCHAR) IS NULL
  AND created_at >= DATEADD (DAY, -1, CURRENT_TIMESTAMP());

    -- AND GET_PATH (pdp_metadata, 'input.filename') = 'combined_jewel_osco_3234__version_2__2025-06-02.csv'
  