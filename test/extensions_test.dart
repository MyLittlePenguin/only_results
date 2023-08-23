import 'package:only_results/only_results.dart';
import 'package:test/test.dart';

void main() {
  group("test Future Results", extensionTests);
}

void extensionTests() {
  test("test Future expect", testExpect);
  test("test Future unwrap", testUnwrap);
}

Future<void> testExpect() async {
  Future<Result<int, String>> result = Future.value(Ok(42));
  expect(await result.expect("foooo"), 42);

  result = Future.value(Err("mäh"));
  late String exceptionString;
  try {
    await result.expect("fooo");
  } catch (e) {
    exceptionString = e.toString();
  }
  expect(exceptionString, "Exception: fooo");
}

Future<void> testUnwrap() async {
  Future<Result<int, String>> result = Future.value(Ok(42));
  expect(await result.unwrap(), 42);

  result = Future.value(Err("mäh"));
  late String exceptionString;
  try {
    await result.unwrap();
  } catch (e) {
    exceptionString = e.toString();
  }

  expect(exceptionString, "Exception: mäh");
}
