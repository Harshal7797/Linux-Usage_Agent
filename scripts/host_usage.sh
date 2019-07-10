#!/bin/bash

#setup argument

psql_host=$1
port=$2
db_name=$3
user_name=$4
password=$5

get_cpu_idel(){
	cpu_idel=$(sar -u  | head -5 | tail -1 | awk '{print $8}'| xargs)
	echo "cpu_idel(%) =$cpu_idel"
}
get_cpu_kernel(){
	cpu_kernel=$(sar -u | head -5 | tail -1 | awk '{print $5}' | xargs)
	echo "Cpu_kernel(%)=$cpu_kernel"
}
get_host_id(){
 while read p
 do
 echo $p
 done < ~/host_id
}
get_disk_available(){
	disk_available=$(df /home -BM | tail -1 | awk '{print $4}'| xargs | sed s'/M//')
}
get_disk_io(){
	disk_io=$(vmstat -d | tail -1 | awk '{print $10}' | xargs)
	echo "disk_io=$disk_io"
}

#Step 1: Parse data and setup variable 
get_cpu_idel 
get_cpu_kernel
get_disk_io
get_disk_available
host_id=$(get_host_id)
echo "host_id=$host_id"
timestamp=$(date "+%Y-%m-%d %T")
mem_free=$(vmstat --unit M | tail -1 | awk '{print $4}')

echo "timestamp=$timestamp"
echo "mem_free=$mem_free"

#step 2: Contruct insert statement
insert_stmt=$(cat << END
INSERT INTO host_usage("timestamp", host_id, memory_free, cpu_idel, cpu_kernel, disk_io, disk_available) VALUES ('${timestamp}',${host_id},${mem_free},${cpu_idel},${cpu_kernel},${disk_io},${disk_available});
END
)
echo $insert_stmt

#step 3: Execute INSERT statement
export PGPASSWORD=$password
psql -h $psql_host -p $port -U $user_name -d $db_name -c "$insert_stmt"
sleep 1
