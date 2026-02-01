select table_schema, table_name
from information_schema.tables
where table_schema = 'founder' and table_name = 'founders';
