import 'package:equatable/equatable.dart';

import '../models/file_model.dart';

abstract class FileEvent extends Equatable {
  const FileEvent();

  @override
  List<Object?> get props => [];
}

// Событие для обработки открытого файла
class FileOpenedOutDeviceEvent extends FileEvent {
  final FileModel file;

  const FileOpenedOutDeviceEvent({required this.file});

  @override
  List<Object?> get props => [file];
}

class FileGetRecentEvent extends FileEvent {
  const FileGetRecentEvent();
  @override
  List<Object?> get props => [];
}

class FileOpenedInDeviceEvent extends FileEvent {
  final FileModel file;

  const FileOpenedInDeviceEvent({required this.file});

  @override
  List<Object?> get props => [file];
}

// Событие для сброса состояния
class FileResetEvent extends FileEvent {}