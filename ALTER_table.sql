
create table alter_table_test( 
id int,
name varchar(5) NOT NULL
DOJ date NULL
test text constraint test_const check (test in ('Hie there', 'hI NOT HTERE', 'LOL'))
)

/* rename table name  */

alter table alter_table_test rename to testt

/* rename column */

alter table testt rename column id  to id_s

/* to add new column */

alter table testt add add_col int default 5

/* drop colum */

alter table testt drop column add_col
alter table testt drop add_col --both syntax work

/* Modify data types of column */

alter table testt alter column name set data type varchar(3)
alter table testt alter column name type varchar(7)   -- SET DATA cluse is optional
alter table testt alter name type varchar(6)  -- COLUMN word is also optional

--In oracle ALTER TABLE testts MODIFY COLUMN 

/* Add or Remove contrainsts */

alter table testt add constraint id_s_pk primary key (id_s)

alter table testt drop constraint id_s_pk


alter table testt add foreign key (id_s) references employees(emp_no)

alter table testt drop constraint testt_id_s_fkey

-- When you specify ADD CONSTAINT you must provide contraint name

-- CONTRAINT_NAME will be automatically created wheather or not you specify. To get to know constrait name and use it to drop, use 'PSQL' and use '\d <table name>' to descriobe table it will show contraint name


/* To drop NOT NULL or NULL */

alter table testt alter column name drop not null 
alter table testt alter column DOJ set NOT NULL

-- for NULL, NOT NULLL : use ALTER TABLE <table name> ALTER COLUM <column name> clause

alter table testt alter column id_s set default 6

alter table testt alter column id_s drop default

