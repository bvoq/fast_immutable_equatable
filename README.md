## Overview

This is a Dart package derived from fast_equatable but which adds immutability to the code, making it compatible with equatable.

The hashes are cached using a double lookup trick on a static map which keeps the immutability.

Note that in terms of speed this library is a bit slower than fast_equatable due to the double lookup, but still faster than equatable for most purposes, especially if you do a lot of comparisons.

You can use depend on `IFastEquatable` just like a mixin (this is the preferred option, since it is easier to integrate into existing code),
or you can extend `IFastEquatable` as a class.

The library offers hash caching to improve the speed of e.g. `List`, `Map`'s and `Set`'s.

By default the widely spread [Jenkins hash function](https://en.wikipedia.org/wiki/Jenkins_hash_function) is used, but you are free to also implement and provide your own hash engine, suiting your needs.

Objects of any kind are allowed into `hashParameters` (this works the same way as `props` in the equatable package). Simple types and the standard collections like `List`, `Iterable`, `Map` an `Set` are supported by default.

In order to use the immutable collections from `fast_immutable_collections` like `IList`, `ISet` and `IMap` you just need to enable deep equality and hashed.
`defaultConfig = ConfigList(isDeepEquals: false, cacheHashCode: false);`.

However, since `IFastEquatable` is marked immutable, you can also use regular `List`s, `Map`s and `Set`s without worrying that they will be modified.

## How to use IFastEquatable

Using the mixedin approach (recommended):

```dart
class A with IFastEquatable {
  final String arg1;
  final IMap<String> arg2;
  const A(this.arg1, this.arg2);

  @override
  bool get cacheHash => true;

  @override
  List<Object?> get hashParameters => [arg1, arg2];
}
```

### How to subclass A
The library forces you to adhere to a certain style when dealing with subclasses and hashParameters.
It's important that hashParameters are called with a spread operator, otherwise you will get a warning from the compiler.

```dart
class AB extends A {
  final List<int> arg3;
  AB(super.arg1, super.arg2, this.arg3);

  @override
  bool get cacheHash => true;

  @override
  List<Object?> get hashParameters => [...super.hashParameters, arg3];
}
```

## Benchmark

In the `example` you will find a benchmark code, showing off the resulting speed improvement.
However, this is not really comparable, since the test doesn't try multiple comparisons with the same object.
If that were the case, fast_immutable_equatable is much faster.

```
equatable for 1000000 elements(RunTime): 4789464.0 us.
fast_immutable_equatable (uncached) for 1000000 elements(RunTime): 4467237.0 us.
fast_immutable_equatable (cached) for 1000000 elements(RunTime): 3723849.5 us.
```