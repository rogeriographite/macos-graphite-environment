create database Graphite;
create user apache@localhost;
use Graphite;
grant all privileges on Graphite.* to apache@localhost;