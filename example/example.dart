import 'dart:math';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_equatable/fast_immutable_equatable.dart';

class FastEquatableCached with IFastEquatable {
  final String value1;
  final List<String>? value2;

  const FastEquatableCached(this.value1, this.value2);

  @override
  bool get cacheHash => true;

  @override
  List<Object?> get hashParameters => [value1, value2];
}

class FastEquatableUncached with IFastEquatable {
  final String value1;
  final List<String>? value2;

  const FastEquatableUncached(this.value1, this.value2);

  @override
  bool get cacheHash => false;

  @override
  List<Object?> get hashParameters => [value1, value2];
}

// Quick example of how to subclass A.
class A with IFastEquatable {
  final String arg1;
  final int arg2;
  const A(this.arg1, this.arg2);

  @override
  bool get cacheHash => true;

  @override
  List<Object?> get hashParameters => [arg1, arg2];
}

class AB extends A {
  final int arg3;
  AB(super.arg1, super.arg2, this.arg3);

  @override
  bool get cacheHash => true;

  @override
  List<Object?> get hashParameters => [...super.hashParameters, arg2];
}

class TestClassEquatable extends Equatable {
  final String value1;
  final List<String>? value2;

  const TestClassEquatable(this.value1, this.value2);

  @override
  List<Object?> get props => [value1, value2];
}

class EquatableBenchmark extends BenchmarkBase {
  final List<String> _randsValA;
  final List<String> _randsValB;

  late final List<TestClassEquatable> objects;

  EquatableBenchmark(this._randsValA, this._randsValB)
      : assert(_randsValA.length == _randsValB.length),
        super('equatable for ${_randsValA.length} elements');

  @override
  void setup() {
    objects = List.generate(_randsValA.length,
        (i) => TestClassEquatable(_randsValA[i], [_randsValB[i]]));
  }

  @override
  void run() {
    final set = <TestClassEquatable>{};

    for (final obj in objects) {
      set.add(obj);
    }
  }
}

class FastEquatableUncachedBenchmark extends BenchmarkBase {
  final List<String> _randsValA;
  final List<String> _randsValB;

  late final List<FastEquatableUncached> objects;

  FastEquatableUncachedBenchmark(this._randsValA, this._randsValB)
      : assert(_randsValA.length == _randsValB.length),
        super(
            'fast_immutable_equatable (uncached) for ${_randsValA.length} elements');

  @override
  void setup() {
    objects = List.generate(_randsValA.length,
        (i) => FastEquatableUncached(_randsValA[i], [_randsValB[i]]));
  }

  @override
  void run() {
    final set = <FastEquatableUncached>{};

    for (final obj in objects) {
      set.add(obj);
    }
  }
}

class FastEquatableCachedBenchmark extends BenchmarkBase {
  final List<String> _randsValA;
  final List<String> _randsValB;

  late final List<FastEquatableCached> objects;

  FastEquatableCachedBenchmark(this._randsValA, this._randsValB)
      : assert(_randsValA.length == _randsValB.length),
        super(
            'fast_immutable_equatable (cached) for ${_randsValA.length} elements');

  @override
  void setup() {
    objects = List.generate(_randsValA.length,
        (i) => FastEquatableCached(_randsValA[i], [_randsValB[i]]));
  }

  @override
  void run() {
    final set = <FastEquatableCached>{};

    for (final obj in objects) {
      set.add(obj);
    }
  }
}

void main(List<String> args) {
  const nAcc = 1000000;

  final rand = Random();
  final randsVal1 = List.generate(nAcc, (_) => rand.nextInt(nAcc).toString());
  final randsVal2 = List.generate(nAcc, (_) => rand.nextInt(nAcc).toString());

  EquatableBenchmark(randsVal1, randsVal2).report();
  FastEquatableUncachedBenchmark(randsVal1, randsVal2).report();
  FastEquatableCachedBenchmark(randsVal1, randsVal2).report();
}
