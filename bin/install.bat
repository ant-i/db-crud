call cpanp install DBD::SQLite
call cpanp install Log::Any
call cpanp install Log::Any::Adapter
call cpanp install Mojolicious
call cpanp install Rose::DB
call cpanp install Rose::DB::Object
call cpanp install Rose::DB::Object::Manager
call cpanp install Rose::DB::Object::Loader

echo "You must manually install following modules:
	- DBD::Pg
	- DBD::Oracle
	- DBD::MySQL

as they might need additional configuration or arguments before installation
"