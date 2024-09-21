import 'package:equatable/equatable.dart';

class RequestMovieList extends Equatable {
  final String type;
  final int page;

  const RequestMovieList(this.type, this.page);

  @override
  List<Object> get props => [type, page];

  @override
  String toString() {
    return 'RequestMovieList{data: $type - $page}';
  }
}