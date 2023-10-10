import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fast_immutable_equatable/fast_immutable_equatable.dart';
import 'package:test/test.dart';

class TestClass with IFastEquatable {
  final String value1;
  final IList<String>? value2;

  const TestClass(
    this.value1,
    this.value2,
  );
  @override
  bool get cacheHash => false;

  @override
  bool get additionalEqualityCheck => false;

  @override
  List<Object?> get hashParameters => [value1, value2];
}

class TestRef with IFastEquatable {
  final TestClass testClass;

  const TestRef(this.testClass);

  @override
  bool get cacheHash => false;

  @override
  bool get additionalEqualityCheck => false;

  @override
  List<Object?> get hashParameters => [testClass];
}

class TestExtClass extends TestClass {
  final List<TestClass?> additionalParam;

  const TestExtClass(
    super.value1,
    super.value2,
    this.additionalParam,
  );

  @override
  bool get cacheHash => false;

  @override
  bool get additionalEqualityCheck => false;

  @override
  List<Object?> get hashParameters =>
      [...super.hashParameters, additionalParam];
}

void main() {
  group('FastEquatable Mixin', () {
    test('Simple equals', () {
      const a = TestClass('value1', null);
      const b = TestClass('value1', null);

      expect(a == b, isTrue);
      expect(a.hashCode, equals(b.hashCode));
    });

    test('Simple unequals', () {
      const a = TestClass('value1', null);
      const b = TestClass('value2', null);

      expect(a == b, isFalse);
    });

    test('Simple equals iterable', () {
      final a = TestClass('value1', <String>['1', '2'].lock);
      final b = TestClass('value1', <String>['1', '2'].lock);

      expect(a == b, isTrue);
      expect(a.hashCode, equals(b.hashCode));
    });

    test('Simple unequals iterable', () {
      final a = TestClass('value1', <String>['1', '2'].lock);
      final b = TestClass('value1', <String>['2', '1'].lock);

      expect(a == b, isFalse);
      expect(a.hashCode, isNot(b.hashCode));
    });

    test('Equals null', () {
      const a = TestClass('value1', null);
      final b = TestClass('value1', <String>[].lock);

      expect(a == b, isFalse);
    });

    test('Cache hashcode with additional equals', () {
      final a = TestClass('value1', <String>[].lock);
      final b = TestClass('value1', <String>[].lock);

      expect(a == b, isTrue);
      final c = TestClass('value1', <String>['different'].lock);
      expect(a != c, isTrue);
    });

    test('Testing identical reference', () {
      final a = TestClass('value1', <String>[].lock);

      final refA = TestRef(a);
      final refB = TestRef(a);

      expect(refA == refB, isTrue);
      a.value2!.add('add new');
      expect(refA == refB, isTrue);
      expect(refA.hashCode, equals(refB.hashCode));
    });
  });

  test('Testing extended classes unequal', () {
    final a = TestClass('d', <String>[].lock);
    final b = TestClass(String.fromCharCode(0x64), <String>[].lock);

    final c = TestExtClass(
      String.fromCharCode(0x64),
      <String>[].lock,
      [b],
    );

    final d = TestExtClass(
      String.fromCharCode(0x64),
      <String>[].lock,
      [],
    );

    expect(a == b, isTrue);
    expect(a.hashCode, equals(b.hashCode));

    expect(c != d, isTrue);
    expect(c.hashCode != d.hashCode, isTrue);

    d.additionalParam.add(a);
    expect(c == d, isTrue);
    expect(c.hashCode, equals(d.hashCode));
  });
}
