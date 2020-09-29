part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  final _props = [];
  NumberTriviaEvent([List props = const <dynamic>[]]){
    _props.add(props);
  }

  @override
  List<Object> get props => _props;
}

class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  final String numberString;

  GetTriviaForConcreteNumber(this.numberString) : super([numberString]);
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {}
