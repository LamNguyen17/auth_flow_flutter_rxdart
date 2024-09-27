import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

const List<dynamic> mocks = [
  ParamsMock(
    path: '/api/employee/notifications',
    data: 'lib/data/mock/getNotifications.json',
    enable: false,
  ),
];

class ApiMock {
  bool isMockEnabled(String path) {
    var filteredMocks = mocks.where((x) => x.path == path).toList();
    debugPrint('getNotifications_3: $filteredMocks');
    return filteredMocks.isNotEmpty && filteredMocks[0]?.enable;
  }

  ParamsMock mockData(String path) {
    var filteredMocks = mocks.where((x) => x.path == path).toList();
    return filteredMocks[0];
  }
}

class ParamsMock extends Equatable {
  final String path;
  final dynamic data;
  final bool enable;

  const ParamsMock({
    required this.path,
    required this.data,
    required this.enable,
  });

  @override
  List<Object?> get props => [path, data, enable];
}