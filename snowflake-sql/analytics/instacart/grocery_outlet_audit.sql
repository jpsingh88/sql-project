select * from catalog.tmp.tmp_grocery_catalog_audit_data_1217
where avail_items > 0
and (array_size (lead_codes) >1 or array_size (scan_codes)!= array_size(pfnd_lookup_codes))
order by 1,2,7;


SELECT 
    DISTINCT
    data:retailer_reference_code::STRING RRC,
    data:lookup_code::STRING UPC,
    data:available::STRING available,
    data:name::STRING name,
    data:brand::STRING brand,
    data:remote_image_url::STRING image_url
FROM 
    catalog.catalog.partner_file_normalized_data
WHERE 
    retailer_id = 1871
    -- AND RRC = '603966'
    AND UPC ILIKE '%69905860164%'
    AND created_at >= current_date - 3
-- ORDER BY created_at DESC
LIMIT 50;