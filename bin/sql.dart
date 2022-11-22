import 'package:postgres/postgres.dart';

class DataB {
  PostgreSQLConnection connection = PostgreSQLConnection(
      "localhost", 5432, "bot_trade_place",
      username: "postgres", password: "102015");

  Future<dynamic> createTables() async {
    await connection.open();
    await connection.query('''CREATE TABLE IF NOT EXISTS users (
     id SERIAL PRIMARY KEY,
     username TEXT UNIQUE,
     password TEXT DEFAULT '0',
     first_name TEXT DEFAULT '0',
     last_name TEXT DEFAULT '0',
     language TEXT DEFAULT '0',
     push_token TEXT DEFAULT '0',
     status INTEGER DEFAULT 0,
     last_active timestamp',
     registrate_date timestamp'
     )''');
    await connection.query('''CREATE TABLE IF NOT EXISTS auth (
     id SERIAL PRIMARY KEY,
     user_id INTEGER DEFAULT 0,
     access_token TEXT DEFAULT '0',
     refresh_token TEXT DEFAULT '0',
     create_date timestamp)''');
    await connection.query('''CREATE TABLE IF NOT EXISTS chat (
     id SERIAL PRIMARY KEY,
     owner_id INTEGER DEFAULT 0,
     name TEXT DEFAULT '0',
     numb_users INTEGER DEFAULT 1,
     create_date timestamp)''');
    await connection.query('''CREATE TABLE IF NOT EXISTS users_in_chat (
     id SERIAL PRIMARY KEY,
     chat_id INTEGER DEFAULT 0,
     user_id INTEGER DEFAULT 0,
     connect_date timestamp)''');
    await connection.query('''CREATE TABLE IF NOT EXISTS message (
     id SERIAL PRIMARY KEY,
     from_user INTEGER DEFAULT 0,
     to_user INTEGER DEFAULT 0,
     chat_id INTEGER DEFAULT 0,
     text TEXT DEFAULT 0,
     status TEXT DEFAULT 'create',
     create_date timestamp')''');
    return "ok";
  }

  Future<dynamic> bd({required int usetId}) async {
    await connection.open();
    List<List<dynamic>> results = await connection.query(
        "SELECT * FROM all_users WHERE id = @usetId",
        substitutionValues: {"usetId": usetId});
    await connection.close();
    return results;
  }
}
