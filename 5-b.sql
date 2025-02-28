-----------Q1-----------
select 
    param_level.int_value AS level, 
    COUNTIF(param_result.string_value = 'win') * 100.0 / count(*) as win_rate
from nexar_dataset.event_params param_level
join nexar_dataset.event_params param_result on param_level.event_id = param_result.event_id
where param_level.param_key = 'level' 
and param_result.param_key = 'result'
and param_level.int_value in (1, 5, 10)  
group by param_level.int_value
order by param_level.int_value;

--------Q2------------
select 
    sum(case when e.event_name = 'use_skill' then 1 else 0 end) * 1.0 / 
    nullif(sum(case when e.event_name = 'level_start' then 1 else 0 end), 0) AS use_skill_per_game_in_brazil
from nexar_dataset.event_params as ep
join nexar_dataset.geo_location as gl on ep.event_id = gl.event_id
join nexar_dataset.events as e on ep.event_id = e.event_id
where gl.country = 'Brazil';




-------------Q3----------

select 
    ep.int_value as level,
    count(distinct e.user_id) as user_count,
    lag(count(distinct e.user_id)) over (order by ep.int_value) as user_in_after_level,
    COUNT(distinct e.user_id) * 1.0 / nullif(lag(count(distinct e.user_id)) over (order by ep.int_value), 0) AS retention_rate
from nexar_dataset.event_params as ep
join nexar_dataset.events as e on ep.event_id = e.event_id
where e.event_name = 'level_start' 
and ep.param_key = 'level'
group by ep.int_value
order by ep.int_value;