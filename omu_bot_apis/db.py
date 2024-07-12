from mysql.connector import connect, Error
from config import Config

def get_db_connection():
    try:
        db = connect(
            host=Config.MYSQL_HOST,
            user=Config.MYSQL_USER,
            password=Config.MYSQL_PASSWORD,
            database=Config.MYSQL_DB
        )
        print("Connected to MySQL database")
        return db
    except Error as e:
        print(f"Error connecting to MySQL database: {e}")
        return None
