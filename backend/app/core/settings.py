from pydantic import BaseSettings

class Settings(BaseSettings):
    ssl_on: bool = False
    ssl_keyfile: str = ''
    ssl_certfile: str = ''

    api_hostname: str = "localhost"
    api_port: int = 9999
    version: str = "0.0.0"
    project_name: str = "CRM HACK"
    fast_api_description: str = ''

    class Config:
        case_sensitive = False
        env_file = '.env'
        env_file_encoding = 'utf-8'
