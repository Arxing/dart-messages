import 'messages_model.dart';
import 'messages_mapper.dart';
import 'package:xson/xson.dart';
import 'package:meta/meta.dart';

part 'messages_handler.dart';

/// Delegate of displaying message.
typedef MessagesDisplayDelegate = Future<bool> Function(String message);

/// Messages plugin that saves static properties.
class MessagesPlugin {
  static MessagesDisplayDelegate _delegate;

  MessagesPlugin._() {}

  /// Implements this delegate to display your message like `println(message)` in dart or `showToast(message)` in flutter.
  static void setDelegate(MessagesDisplayDelegate delegate) => _delegate = delegate;

  /// Entry of display extension function
  static Future<bool> _display({
    @required String msg,
  }) async {
    if (_delegate == null) {
      print("[Warning] Delegate is not implemented!");
      return false;
    } else {
      return _delegate(msg);
    }
  }

  /// Load routing configuration with json element into plugin.
  static MessagesRouteData load(JsonElement jsonElement) => MessagesMapper.getInstance().load(jsonElement);

  /// Load routing configuration with raw json into plugin.
  static MessagesRouteData loadAsString(String json) => MessagesMapper.getInstance().loadAsString(json);

  /// Get current routing data.
  static MessagesRouteData get currentRouteData => MessagesMapper.getInstance().currentRouteData;

  /// Return whether routing configuration was loaded or not.
  static bool get isLoaded => MessagesMapper.getInstance().isLoaded;

  /// Display a pure message.
  static Future<bool> display(String message) => MessagesPlugin._display(msg: message);

  /// Display [Messages].showMessage if not null.
  static Future<bool> displayMessages(Messages e) async {
    if (e?.message != null) return display(e.message);
    return false;
  }

  /// Display a [StringMessages] with message.
  static Future<bool> displayString(String message, [String debugMessage]) => displayMessages(StringMessages(message, debugMessage));

  /// Display a [errorMessage] with error and stack trace.
  static Future<bool> displayError(String errorMessage, [StackTrace stackTrace]) =>
      displayMessages(ErrorMessages.of(errorMessage, stackTrace));

  /// Display a [routingMessage] with routes.
  static Future<bool> displayRouting([
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
    return displayMessages(RoutingMessages.of(
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

  static ErrorHandler get errorHandler => _defaultErrorHandler;

  static void setErrorHandler(MessagesHandler handler) => _setErrorHandler(handler);

  static void setErrorTransformer(MessagesTransformer transformer) => _setErrorTransformer(transformer);
}

// Extension definition

extension MessagesOnListExtension on List {
  RoutingMessages toRoutingMessages() => RoutingMessages.create(this);

  void display() => this.toRoutingMessages().display();

  String get routingMessage => this.toRoutingMessages().message;
}

extension MessagesOnFutureExtension<T> on Future<T> {
  Future<T> catchErrorDefault() => this.catchError(_defaultErrorHandler);
}

extension MessagesExtension on Messages {
  void display() => MessagesPlugin._display(msg: this.message);
}