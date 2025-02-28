----Sau khi load các file data lên BigQuery và lưu trong nexar_dataset.raw_data---

--------------Users---------
create table users as (
select distinct 
    user_id 
from nexar_dataset.user_id

------------event-------------
create table nexar_dataset.events as
select distinct
    event_id,
    user_id,
    event_name,
    event_timestamp,
    PARSE_DATE('%Y%m%d', CAST(event_date as string)) as event_date  
from nexar_dataset.raw_data;


---------------Geo_Location------------
create table nexar_dataset.geo_location as
select distinct
    GENERATE_UUID() AS geo_id,
    event_id, 
    geo.city,
    geo.country,
    geo.continent,
    geo.region,
    geo.sub_continent,
    geo.metro
FROM nexar_dataset.raw_data;

-------------event_params----------
create table nexar_dataset.event_params as
select
    GENERATE_UUID() as param_id,  
    e.event_id, 
    param.key as param_key,
    param.value.int_value as int_value,  
    param.value.string_value as string_value  
from nexar_dataset.raw_data r
cross join UNNEST(r.event_params) as param 
join nexar_dataset.events e 
on r.event_id = e.event_id;  



