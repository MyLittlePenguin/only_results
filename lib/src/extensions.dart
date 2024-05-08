import 'only_results_base.dart';

///This extensions makes it easier to handle the [Result] inside
///of [Future] objects.
extension FutureExtensions<O, E> on Future<Result<O, E>> {
  /// awaits the [Future] and executes the expect of the [Result].
  Future<O> expect(String msg) async => (await this).expect(msg);

  /// awaits the [Future] and executes the unwrap of the [Result].
  Future<O> unwrap() async => (await this).unwrap();

  /// awaits the [Future] and executes the unwrapOr of the [Result].
  Future<O> unwrapOr(O defaultValue) async =>
      (await this).unwrapOr(defaultValue);

  /// awaits the [Future] and executes the unwrapOrElse of the [Result].
  Future<O> unwrapOrElse(O Function() fn) async =>
      (await this).unwrapOrElse(fn);

  /// awaits the [Future] and executes the unwrapOrElseAsync of the [Result].
  Future<O> unwrapOrElseAsync(Future<O> Function() fn) async =>
      await (await this).unwrapOrElseAsync(fn);

  /// awaits the [Future] and executes the andThen of the [Result].
  Future<Result<O2, E>> andThen<O2>(Result<O2, E> Function(O ok) fn) async {
    return (await this).andThen(fn);
  }

  /// awaits the [Future] and executes the andThenAsync of the [Result].
  Future<Result<O2, E>> andThenAsync<O2>(
    Future<Result<O2, E>> Function(O ok) fn,
  ) async {
    return await (await this).andThenAsync(fn);
  }

  /// awaits the [Future] and executes the orElse of the [Result].
  Future<Result<O, E2>> orElse<E2>(Result<O, E2> Function(E err) fn) async {
    return (await this).orElse(fn);
  }

  /// awaits the [Future] and executes the orElse of the [Result].
  Future<Result<O, E2>> orElseAsync<E2>(
    Future<Result<O, E2>> Function(E err) fn,
  ) async {
    return await (await this).orElseAsync(fn);
  }
}

extension IterableExtensions<L, E> on Iterable<Result<L, E>> {
  /// __EXPERIMENTAL:__ might change in the Future.
  ///
  /// executes the Function [fn] for every element in the iterable for as long
  /// as there are any and the [Result] of fn isn't an [Err].
  Result<O, E>? whileOk<O>(Result<O, E> Function(O? lastValue, L it) fn) {
    Result<O, E>? last;

    final iter = iterator;
    while (iter.moveNext() && last is Ok<O, E>?) {
      switch (iter.current) {
        case Ok(value: final it):
          last = fn(last?.value, it);
        case Err(:final error):
          return Err(error);
      }
    }
    return last;
  }
}
