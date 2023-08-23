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



## Additional information

If you want to see more examples, have a look at the tests.
