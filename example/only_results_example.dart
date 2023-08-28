import 'package:only_results/only_results.dart';

void main() {
  var result = Result.catchErrors(() => <int>[].first);

  switch(result) {
      case Ok(:int value): 
          print("$value: it worked =)");
      case Err(:Object error): 
          print("=( $error");
  }
}

//////////////////////////////////////////////////////////
// Simple handling of errors
//////////////////////////////////////////////////////////
void simpleErrorHandlingExample() {
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

//////////////////////////////////////////////////////////
// Unwraping results
//////////////////////////////////////////////////////////

void unwrapIt() {
  late Result<int, String> result;
  result = Ok(42);

  //value is 42
  var value = result.unwrap();
  
  //value is 21
  value = result.unwrapOr(21);

  //value is 42
  value = result.expect("Error Text");

  result = Err("ALARM");

  try {
    value = result.unwrap();
  } catch (e) {
    // prints "Excpetion: ALARM"
    print(e);
  }

  //value is 21
  value = result.unwrapOr(21);

  try {
    value = result.expect("Error Text");
  } catch (e) {
    // prints "Exception: Error Text"
    print(e);
  }
}

//////////////////////////////////////////////////////////
// handling with andThen/OrElse
//////////////////////////////////////////////////////////

void andThenOrElse() {
  // results in Ok<int, String>(84)
  Ok<int, String>(42).andThen((ok) => Ok(ok*2)).orElse((err) => Err("Foo: $err"));
  // results in Err<int, String>("Foo: bar")
  Err<int, String>("bar").andThen((ok) => Ok(ok*2)).orElse((err) => Err("Foo: $err"));

  // results in Ok<double, int?>
  Ok<int, String>(42).andThen((ok) => Ok(ok.toString())).orElse((err) => Err(int.tryParse(err)));
  // results in Err<double, int?>(42)
  Err<int, String>("42").andThen((ok) => Ok(ok.toString())).orElse((err) => Err(int.tryParse(err)));
}
