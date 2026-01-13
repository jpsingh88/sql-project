select * from catalog.tmp.tmp_grocery_catalog_audit_data_1217
where avail_items > 0
and (array_size (lead_codes) >1 or array_size (scan_codes)!= array_size(pfnd_lookup_codes))
order by 1,2,7