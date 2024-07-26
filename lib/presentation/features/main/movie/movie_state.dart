import 'package:equatable/equatable.dart';

abstract class MovieStatus extends Equatable {
  const MovieStatus();

  @override
  List<Object> get props => [];
}

class MovieInitial extends MovieStatus {
  const MovieInitial();
}

class MovieLoding extends MovieStatus {
  const MovieLoding();
}

class MovieSuccess extends MovieStatus {
  final dynamic data;
  const MovieSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class MovieError extends MovieStatus {
  final String message;

  const MovieError(this.message);

  @override
  List<Object> get props => [message];
}
