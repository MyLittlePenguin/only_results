import 'only_results_base.dart';

extension FutureExtensions<O, E> on Future<Result<O, E>> {
  Future<O> expectAsync(String msg) async => (await this).expect(msg);
  Future<O> unwrapAsync() async => (await this).unwrap();
  Future<O> unwrapOrAsync(O defaultValue) async => (await this).unwrapOr(defaultValue);

  Future<Result<O2, E>> andThenAsync<O2>(Result<O2, E> Function(O ok) fn) async {
    return (await this).andThen(fn);
  }

  Future<Result<O, E2>> orElseAsync<E2>(Result<O, E2> Function(E err) fn) async {
    return (await this).orElse(fn);
  }
}
