import 'package:messages_dart/messages_dart.dart';
import 'package:fluttertoast/fluttertoast.dart';

extension FlutterMessagesExtension on Messages {
  void showToast() => Fluttertoast.showToast(msg: this.showMessage);
}

extension FlutterRoutingExtension on List {
  void showToast() => this.toRoutingMessages().showToast();
}

Future<bool> showToast(String message) => Fluttertoast.showToast(msg: message);

Future<bool> showToastMessages(Messages e) async {
  if (e?.showMessage != null) return showToast(e.showMessage);
  return false;
}

Future<bool> showToastMessagesString(String message, [String debugMessage]) =>
    showToastMessages(StringMessages(message, debugMessage));

Future<bool> showToastMessagesError(String errorMessage, [StackTrace stackTrace]) =>
    showToastMessages(ErrorMessages.of(errorMessage, stackTrace));

Future<bool> showToastMessagingRouting([
  dynamic routing1,
  dynamic routing2,
  dynamic routing3,
  dynamic routing4,
  dynamic routing5,
  dynamic routing6,
  dynamic routing7,
  dynamic routing8,
  dynamic routing9,
]) {
  return showToastMessages(RoutingMessages.of(
    routing1,
    routing2,
    routing3,
    routing4,
    routing5,
    routing6,
    routing7,
    routing8,
    routing9,
  ));
}
