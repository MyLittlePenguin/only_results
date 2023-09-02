import 'package:only_results/only_results.dart';
import 'package:test/test.dart';

late Result<int, String> ok;
late Result<int, String> err;

void main() {
  group("test Results", () {
    setUp(setTestsUp);
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

void setTestsUp() {
  ok = Ok(42);
  err = Err("Foo");
}

void testCatchErrorsOnStateError() {
  var result = Result.catchErrors(() => [1, 2, 3].firstWhere((it) => it == 2));
  expect(result.isOk(), true);
  expect(result.isErr(), false);
  expect(result.unwrap(), 2);

  result = Result.catchErrors(() => <int>[].firstWhere((it) => it == 42));

  expect(result.isErr(), true);
  expect(result.runtimeType.toString(), "Err<int, Object>");
  expect((result as Err<int, Object>).error.runtimeType.toString(), "StateError");
}

void testExpectOk() {
  expect(ok.expect("irrelevant string"), 42);
}

void testExpectErr() {
  late Exception exception;
  try {
    err.expect("ALARM!!!");
  } catch (e) {
    exception = e as Exception;
  }
  expect(exception.toString(), "Exception: ALARM!!!");
}

void testUnwrapOk() {
  expect(ok.unwrap(), 42);
}

void testUnwrapErr() {
  late Exception exception;
  try {
    err.unwrap();
  } catch (e) {
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
  expect(ok.unwrapOr(21), 42);
}

void testUnwrapOrErr() {
  expect(err.unwrapOr(21), 21);
}

void testAndThen() {
  var result = ok.andThen((ok) => Ok(ok * 2));

  expect(result.unwrap(), 84);
  expect(result.runtimeType, Ok<int, String>);

  var result2 = ok.andThen((ok) => Ok(ok.toDouble()));

  expect(result2.unwrap(), 42.0);
  expect(result2.runtimeType, Ok<double, String>);

  var result3 = Err<int, String>("Foo");

  expect(result3.unwrapOr(42), 42);
  expect(result3.runtimeType, Err<int, String>);
}

void testOrElse() {
  var result = err.orElse((err) => Ok(42));

  expect(result.unwrap(), 42);
  expect(result.runtimeType, Ok<int, dynamic>);

  var result2 = err.orElse((err) => Err(21));

  expect((result2 as Err<int, int>).error, 21);
  expect(result2.runtimeType, Err<int, int>);

  var result3 = Ok<int, String>(42).orElse((err) => Ok(21));
  expect(result3.unwrap(), 42);
}
