import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'sql.dart';

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..get('/echo/<message>', _echoHandler)
  ..post('/create_db', _createDb);

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

Future<Response> _createDb(Request request) async {
  DataB dataB = DataB();
  await dataB.createTables();
  return Response.ok('Database Created!');
}


Future<Response> _echoHandler(Request request) async {
  dynamic message = request.params['message'];
  DataB dataB = DataB();

  print(message.runtimeType);
  dynamic info = await dataB.bd(usetId: int.parse(message!));
  for (var i in info) {
    print(i);
  }
  return Response.ok('$info\n');
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
