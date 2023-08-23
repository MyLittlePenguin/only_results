import 'package:only_results/only_results.dart';
import 'package:test/test.dart';

late Future<Result<int, String>> ok;
late Future<Result<int, String>> err;

void main() {
  group("test Future Results", extensionTests);
}

void extensionTests() {
  setUp(setTestsUp);
  test("test Future expectAsync", testExpect);
  test("test Future unwrapAsync", testUnwrap);
  test("test Future unwrapOrAsync", testUnwrapOrAsync);
}

void setTestsUp() {
  ok = Future.value(Ok(42));
  err = Future.value(Err("fooo"));
}

Future<void> testExpect() async {
  expect(await ok.expectAsync("bar"), 42);

  late String exceptionString;
  try {
    await err.expectAsync("bar");
  } catch (e) {
    exceptionString = e.toString();
  }
  expect(exceptionString, "Exception: bar");
}

Future<void> testUnwrap() async {
  expect(await ok.unwrapAsync(), 42);

  late String exceptionString;
  try {
    await err.unwrapAsync();
  } catch (e) {
    exceptionString = e.toString();
  }

  expect(exceptionString, "Exception: fooo");
}

Future<void> testUnwrapOrAsync() async {
  expect(await ok.unwrapOrAsync(21), 42);
  expect(await err.unwrapOrAsync(21), 21);
}
