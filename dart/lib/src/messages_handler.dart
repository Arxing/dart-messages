part of 'messages_plugin.dart';

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

ErrorHandler get _defaultErrorHandler => (e, [stack]) {
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

void _setErrorHandler(MessagesHandler handler) => _defaultMessagesHandler = handler;

void _setErrorTransformer(MessagesTransformer transformer) => _defaultMessagesTransformer = transformer;
