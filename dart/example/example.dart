import 'dart:convert';

import 'package:messages_dart/messages_dart.dart';
import 'package:xson/xson.dart';

var routingConfig = {
  "message": "This is a default message",
  "routes": {
    "100": {
      "remark": "remark",
      "message": "Hello World!",
      "routes": {
        "5000": "Apple is red",
        "6000": "Banana is yellow",
      }
    },
    "101": "Goodnight",
    "102": "Yes, I do!",
    "home": {
      "remark": "home page",
      "message": "Okay~",
    },
    "login": {
      "message": "What the hell?",
      "routes": {
        "buttons": {
          "routes": {
            "accountHint": "Please input account",
            "passwordHint": {
              "message": "Please input password",
            }
          }
        }
      }
    }
  }
};

main() async {
  /// load routing config
  /// you can use format json, yaml, xml or properties to load just converting to json
  var routingConfigJson = jsonEncode(routingConfig);
  // if load by string, string's format must be json
  MessagesPlugin.loadAsString(routingConfigJson);

  /// set messages display delegate
  /// ex:
  ///   print()
  ///   showToast()
  MessagesPlugin.setDelegate((m) async {
    print(m);
    return true;
  });

  /// create messages instance
  var m1 = StringMessages("Some message");
  try {} catch (error, stack) {
    var m2 = ErrorMessages.of(error, stack);
  }
  var m3 = RoutingMessages.of(100, 5000);
  var m3Equals = RoutingMessages.create([100, 5000]);
  var m4 = RoutingMessages.of("login", "buttons", "accountHint");
  var m4Equals = RoutingMessages.create(["login", "buttons", "accountHint"])..extras = "Extras Data";
  var m5 = [100, 5000].toRoutingMessages();

  /// messages members
  m3.message; // display message
  m4Equals.extras; // user extras data
  m4Equals.remark; // message remark in routing config
  [100, 5000].routingMessage; // list extension

  /// display message
  MessagesPlugin.display("message");
  MessagesPlugin.displayRouting(100, 5000);
  MessagesPlugin.displayString("mesage");
  m3.display();
  m4.display();
  [100, 5000].display(); // list extension

  /// error handling with messages
  MessagesPlugin.setErrorHandler((message) => message.display());
  MessagesPlugin.setErrorTransformer((error, [stack]) {
    if (error is CustomError) return StringMessages("A custom error");
    return StringMessages("Unhandled error");
  });
  Future.sync(() {
    // do something
    // throw a messages error
    throw [100, 5000].toRoutingMessages(); // list extension
  })
      .catchError((error, stack) {
        // catch the messages error and print target of routing message
        if (error is Messages) print("[Error] ${error.message}");
      })
      .then((_) {
        // do something
        // throw a messages error
        throw RoutingMessages.of(100, 5000);
      })
      .catchErrorDefault() // future extension, catching and handling error by messages error handler
      .then((_) {
        // do something
        // throw a not messages error, error transformer will convert it to messages
        throw CustomError();
      })
      .catchError(MessagesPlugin.errorHandler);
}

class CustomError {}
