select distinct 
    pfnd.retailer_id,
    rcp.product_id, 
    pfnd.lead_code UPC,
    crv.data:normalized_brand_name::string as brand_name,
    crv.data:name::string name,
    crv.data:classified_type::string product_type, 
    CASE 
        WHEN crv.data:image_hero_primary_url::string IS NOT NULL 
        THEN 'yes' 
        ELSE NULL 
    END as image_url
from catalog.catalog.partner_file_normalized_data pfnd
join catalog.catalog.retailer_code_products rcp 
    on rcp.code = pfnd.lead_code 
    and rcp.retailer_id = pfnd.retailer_id 
    and rcp.code_set_version = pfnd.code_set_version
join catalog.catalog.current_retailer_product_view crv 
    on rcp.retailer_id = crv.retailer_id 
    and crv.product_id = rcp.product_id
where 1=1
    and pfnd.surface_id = 1
    and pfnd.retailer_id = 1339
    and pfnd.created_at >= current_timestamp - interval '30 days'
order by retailer_id, product_id
-- limit 10;
-- limit 10;
-- 68,895