from dotenv import load_dotenv, find_dotenv
from app import app as application
load_dotenv(find_dotenv())

if __name__ == '__main__':
    application.run()