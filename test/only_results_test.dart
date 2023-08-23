import 'package:only_results/only_results.dart';
import 'package:test/test.dart';

void main() {
  group("test Results", () {
    test("test Result.catchErrors", testCatchErrorsOnStateError);
    test("test Ok.expect", testExpectOk);
    test("test Err.expect", testExpectErr);
    test("test Ok.unwrap", testUnwrapOk);
    test("test Err.unwrap", testUnwrapErr);
    test("test Result.isOk", testIsOk);
    test("test Result.isErr", testIsErr);
    test("test Ok.unwrapOr", testUnwrapOrOk);
    test("test Err.unwrapOr", testUnwrapOrErr);
    test("test Result.andThen", testAndThen);
    test("test Result.orElse", testOrElse);
  });
}

void testCatchErrorsOnStateError() {
  var result = Result.catchErrors(() => <int>[].firstWhere((it) => it == 42));

  expect(result.isErr(), true);
  expect(result.runtimeType.toString(), "Err<int, Object>");
  expect((result as Err<int, Object>).error.runtimeType.toString(),"StateError");
}

void testExpectOk() {
  Result<int, String> result = Ok(42);

  expect(result.expect("irrelevant string"), 42);
}

void testExpectErr() {
  Result<int, String> result = Err("Some Error");

  late Exception exception;
  try {
    result.expect("ALARM!!!");
  } catch (e) {
    exception = e as Exception;
  }
  expect(exception.toString(), "Exception: ALARM!!!");
}

void testUnwrapOk() {
  Result<int, String> result = Ok(42);

  expect(result.unwrap(), 42);
}

void testUnwrapErr() {
  Result<int, String> result = Err("Foo");

  late Exception exception;
  try {
    result.unwrap();
  } catch(e) {
    exception = e as Exception;
  }
  expect(exception.toString(), "Exception: Foo");
}

void testIsOk() {
  expect(Ok(42).isOk(), true);
  expect(Err("nope").isOk(), false);
}

void testIsErr() {
  expect(Ok(42).isErr(), false);
  expect(Err("nope").isErr(), true);
}

void testUnwrapOrOk() {
  var result = Ok(42);
  expect(result.unwrapOr(21), 42);
}

void testUnwrapOrErr() {
  var result = Err<int, String>("Foo");
  expect(result.unwrapOr(21), 21);
}

void testAndThen() {
  Result<int, String> result = Ok(21);
  var result2 = result.andThen((ok) => Ok(ok * 2));

  expect(result2.unwrap(), 42);
  expect(result2.runtimeType, Ok<int, String>);

  var result3 = result2.andThen((ok) => Ok(ok.toDouble()));

  expect(result3.unwrap(), 42.0);
  expect(result3.runtimeType, Ok<double, String>);

  var result4 = Err<int, String>("Foo");

  expect(result4.unwrapOr(42), 42);
  expect(result4.runtimeType, Err<int, String>);
}

void testOrElse() {
  Result<int, String> result = Err("Foo");
  var result2 = result.orElse((err) => Ok(42));

  expect(result2.unwrap(), 42);
  expect(result2.runtimeType, Ok<int, dynamic>);

  var result3 = result.orElse((err) => Err(21));

  expect((result3 as Err<int, int>).error, 21);
  expect(result3.runtimeType, Err<int, int>);

  var result4 = Ok<int, String>(42).orElse((err) => Ok(21));
  expect(result4.unwrap(), 42);
}
