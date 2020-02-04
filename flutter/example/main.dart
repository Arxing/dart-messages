import 'package:messages_flutter/messages_flutter.dart';

void main() {
  // toast showing
  showToast("Hello World");
  showToastMessagesString("Hello World");
  showToastMessagesError("An Error");
  showToastMessagingRouting(100, 5000);

  // messages extension
  Messages messages = StringMessages("Hello World");
  messages.showToast();

  // list extension for routing
  RoutingMessages routingMessages = [100, 5000].toRoutingMessages();
  [100, 5000].showToast();
  var message = [100, 5000].routingMessage;
  message = ["login", "buttons", "accountHint"].routingMessage;

  // default error handler
  Future.sync(() {
    throw 100;
  }).catchErrorDefault().then((_) {
    throw [100, 5000].toRoutingMessages();
  }).catchErrorDefault();
}
