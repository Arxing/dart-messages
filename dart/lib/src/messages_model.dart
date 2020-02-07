import 'dart:convert';
import 'package:messages_dart/messages_dart.dart';

abstract class Messages {
  dynamic extras;

  String get debugMessage;

  String get message;

  @override
  String toString() {
    var map = {
      'showMessage': message,
    };
    if (debugMessage != null) map['debug'] = debugMessage;
    if (extras != null) map['extras'] = extras;
    return JsonEncoder.withIndent('  ').convert(map);
  }
}

class StringMessages extends Messages {
  final String debugMessage;
  final String message;

  StringMessages(this.message, [this.debugMessage]);
}

class ErrorMessages extends Messages {
  final String errorMessage;
  final StackTrace stackTrace;

  ErrorMessages.of(this.errorMessage, [this.stackTrace]);

  String get message => errorMessage;

  String get debugMessage => "ERROR:$errorMessage\nSTACK_TRACE:$stackTrace";
}

class RoutingMessages extends Messages {
  final List<String> routes;

  String debugMessage;

  RoutingMessages.create(List<dynamic> routes) : routes = routes.map((route) => route?.toString()).toList();

  RoutingMessages.of(
    dynamic route1, [
    dynamic route2,
    dynamic route3,
    dynamic route4,
    dynamic route5,
    dynamic route6,
    dynamic route7,
    dynamic route8,
    dynamic route9,
  ]) : this.create(
          [
            route1,
            route2,
            route3,
            route4,
            route5,
            route6,
            route7,
            route8,
            route9,
          ].where((route) => route != null).toList(),
        );

  String get message {
    var mapper = MessagesMapper.getInstance();
    if (mapper.isLoaded) {
      var key = routes.join(".");
      return mapper.currentRouteData[key]?.message;
    } else {
      print("[WARING]: ErrorMapper is not loaded.");
    }
    return null;
  }

  String get remark {
    var mapper = MessagesMapper.getInstance();
    if (mapper.isLoaded) {
      var key = routes.join(".");
      return mapper.currentRouteData[key]?.remark;
    } else {
      print("[WARING]: ErrorMapper is not loaded.");
    }
    return null;
  }
}
