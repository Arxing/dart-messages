import 'dart:convert';

import 'package:xson/xson.dart';

class MessagesMapper {
  static const String _KEY_MESSAGE = "message";
  static const String _KEY_ROUTES = "routes";
  static const String _KEY_REMARK = "remark";

  static final MessagesMapper _instance = MessagesMapper._();

  MessagesMapper._();

  static MessagesMapper getInstance() => _instance;

  MessagesRouteData _currentRouteData;

  MessagesRouteData get currentRouteData => _currentRouteData;

  bool get isLoaded => currentRouteData != null;

  MessagesRouteData load(JsonElement jsonElement) {
    _currentRouteData = _resolve(null, jsonElement, null);
    return _currentRouteData;
  }

  MessagesRouteData loadAsString(String json) {
    return load(JsonElement.fromJsonString(json));
  }

  MessagesRouteData _resolve(String key, JsonElement json, MessagesRouteData parent) {
    if (json.isNull) {
      return null;
    } else if (json.isObject) {
      JsonObject object = json.asObject;

      var data = MessagesRouteData._(
        message: object.has(_KEY_MESSAGE) && !object[_KEY_MESSAGE].isNull ? object[_KEY_MESSAGE].asString : null,
        remark: object.has(_KEY_REMARK) && !object[_KEY_REMARK].isNull ? object[_KEY_REMARK].asString : null,
      );
      data._parent = parent;
      data._routes = Map.fromEntries(object[_KEY_ROUTES]?.asObject?.entries?.map((entry) {
            String key = _parseKey(entry.key);
            JsonElement value = entry.value;
            return MapEntry(key, _resolve(key, value, data));
          }) ??
          []);
      return data;
    } else if (json.isPrimitive) {
      return MessagesRouteData._(message: json.asString);
    } else {
      throw "Illegal state! key=$key json=$json";
    }
  }
}

String _parseKey(String s) => s.replaceAll(r"$", "");

class MessagesRouteData {
  final String message;
  final String remark;
  Map<String, MessagesRouteData> _routes;
  MessagesRouteData _parent;

  Map<String, MessagesRouteData> get routes => _routes;

  MessagesRouteData get parent => _parent;

  MessagesRouteData._({
    this.message,
    this.remark,
  });

  MessagesRouteData operator [](String routeString) {
    List<String> routingTraces = routeString.split(".");
    MessagesRouteData find = this;
    for (var routingTrace in routingTraces) {
      routingTrace = _parseKey(routingTrace);

      bool exist = find.routes == null ? false : (find.routes.containsKey(routingTrace) && find.routes[routingTrace] != null);
      if (exist) {
        find = find.routes[routingTrace];
      } else {
        while (find != null && find.message == null) {
          find = find.parent;
        }
        break;
      }
    }
    return find;
  }

  MessagesRouteData find(String routeString) => this[routeString];

  @override
  String toString() {
    return JsonElement.fromJsonString(jsonEncode(this)).toJsonString(prettify: true);
  }

  Map toJson() {
    var map = {};
    if (remark != null) map["remark"] = remark;
    if (message != null) map["message"] = message;
    if (routes != null && routes.isNotEmpty) map["routes"] = routes;
    return map;
  }
}