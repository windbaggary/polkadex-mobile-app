import 'package:equatable/equatable.dart';

class EncodingEntity extends Equatable {
  const EncodingEntity({
    required this.content,
    required this.type,
    required this.version,
  });

  final List<String> content;
  final List<String> type;
  final String version;

  @override
  List<Object> get props => [
        content,
        type,
        version,
      ];
}
