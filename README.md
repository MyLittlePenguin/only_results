<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

This package is yet another Rust like Result implementation. 
There are already several others and they are basically all the same.
This isn't much different. Just pick one you like.

## Features

The Features include the basic functions you would expect:

- expect 
- unwrap
- unwrapOr
- andThen
- orElse

These functions also exist as extension Functions for Futures of Results for Convenience reasons.

One thing that is special about this implementation, is that you can use the andThen
and orElse functions to convert a result to a slightly different one. 
This can be usefull wenn you have multiple function calls in one function that return 
different Results. For more details on that have a look at the examples.

## Getting started

```dart
import "package:only_results/only_results.dart";

var result = Result.catchErrors(() => unsafeFunction());

switch(result) {
    case Ok(:void value): 
        print("it worked =)");
    case Err(:Object error): 
        print("=( $error");
}

```

## Usage

To use this library you just have to import it into your project and define the return type of your 
functions according to your needs.

```dart

void main() {
    var a = 42;
    var b = 10;
    switch(divide(a, b)) {
        case Ok(:int value): 
            print("$a / $b = $value");
        case Err(:String error):
            print("ERROR: $error");
    }
}

Result<int, String> divide(int a, int b) {
    if(b == 0) {
        return Err("divison by zero is not allowed");
    }
    return Ok(a ~/ b);
}
```

### Just handle the Happy Path

If you have for example written a function, that you know will, given your specific
input, always return an Ok of something, you can use either unwrap or expect.

```dart
void main() {
    var result = someFunction("Hallo Welt");

    int value = result.unwrap();
    int value2 = result.expect("Exception Text if result is an Error")
    int value3 = result.unwrapOr(42);
}

Result<int, String> someFunction(String value) {
    ...
}
```

### Handle the Result with andThen / orElse

As you have already seen you can use a switch-statement to handle the Result object.
But you can also use the andThen and orElse function to chain multiple actions 
together.

```dart
void main() {
    fn1("Hallo Welt").andThen(fn2).orElse(errHandler);
    fn1("Hallo Welt").andThen((okValue) => Ok(okValue / 2));
}

Result<int, String> fn1(String str) {
    ...
}

Result<int, String> fn2(int i) {
    ...
}

Result<int, String> errHandler(String str) {
    ...
}
```

You can also use those functions to convert a result to another type of result.

```dart
Result<int, String> findFirst(List<String> words, String word) {
  return Result.catchErrors(() => words.firstWhere((it) => it == word))
    .orElse((Object error) => Err(error.toString()));
}
```

## Additional information

If you want to see more examples, have a look at the tests.
