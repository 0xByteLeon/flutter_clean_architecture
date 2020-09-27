import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture/core/error/exception.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';

const dioHttpHeadersForResponseBody = {
  Headers.contentTypeHeader: [Headers.jsonContentType],
};

class DioAdapterMock extends Mock implements HttpClientAdapter {}

void main() {
  Dio tDio = Dio()..options = BaseOptions(contentType: 'application/json');
  DioAdapterMock dioAdapterMock;
  NumberTriviaRemoteDataSource dataSource;

  void setUpMockHttpClientSuccess200() {
    when(dioAdapterMock.fetch(any, any, any)).thenAnswer(
        (realInvocation) async => ResponseBody.fromString(
            fixture("trivia.json"), 200,
            headers: dioHttpHeadersForResponseBody));
  }

  void setUpMockHttpClientFailure404() {
    when(dioAdapterMock.fetch(any, any, any)).thenAnswer(
        (realInvocation) async => ResponseBody.fromString(
            fixture("trivia.json"), 404,
            headers: dioHttpHeadersForResponseBody));
  }

  group('getConcreteNumberTrivia', () {
    setUp(() {
      dioAdapterMock = DioAdapterMock();
      tDio.httpClientAdapter = dioAdapterMock;
      dataSource = NumberTriviaRemoteDataSourceImpl(tDio);
    });

    final tNumber = 1;

    test(
        'should preform a GET request on a URL with number being the endpoint and with  application/json header',
        () async {
      setUpMockHttpClientSuccess200();

      dataSource.getConcreteNumberTrivia(tNumber);
      final result = await tDio.get('http://numbersapi.com/$tNumber');
      verify(result);
    });

    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture("trivia.json")));

    test('should return NumberTrivia when the response code is 200(succeed)',
        () async {
      setUpMockHttpClientSuccess200();

      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should throw a ServerException when the response code is 404 or others',
        () async {
      setUpMockHttpClientFailure404();
      final call = dataSource.getConcreteNumberTrivia;
      expect(() => call(tNumber), throwsA(isA<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      'should preform a GET request on a URL with *random* endpoint with application/json header',
      () {
        //arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.getRandomNumberTrivia();
        // assert
        verify(tDio.get(
          'http://numbersapi.com/random',
        ));
      },
    );

    test(
      'should return NumberTrivia when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getRandomNumberTrivia();
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getRandomNumberTrivia;
        // assert
        expect(() => call(), throwsA(isA<ServerException>()));
      },
    );
  });
}
