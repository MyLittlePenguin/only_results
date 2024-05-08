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
  test("test Future andThen", testAndThen);
  test("test Future andThenAsync", testAndThenAsync);
  test("test Future orElse", testOrElse);
  test("test Future orElseAsync", testOrElseAsync);
  test("test Iterable whileOk", testWhileOk);
  test("test Iterable whileOk until it's not", testUntilNotOk);
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

Future<void> testAndThen() async {
  expect(await ok.andThen((ok) => Ok(ok.toString())).unwrap(), "42");
  expect((await err.andThen((ok) => Ok(ok.toString())) as Err).error, "fooo");
}

Future<void> testAndThenAsync() async {
  expect(await ok.andThenAsync((ok) async => Ok(ok.toString())).unwrap(), "42");
  expect((await err.andThenAsync((ok) async => Ok(ok.toString())) as Err).error,
      "fooo");
}

Future<void> testOrElse() async {
  expect(
    await ok
        .andThen((ok) => Ok(ok.toString()))
        .orElse((err) => Ok(err))
        .unwrap(),
    "42",
  );
  expect(
    await err
        .andThen((ok) => Ok(ok.toString()))
        .orElse((err) => Ok(err))
        .unwrap(),
    "fooo",
  );
}

Future<void> testOrElseAsync() async {
  expect(
    await ok
        .andThen((ok) => Ok(ok.toString()))
        .orElseAsync((err) async => Ok(err))
        .unwrap(),
    "42",
  );
  expect(
    await err
        .andThen((ok) => Ok(ok.toString()))
        .orElseAsync((err) async => Ok(err))
        .unwrap(),
    "fooo",
  );
}

void testWhileOk() {
  expect(
    <Result<int, String>>[
      Ok(1),
      Ok(2),
      Ok(3),
      Ok(4),
      Ok(5),
    ].whileOk<int>((lastValue, it) => switch (lastValue) {
          int value => Ok(value + it),
          null => Ok(it),
        }),
    Ok(15),
  );
}

void testUntilNotOk() {
  expect(
    <Result<int, String>>[
      Ok(1),
      Ok(2),
      Ok(3),
      Err("everything sucks"),
      Ok(5),
    ].whileOk<int>((lastValue, it) => switch (lastValue) {
          int value => Ok(value + it),
          null => Ok(it),
        }),
    Err("everything sucks"),
  );
}
