import 'package:equatable/equatable.dart';

class MetaEntity extends Equatable {
  const MetaEntity({
    this.name,
  });

  final String? name;

  @override
  List<Object?> get props => [name];
}
