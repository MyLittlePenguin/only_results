import 'only_results_base.dart';

extension FutureExtensions<O, E> on Future<Result<O, E>> {
  Future<O> expect(String msg) async => (await this).expect(msg);
  Future<O> unwrap() async => (await this).unwrap();
  Future<O> unwrapOr(O defaultValue) async => (await this).unwrapOr(defaultValue);

  Future<Result<O2, E>> andThen<O2>(Result<O2, E> Function(O ok) fn) async {
    return (await this).andThen(fn);
  }

  Future<Result<O, E2>> orElse<E2>(Result<O, E2> Function(E err) fn) async {
    return (await this).orElse(fn);
  }
}
