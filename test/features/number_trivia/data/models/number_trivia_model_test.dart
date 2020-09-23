import 'dart:convert';

import 'package:flutter_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel('test', 1);

  group('fromJson', () {
    test('should be a subclass of NumberTrivia entity', () async {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia.json'));

      final result = NumberTriviaModel.fromeJson(jsonMap);
      expect(result, isA<NumberTrivia>());
    });
  });

  group('fromJson', () {
    test('should be a subclass of NumberTrivia entity', () async {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));

      final result = NumberTriviaModel.fromeJson(jsonMap);
      expect(result, isA<NumberTrivia>());
    });
  });

  group('toJson', () {
    test('should return aJSON map containing the proper data', () async {
      final result = tNumberTriviaModel.toJson();
      final expectedJsonMap = {
        'text': 'test',
        'number': 1,
      };

      expect(result, expectedJsonMap);
    });
  });
}
