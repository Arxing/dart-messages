import 'package:messages_dart/messages_dart.dart';

typedef ErrorHandler = void Function(dynamic, [StackTrace]);

typedef MessagesTransformer = Messages Function(dynamic, [StackTrace]);

typedef MessagesHandler = void Function(Messages messages);

MessagesHandler _defaultMessagesHandler = (messages) {
  print("========== MESSAGES HANDLER ==========");
  print("${messages.toString()}");
  print("======================================");
  print("");
};

MessagesTransformer _defaultMessagesTransformer = (e, [stack]) => ErrorMessages.of(e?.toString(), stack);

ErrorHandler get defaultErrorHandler => (e, [stack]) {
      Messages messages;
      if (e is Messages) {
        messages = e;
      } else if (e is String) {
        messages = StringMessages(e);
      } else {
        messages = _defaultMessagesTransformer(e, stack);
      }
      if (_defaultMessagesHandler != null) _defaultMessagesHandler(messages);
    };

void setDefaultMessagesHandler(MessagesHandler handler) => _defaultMessagesHandler = handler;

void setDefaultMessagesTransformer(MessagesTransformer transformer) => _defaultMessagesTransformer = transformer;
