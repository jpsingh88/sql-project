/* NSM NLCM Image issue */ Jan 12, 2026
-- This query lists all products with images from bristolfarms, comparing them to what's in PFND based on the updated retailer file.

SELECT
    DISTINCT
    DATE(pfnd.created_at) date,
    pfnd.data:lookup_code::STRING UPC,
    PARSE_JSON(prfd.raw):brand_name::string AS brand_name,
    PARSE_JSON(prfd.raw):name::string AS name,
    PARSE_JSON(prfd.raw):remote_image_url::string AS product_image_url,
    pfnd.data:remote_image_url::STRING retailer_raw_image
FROM
    instadata.rds_data.PRODUCT_RETAILER_FILE_DATA prfd
    JOIN
    catalog.catalog.partner_file_normalized_data pfnd
    ON
    prfd.retailer_id = pfnd.retailer_id AND prfd.lead_code = pfnd.lead_code
WHERE
    pfnd.retailer_id = 308    
    AND date >= CURRENT_DATE()
    AND product_image_url ILIKE '%cdn.bristolfarms.com%'
ORDER BY UPC ASC, date DESC;




-- This query shows the images which have a fallback image and which don't. We have hidden the one which have a fallback image and the remaining needs to be audited
-- This is the improved version of the above query


    select  
    crv.product_id,
    pfnd.lead_code,
    pfnd.data:lookup_code::STRING UPC,
    crv.retailer_id,
    crv.sources:image_hero_large_url:source_type::string as source_type,
    1 as locale_id,	
    'image' as attribute,
    'hero' as angle,
    'true' as hidden,
    'hide old bad images' as created_why,
    crv.data:display_name::string                               as display_name,
    listagg(distinct parse_json(prfd.raw):name::string, ', ')   as prfd_name,
    pfnd.data:remote_image_url::text                            as pfnd_image,
    parse_json(prfd.raw):remote_image_url::string               as prfd_image,
    crv.data:image_hero_primary_url::string                     as current_winning_image,
    listagg (distinct '<img src=' || '"https://d2lnr5mha7bycj.cloudfront.net/product-image/file/large_'||pi.file ||'"width="20%">')                       as fallback_images,
    -- listagg(distinct 'https://d2lnr5mha7bycj.cloudfront.net/product-image/file/large_'||pi.file, ' ') as fallback_images,
    array_unique_agg(il.value:source_type)                      as image_sources,
    array_size(array_unique_agg(il.value:source_type))          as image_source_counts
from catalog.catalog.partner_file_normalized_data   as pfnd
join instadata.rds_data.product_retailer_file_data  as prfd on true
    and prfd.retailer_id = pfnd.retailer_id
    and prfd.lead_code = pfnd.lead_code
join instadata.rds_data.product_sources             as ps on true
    and ps.source_id = prfd.id
    and ps.deleted_at is null
    and prfd.deleted_at is null
    and ps.source_type = 'Product::Datum::RetailerFile'
join catalog.catalog.current_retailer_product_view  as crv on true
    and crv.retailer_id = prfd.retailer_id
    and crv.product_id = ps.product_id
join lateral flatten (input => crv.data:image_list) as il
left join instadata.rds_data.product_images         as pi on true
    and pi.file = il.value:image_id
    and il.value:source_type != 'Product::Datum::RetailerFile'
    and pi.angle = '4'
where true
    and pfnd.retailer_id = 308
    and pfnd.surface_id = 1
    and pfnd.created_at > current_date
    and parse_json(prfd.raw):remote_image_url ilike '%bristolfarms%'
    and crv.sources:image_hero_large_url:source_type = 'Product::Datum::RetailerFile'
group by all;



-- This query shows the details of cost_unit flipping issue comparing data from old file vs today's file
select 
    distinct 
    DATE(pfnd.created_at) date,
    csv_file_id
    ,pfnd.data:retailer_reference_code::text file_rrc
    ,pfnd.data:lookup_code::text file_upc
    ,p.product_id
    ,pfnd.data:available::text available
    ,crpv.data:display_name::text display_name
    , crpv.data:image_hero_large_url::text rp_image
    ,pfnd.data:remote_image_url::text file_image
    ,pfnd.data:name::text file_item_name
    ,listagg(distinct pfnd.data:cost_unit::text, ' ,') file_cost_unit
from 
    catalog.catalog.current_retailer_product_view crpv
    join 
        catalog.tmp.new_seasons_cost_unit_change p
        on p.product_id = crpv.product_id
        and p.retailer_id = crpv.retailer_id
    join 
        catalog.catalog.retailer_code_products rcp
        on rcp.product_id = p.product_id
        and rcp.retailer_id = p.retailer_id
    join 
        catalog.catalog.partner_file_normalized_data pfnd
        on true
        and pfnd.lead_code=rcp.code and rcp.retailer_id=pfnd.retailer_id
        --and pfnd.created_at > current_date -1 
        and csv_file_id in (156832317,161649862)
        -- 156959103
group by 
    1,2,3,4,5,6,7,8,9,10
order by 
    product_id desc, csv_file_id desc, date desc;




-- this query will show the list of all items which were hidden and the patches were applied
    select
    distinct crpv.product_id
    ,crpv.retailer_id
    ,civ.item_id
    ,civ.data:patch_ids patch_id
    ,ciev.data:cost_unit::text cost_unit
    ,civ.data:visible::text visible
    ,ciev.data:available
    ,crpv.data:normalized_brand_name::STRING brand_name
    ,crpv.data:display_name::STRING IC_product_name
    from catalog.catalog.current_temporary_override_elastic_item_view civ
    join catalog.catalog.current_retailer_product_view crpv on crpv.product_id = civ.product_id and crpv.retailer_id = civ.retailer_id
    join catalog.catalog.current_elastic_item_view ciev on ciev.item_id=civ.item_id and ciev.product_id = crpv.product_id and ciev.retailer_id = crpv.retailer_id and ciev.retailer_id = civ.retailer_id
    -- left join catalog.catalog.partner_file_normalized_data pfnd on pfnd.retailer_id = crpv.retailer_id and pfnd.retailer_id = ciev.retailer_id and civ.retailer_id = pfnd.retailer_id and pfnd.data:retailer_reference_code=ciev.data:retailer_reference_code
    where 
    civ.data:patch_ids ILIKE ANY ('%3023%', '%2996%', '%2997%', '%2923%', '%2925%')
    qualify row_number () over (partition by ciev.item_id order by ciev.id desc) = 1   
    -- and pfnd.csv_file_id = '161649862'
    ORDER BY product_id asc, patch_id asc
    ;



