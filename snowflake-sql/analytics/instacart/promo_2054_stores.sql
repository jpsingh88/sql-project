/* Walgreen Promotion Delta File */
/*
Runbook/Procedure to upload delta file
1. On every monday, update the CSV FILE ID with the new CSV_FILE_ID received on Sunday
2. Compare the total number of rows with the number of normalized rows in orginial csv_file
3. Download the results in CSV format
4. Rename the filename by adding current_date as suffix. For example - promo_2054_stores_2025_Nov_21
5. Upload the csv into Walgreen account (which will be a delta)
*/
SELECT
    row_number,
    data:store_code::NUMBER store_code,
    data:upc::STRING upc,
    data:wic::STRING wic,
    -- data:is_alcohol::STRING is_alcohol,
    -- data:is_available::STRING is_available,
    data:price::STRING price,
    data:sale_type::STRING sale_type,
    data:ut::STRING ut,
    data:sales_multiplier::STRING sales_multiplier,
    data:sale_scale::STRING sale_scale,
    -- data:usa_snap_eligible::STRING usa_snap_eligible
FROM
    catalog.catalog.partner_file_raw_data pfrd
    JOIN "CATALOG"."TMP"."WALGREEN_PROMO_STORE_ID" wps ON pfrd.data:store_code::NUMBER = wps.location_code
WHERE
    -- partner_id = 2246
    csv_file_id = '162262485'
    AND data:sale_type IN ('1','2', '3')
ORDER BY
    row_number asc;
    -- LIMIT 10;
