import 'dart:io';

Future<void> main() async {
  HttpServer server = await createHttpServer();

  runHttpRequest(server);
}

Future<void> runHttpRequest(HttpServer server) async {
  await for (HttpRequest request in server) {
    if (request.method == 'GET') {
      request.response
        ..write('{ "data": [{"title":"Jan"}] }')
        ..close();
    }
  }
}

Future<HttpServer> createHttpServer() async {
  const port = 8080;

  return HttpServer.bind(InternetAddress.anyIPv4, port);
}
