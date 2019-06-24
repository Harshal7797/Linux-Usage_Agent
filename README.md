# Introduction 
Cluster Monitor Agent is an internal tool that monitors the cluster resources of Linux computers or nodes that work together and can be viewed and managed as a single system. Nodes may be physical or virtual machines, and they may be separated geographically. Organization use Linux cluster to reduce downtime and  provide high availability of the services.  A server cluster is a group of linked servers that work together to improve system performance and service availability. For example if a one server fails, other server in the cluster can take over the function and workload of the failed server.

# Architecture and Design 

###  1) Cluster Diagram with three Linux hosts, a DB and agents.

![Untitled Diagram](https://user-images.githubusercontent.com/51926543/60039423-af281580-9684-11e9-9e1b-0ddf3b498d69.jpg)

### 2. PSQL Tables 
For this project there will be two table created which are host_info which will contain host hardware information and host_usage table will contain information regarding CPU and memory usage data which will be inserted into database evey minute using the crontab job.
#####  2.1 host_info table
This table will contain hostname, cpu_number, cpu_architecture, cpu_model, cu_mhz, l2_cache, "timestamp", total_mem from each node that is connected to the cluster. Each node is identified by its id which will be auto incremented by the database. 
##### 2.2 host_usage table
This table will contain "time stamp", host_id , memory_free, cpu_idel, cpu_kernel, disk_io, disk_available. This will run on each server and every minute it will collected the CPU usage information and will be inserted into the database.
### 3. Scripts
 Agent program has been created to gather and inset into database tables. The agent will be installed on every host.server/node. The host agent consist of two bash scripts. 
#####  3.1 `host_info.sh`
This script has been created to collect the host hardware information and insert it into the database. It will only run once.
#####  3.2 `host_usage.sh`
This scripts collects current host usage CPU and memory then insert this information into database. This script will be truggered by crontab job every minute. 
# Usage
1)  How to inti databse and tables ?
To initialize a database in PSQL we use the command `CREATE DATABASE db_name;`. To create table we use `CREATE TABLE table_name (.......);` 
###### NOTE:  Inside the parenthesis we defines the variable type and what information it will hold.
2) `host_info.sh`  
To run this script pass in the following command but before make sure the file is executable.
`bash host_info.sh psql_host psql_port db_name psql_password`
For example:
`bash host_info.sh localhost 5432 host_agent postgres password`

3) `host_usahe.sh`
To execute this script pass int the following command.
`bash host_usage.sh psql_host psql_port db_name psql_password`
For example:
`bash host_usage.sh localhost 5432 host_agent postgres password`

4) crontab
To create a crontab  type this command into the shell `crontab -e` and now copy paste your executable statement that can generated using the tool available online. 
For example `* * * * *  bash /home/centos/dev/jrvs/bootcamp/host_agent/scripts/host_usage.sh localhost 5432 host_agent postgres password  >> /tmp/host_usage.log`

# Improvement

1) Handle Hardware Update 
2) Show Visual data of CPU usage like Windows Task Manager.
3) Automatically give more resources to the application that need it temporary.
4) Alert the user if one or more node fails.
