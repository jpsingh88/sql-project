SELECT 
    wl.location_code AS store_id,
    wl.inventory_area_id,
    wl.name AS Store_name,
    wl.active AS Active_Status,
    COUNT(DISTINCT pfnd.created_at) AS file_count
FROM
    instadata.rds_data.warehouse_locations wl
LEFT JOIN
    catalog.catalog.partner_file_normalized_data pfnd
ON
    pfnd.retailer_id = wl.warehouse_id
    AND pfnd.inventory_area_id = wl.inventory_area_id
    AND pfnd.created_at >= current_date - 5 -- Updated to last 4 days
WHERE   
    wl.warehouse_id = 241 
    and Active_Status = TRUE
GROUP BY 
    wl.location_code, 
    wl.inventory_area_id,
    wl.name, 
    wl.active
ORDER BY 
    Active_Status DESC,
    file_count DESC;