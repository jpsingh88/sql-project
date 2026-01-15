with dataset as (
    select 
        crv.retailer_id,
        crv.product_id,
        wl.location_code,
        crv.data:display_name::string as display_name,
        ceiv.item_id,
        cs.retailer_reference_code_raw,
        cs.lookup_code_normalized,
        crv.data:department_name::string as department_name, 
        crv.data:product_category.product_category::string AS Product_Category,
        ceiv.data:visible::boolean   as item_visible,
        ceiv.data:available::boolean as item_available,
        iff (crv.data:image_hero_primary_url is not null, 'true','false')::boolean as has_image
    from instadata.rds_data.product_retailer_file_data prfd
    join instadata.rds_data.product_sources ps on true
        and ps.source_id = prfd.id
        and ps.deleted_at is null
        and prfd.deleted_at is null
        and ps.source_type = 'Product::Datum::RetailerFile'
    join instadata.rds_data.pi_code_set_groups csg on true 
        and csg.id = prfd.pi_code_set_group_id
        and csg.deleted_at is null
    join instadata.rds_data.pi_code_sets cs on true
        and cs.code_set_group_id = csg.id
        and cs.deleted_at is null
        and cs.bad_at is null
    join catalog.catalog.current_retailer_product_view crv on true
        and crv.product_id = ps.product_id
        and crv.retailer_id = prfd.retailer_id
    join instadata.rds_data.retailer_products rp on true
        and rp.retailer_id = crv.retailer_id
        and rp.product_id = crv.product_id
    join catalog.catalog.current_elastic_item_view ceiv on true
        and rp.retailer_id = ceiv.retailer_id
        and rp.product_id = ceiv.product_id
    join instadata.rds_data.warehouse_locations wl on true
        and wl.warehouse_id = rp.retailer_id
        and wl.active = 'true'
        and wl.inventory_area_id = ceiv.inventory_area_id
    where prfd.retailer_id = 505
    qualify row_number () over (partition by ceiv.item_id order by ceiv.id desc) = 1
)
select distinct 
    retailer_id,
    product_id,
    display_name,
    department_name, 
    Product_Category,
    array_agg (distinct retailer_reference_code_raw) as rrcs,
    array_agg (distinct lookup_code_normalized)      as lookup_codes
from dataset
where true
    and not has_image
    and item_visible
    and item_available
group by 1,2,3,4,5
order by 1,3