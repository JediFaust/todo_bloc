import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool completed;
  final bool cancelled;

  const Todo({
    required this.id,
    required this.title,
    required this.description,
    this.completed = false,
    this.cancelled = false,
  });

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? completed,
    bool? cancelled,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      cancelled: cancelled ?? this.cancelled,
    );
  }

  @override
  List<Object?> get props => [id, title, description, completed, cancelled];

  @override
  String toString() {
    return 'Todo { id: $id, title: $title, description: $description, completed: $completed, cancelled: $cancelled }';
  }
}
