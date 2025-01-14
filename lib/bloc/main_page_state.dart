import 'package:equatable/equatable.dart';
import 'package:pdf_view/models/file_model.dart';

abstract class FileState extends Equatable {
  const FileState();

  @override
  List<Object?> get props => [];
}

// Начальное состояние
class FileInitialState extends FileState {}

// Состояние, когда файл открыт
class FileOpenedState extends FileState {
  final String filePath;

  const FileOpenedState(this.filePath);

  @override
  List<Object?> get props => [filePath];
}
class FileOpenedLoadingState extends FileState {


  const FileOpenedLoadingState();

  @override
  List<Object?> get props => [];
}
class FileLoadedResentState extends FileState {
  final List<FileModel> files;
  const FileLoadedResentState({required this.files});

  @override
  List<Object?> get props => [files];
}