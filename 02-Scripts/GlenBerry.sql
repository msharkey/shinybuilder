

 DECLARE @ts_now bigint = (SELECT cpu_ticks/(cpu_ticks/ms_ticks) FROM sys.dm_os_sys_info WITH (NOLOCK)); 
   
  SELECT TOP(256)   DATEADD(ms, -1 * (@ts_now - [timestamp]), GETDATE()) AS [Event_Time] ,
                 100 - SystemIdle AS [CPU_Utilization]
  FROM (SELECT record.value('(./Record/@id)[1]', 'int') AS record_id, 
              record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int') 
              AS [SystemIdle], 
              record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 'int') 
              AS [SQLProcessUtilization], [timestamp] 
        FROM (SELECT [timestamp], CONVERT(xml, record) AS [record] 
              FROM sys.dm_os_ring_buffers WITH (NOLOCK)
              WHERE ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR' 
              AND record LIKE N'%<SystemHealth>%') AS x) AS y 
  ORDER BY record_id DESC OPTION (RECOMPILE);