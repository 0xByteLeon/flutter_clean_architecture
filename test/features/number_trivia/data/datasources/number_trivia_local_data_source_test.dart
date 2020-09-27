import 'dart:convert';

import 'package:flutter_clean_architecture/core/error/exception.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';
import '../../../../fixture/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();

    dataSource = NumberTriviaLocalDataSourceImpl(mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test(
        'should return NumberTrivia from SharedPreferences when there is one in the cache',
        () async {
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cached.json'));

      final result = await dataSource.getLastNumberTrivia();

      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a CacheException when there is not a cached value', (){
      when(mockSharedPreferences.getString(any))
          .thenReturn(null);

      final call = dataSource.getLastNumberTrivia;
      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });

  group('cacheNumberTrivia', (){
    final tNumberTriviaModel =
        NumberTriviaModel('test trivia', 1);
    test('should call SharedPrefrences to cache the data', (){
      dataSource.cacheNumberTrivia(tNumberTriviaModel);

      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(
        CACHED_NUMBER_TRIVIA,
        expectedJsonString,
      ));

    });
  });
}
