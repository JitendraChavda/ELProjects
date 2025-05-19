import psycopg2

hostname = "localhost"
database = "sales"
username = "postgres"
password ="Lord@9898"
port_id = 5432
conn = None
cur = None

try:
    conn = psycopg2.connect(
        host=hostname,
        user =username,
        password =password,
        dbname = database,
        port = port_id)
    
    cur = conn.cursor()
    




except Exception as error:
    print("Have some issues recheck your query")

finally:
    if cur is not None:
        cur.close()
    if cur is not None:
        conn.close()