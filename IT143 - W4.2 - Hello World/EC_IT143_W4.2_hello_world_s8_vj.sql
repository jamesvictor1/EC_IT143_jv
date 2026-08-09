EXEC dbo.usp_hello_world_load;

-- Verify the result:
SELECT t.*
  FROM dbo.t_hello_world AS t;