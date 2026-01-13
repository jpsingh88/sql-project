select  
    crv.product_id,
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
group by all
