select
(physical_memory_in_use_kb/1024)Phy_Memory_usedby_Sqlserver_MB,
(locked_page_allocations_kb/1024 )Locked_pages_used_Sqlserver_MB,
(virtual_address_space_committed_kb/1024 )Total_Memory_UsedBySQLServer_MB,
process_physical_memory_low,
process_virtual_memory_low
from sys. dm_os_process_memory

SELECT object_name, counter_name, cntr_value AS 'Total Server Memory (KB)'
FROM sys.dm_os_performance_counters 
WHERE counter_name = 'Total Server Memory (KB)'

 -- SQL memory
   SELECT 
      sqlserver_start_time  as strtSQL,
      (committed_kb/1024) as currmem,
       (committed_target_kb/1024)           as smaxmem
   FROM sys.dm_os_sys_info;
   
   --OS memory
   SELECT 
      (total_physical_memory_kb/1024) as osmaxmm ,
       (available_physical_memory_kb/1024) as osavlmm 
   FROM sys.dm_os_sys_memory;