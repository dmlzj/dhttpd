import 'dart:async';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';

import 'src/options.dart';

class Dhttpd {
  HttpServer server;
  String path;

  Dhttpd();

  Dhttpd._(this.server, this.path);

  String get host => server.address.host;

  int get port => server.port;

  String get urlBase => 'http://$host:$port/';

  Future<Dhttpd> start(
      {String path, int port = defaultPort, address = defaultHost, String defaultDocument = 'index.html'}) async {
    path ??= Directory.current.path;

    final pipeline = const Pipeline()
        .addMiddleware(logRequests())
        .addHandler(createStaticHandler(path, defaultDocument: defaultDocument));

    server = await io.serve(pipeline, address, port);
    // _server.close();
    return Dhttpd._(server, path);
  }

  Future destroy() => server.close();
}
