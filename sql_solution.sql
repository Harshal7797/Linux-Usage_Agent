SELECT cpu_number, id AS host_id, total_mem from host_info ORDER BY cpu_number, total_mem DESC;
SELECT  x.hostid,
	x.hostname,
	(x.total_mem / 1000) AS total_memory,
	avg(used_memory) over(partition by interval) AS used_memory_percentage
FROM
	(SELECT u.host_id AS hostid, 
		i.hostname AS hostname, 
		i.total_mem, (i.total_mem - (u.memory_free * 1000)) * 100 / (i.total_mem) AS used_memory,
		date_trunc('minute',u."timestamp") + interval '600 second'  AS interval
		FROM host_usage AS u INNER JOIN host_info AS i ON u.host_id = i.id 
	)AS x
;
