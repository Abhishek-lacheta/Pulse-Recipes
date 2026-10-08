import 'package:equatable/equatable.dart';

abstract class AreasEvent extends Equatable {
  const AreasEvent();

  @override
  List<Object?> get props => [];
}

class AreasFetchEvent extends AreasEvent {
  const AreasFetchEvent();
}
