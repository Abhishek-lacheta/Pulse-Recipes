import 'package:equatable/equatable.dart';
import '../../../data/models/area/area_model.dart';

abstract class AreasState extends Equatable {
  const AreasState();

  @override
  List<Object?> get props => [];
}

class AreasInitial extends AreasState {
  const AreasInitial();
}

class AreasLoading extends AreasState {
  const AreasLoading();
}

class AreasSuccess extends AreasState {
  const AreasSuccess(this.areas);

  final List<AreaModel> areas;

  @override
  List<Object?> get props => [areas];
}

class AreasFailure extends AreasState {
  const AreasFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
