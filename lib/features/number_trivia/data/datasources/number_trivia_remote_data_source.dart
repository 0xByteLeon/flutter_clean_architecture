import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture/core/error/exception.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final Dio dio;

  NumberTriviaRemoteDataSourceImpl(this.dio) {}

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) => _getTriviaNumber('http://numbersapi.com/$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() => _getTriviaNumber('http://numbersapi.com/random');
  Future<NumberTriviaModel> _getTriviaNumber(String url) async {
    final response = await dio.get(url);
    print(response);
    if (200 == response.statusCode) {
      return NumberTriviaModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }
}
