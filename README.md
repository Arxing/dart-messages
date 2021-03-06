# Messages

![](https://img.shields.io/badge/language-dart-orange.svg)

## Install

### For Dart or Flutter
```yaml
messages_dart: any
```
### Flutter Only
```yaml
messages_flutter: any
```

## MessagesPlugin

All functions is in `MessagesPlugin`.

## Messages
`Messages` has 3 implementation:

+ StringMessages - Pure text messages.
+ ErrorMessages - Throwable object and stack trace messages.
+ RoutingMessages - Routable messages.

### StringMessage
```dart
var msg = StringMessages("Pure text messages");
```

### ErrorMessages
```dart
void main(){
  try {
    //do something
  } catch (error, stack) {
    ErrorMessages.of(error?.toString(), stack);
  }
    
  Observable.just(data).listen(null, onError: (error, stack){
    ErrorMessages.of(error?.toString(), stack);
  });
}
```

### RoutingMessages
```dart
void main(){
  RoutingMessages.of("login");
  RoutingMessages.of("login", "buttons");
  RoutingMessages.of("login", "buttons", "accountHint");
  RoutingMessages.create([100, 6000, 900001]);
}
```

## Usage

### Prepare Messages Resource File

Messages Resource file supports any formats which can parse by json like json, yaml, xml or properties.

#### Base Resource Format

| key | description |
| --- | --- |
| message | display message |
| remark | Remark message |
| routes | Children routes |

#### Simple Content

```json
{
    "message": "This is a default message",
    "routes": {
        "100": "Hello World!",
        "101": "Goodnight",
        "102": "Yes, I do!",
        "home": "Okay~",
        "login": "What the hell?"
    }
}
```
Message of routing `[100]` map to "Hello World!".

Message of routing `[home]` map to "Okay~".

Message of routing `[600]` map to "This is a default message".

#### Complex Content

```json
{
    "message": "This is a default message",
    "routes": {
        "100": {
            "remark": "remark",
            "message": "Hello World!"        
        },
        "101": "Goodnight",
        "102": "Yes, I do!",
        "home": {
            "remark": "home page",
            "message": "Okay~"
        },
        "login": "What the hell?"
    }
}
```
Message of routing `[100]` map to "Hello World!".

Remark of routing `[100]` map to "remark".

Message of routing `[home]` map to "Okay~".

Remark of routing `[home]` map to "home page".


#### Nested Routing

```json
{
    "message": "This is a default message",
    "routes": {
        "100": {
            "remark": "remark",
            "message": "Hello World!",
            "routes": {
                "5000": "Apple is red",
                "6000": "Banana is yellow"
            }  
        },
        "101": "Goodnight",
        "102": "Yes, I do!",
        "home": {
            "remark": "home page",
            "message": "Okay~"
        },
        "login": {
            "message": "What the hell?",
            "routes": {
                "buttons": {
                    "routes": {
                        "accountHint": "Please input account",
                        "passwordHint": {
                            "message": "Please input password"
                        }
                    }
                }
            }
        }
    }
}
```
Message of routing `[100, 5000]` map to "Apple is red".

Message of routing `[100, 6000]` map to "Banana is yellow".

Message of routing `[100, 6000, 99000]` map to "Banana is yellow".

Message of routing `[100, 9000]` map to "Hello World!".

Message of routing `[login, buttons, accountHint]` map to "Please input account".

### Load Messages Resource File

#### Raw Json

```dart
void main(){
  File resource = File("filepath");
  String json = resource.readAsStringSync();
  
  MessagesPlugin.loadAsString(json);
  // or
  JsonElement jsonElement = JsonElement.fromJsonString(json);
  MessagesPlugin.load(jsonElement);
}
```

#### Yaml
Add dependency to `pubspec.yaml`

```yaml
dependencies:
  yaml: ^2.2.0
```

```dart
import 'dart:convert';
import 'package:yaml/yaml.dart' as yaml;

void main(){
  File resource = File("filepath");
  String content = resource.readAsStringSync();
  
  var doc = yaml.loadYaml(content);
  String json = json.encode(doc);
  
  MessagesPlugin.loadAsString(json);
  // or
  JsonElement jsonElement = JsonElement.fromJsonString(json);
  MessagesPlugin.load(jsonElement);
}
```

#### Xml
Add dependency to `pubspec.yaml`

```yaml
dependencies:
  xml2json: ^4.1.1
```

```dart
import 'dart:convert';
import 'package:xml2json/xml2json.dart';

void main(){
  File resource = File("filepath");
  String content = resource.readAsStringSync();
  
  var xml2Json = Xml2Json();
  xml2Json.parse(content);
  String json = json.encode(xml2Json.toGData());
  
  MessagesPlugin.loadAsString(json);
  // or
  JsonElement jsonElement = JsonElement.fromJsonString(json);
  MessagesPlugin.load(jsonElement);
}
```

### Throw and Handle Error

```dart
void main(){
  MessagesPlugin.loadAsString(jsonEncode(msg));

  MessagesPlugin.setErrorHandler((Messages messages) {
    print("Custom Handle message: ${messages.message}");
  });
  MessagesPlugin.setErrorTransformer((error, [stack]) {
    if (error is int) return StringMessages("int: $error");
    return StringMessages(error?.toString());
  });

  Future.sync(() {
    // do something
    throw RoutingMessages.of(100, 5000);
  }).catchError(MessagesPlugin.errorHandler).then((_) {
    throw 100;
  }).catchError(MessagesPlugin.errorHandler).then((_){
    throw "An Error~";
  }).catchError(MessagesPlugin.errorHandler);
}
```

### Get Message from Routing

```dart
var msg = RoutingMessages(100, 5000).message;
```

### Extensions

#### Getting as RoutingMessages

```dart
void main(){
  // list extension for routing
  RoutingMessages routingMessages = [100, 5000].toRoutingMessages();
}
```
#### Routing Message

```dart
void main(){
  var message = [100, 5000].routingMessage;
  message = ["login", "buttons", "accountHint"].routingMessage;
}
```

#### Error Handler
```dart
void main(){
  Future.sync(() {
    throw 100;
  }).catchErrorDefault().then((_) {
    throw [100, 5000].toRoutingMessages();
  }).catchErrorDefault();
}
```

#### Display

```dart
void main() {
  MessagesPlugin.display("Hello World");
  MessagesPlugin.displayString("Hello World");
  MessagesPlugin.displayError("An Error");
  MessagesPlugin.displayRouting(100, 5000);
  
  // messages extension
  Messages messages = StringMessages("Hello World");
  messages.display();
  
  // list extension for routing
  [100, 5000].display();  
}
```
