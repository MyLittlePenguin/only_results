import 'package:only_results/only_results.dart';
import 'package:test/test.dart';


void main() {
  group("test Results", () {
    test("test Result.catchErrors", testCatchErrorsOnStateError);
  });
}

void testCatchErrorsOnStateError() {
  var result = Result.catchErrors(() => <int>[].firstWhere((it) => it == 42));

  expect(result.isErr(), true);
  expect(result.runtimeType.toString(), "Err<int, Object>");
  expect((result as Err<int, Object>).error.runtimeType.toString(),"StateError");
}

