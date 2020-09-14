/* EMPLOYEE DATABASE */

create user employer with password '*******';

create database EMPLOYEE owner employer;

grant connect on database employee to employer;

grant all privileges on database employee to employer;

psql -U employer -d employee< C:\git\PostgreSQL\Employee_db_sql_files\create_tables.sql