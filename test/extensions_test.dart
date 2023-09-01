import 'package:only_results/only_results.dart';
import 'package:test/test.dart';

late Future<Result<int, String>> ok;
late Future<Result<int, String>> err;

void main() {
  group("test Future Results", extensionTests);
}

void extensionTests() {
  setUp(setTestsUp);
  test("test Future expect", testExpect);
  test("test Future unwrap", testUnwrap);
  test("test Future unwrapOr", testUnwrapOr);
}

void setTestsUp() {
  ok = Future.value(Ok(42));
  err = Future.value(Err("fooo"));
}

Future<void> testExpect() async {
  expect(await ok.expect("bar"), 42);

  late String exceptionString;
  try {
    await err.expect("bar");
  } catch (e) {
    exceptionString = e.toString();
  }
  expect(exceptionString, "Exception: bar");
}

Future<void> testUnwrap() async {
  expect(await ok.unwrap(), 42);

  late String exceptionString;
  try {
    await err.unwrap();
  } catch (e) {
    exceptionString = e.toString();
  }

  expect(exceptionString, "Exception: fooo");
}

Future<void> testUnwrapOr() async {
  expect(await ok.unwrapOr(21), 42);
  expect(await err.unwrapOr(21), 21);
}
