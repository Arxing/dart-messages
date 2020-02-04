import 'dart:convert';

import 'package:messages_dart/messages_dart.dart';
import 'package:xson/xson.dart';

var msg = {
  "message": "This is a default message",
  "routes": {
    "100": {
      "remark": "remark",
      "message": "Hello World!",
      "routes": {"5000": "Apple is red", "6000": "Banana is yellow"}
    },
    "101": "Goodnight",
    "102": "Yes, I do!",
    "home": {"remark": "home page", "message": "Okay~"},
    "login": {
      "message": "What the hell?",
      "routes": {
        "buttons": {
          "routes": {
            "accountHint": "Please input account",
            "passwordHint": {"message": "Please input password"}
          }
        }
      }
    }
  }
};

var xml = """
<fuck>
  <ok></ok>
</fuck>
""";

main() async {
  MessagesMapper.getInstance().loadAsString(jsonEncode(msg));

  setDefaultMessagesHandler((Messages messages) {
    print("Custom Handle message: ${messages.showMessage}");
  });
  setDefaultMessagesTransformer((error, [stack]) {
    if (error is int) return StringMessages("int: $error");
    return StringMessages(error?.toString());
  });

  Future.sync(() {
    // do something
    throw RoutingMessages.of(100, 5000);
  }).catchError(defaultErrorHandler).then((_) {
    throw 100;
  }).catchError(defaultErrorHandler).then((_){
    throw "An Error~";
  }).catchError(defaultErrorHandler);
}
