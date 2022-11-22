import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_swagger_ui/shelf_swagger_ui.dart';

import 'sql.dart';

// Handler swaggerHandler() {
//   final swagger = SwaggerUI(
//     'swagger.yaml',
//     title: 'Swagger Test',
//   );
//   return swagger;
// }

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..get('/echo/<message>', _echoHandler)
  // ..get('/doc', _doc)
  ..post('/create_db', _createDb);

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

// FutureOr<Response> _doc(Request req) {
//   final swagger = SwaggerUI(
//     'specs/swagger.yaml',
//     title: 'Swagger Test',
//   );
//   return swagger.call(req);
// }

Future<Response> _createDb(Request request) async {
  DataB dataB = DataB();
  await dataB.createTables();
  return Response.ok(jsonEncode(
      {'status': true, 'message': 'Database Created!'}));
}

Future<Response> _echoHandler(Request request) async {
  dynamic message = request.params['message'];
  DataB dataB = DataB();

  print(message.runtimeType);
  dynamic info = await dataB.bd(usetId: int.parse(message!));
  for (var i in info) {
    print(i);
  }
  return Response.ok(jsonEncode({'status': true, 'data': 123}));
}

void main(List<String> args) async {
  // final path = 'specs/swagger.yaml';
  // final handler = swaggerHandler();
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
