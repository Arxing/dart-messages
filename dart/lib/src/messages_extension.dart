import 'messages_model.dart';
import 'messages_handler.dart';

extension DartRoutingExtension on List {
  RoutingMessages toRoutingMessages() => RoutingMessages.create(this);

  String get routingMessage => this.toRoutingMessages().showMessage;
}

extension FutureErrorHandler on Future {
  Future<Null> catchErrorDefault() => this.catchError(defaultErrorHandler);
}
