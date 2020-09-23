import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  NumberTriviaModel(String text, int number) : super(text, number);

  factory NumberTriviaModel.fromeJson(Map<String, dynamic> json) {
    return NumberTriviaModel(json['text'], (json['number'] as num).toInt());
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'number': number};
  }
}
