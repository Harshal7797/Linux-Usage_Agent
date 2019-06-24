CREATE TABLE PUBLIC.host_info
(
id SERIAL NOT NULL, 
hostname varchar NOT NULL,
cpu_number INT2 NOT NULL,
cpu_architecture VARCHAR NOT NULL,
cpu_model VARCHAR NOT NULL, 
cpu_mhz FLOAT8 NOT NULL,
l2_cache INT4 NOT NULL,
"timestamp" TIMESTAMP NOT NULL,
total_mem INT4 NULL,
CONSTRAINT HOST_INFO_PK primary key (id),
CONSTRAINT host_info_un UNIQUE(hostname)
);

CREATE TABLE PUBLIC.host_usage 
(
"timestamp" TIMESTAMP NOT NULL,
host_id SERIAL NOT NULL,
memory_free INT4 NOT NULL,
cpu_idel INT2 NOT NULL,
cpu_kernel INT2 NOT NULL, 
disk_io INT4 NOT NULL, 
disk_available INT4 NOT NULL,
CONSTRAINT host_usage_host_info_fk FOREIGN KEY(host_id) REFERENCES host_info(id)
);

