import 'package:pdf_view/models/file_model.dart';

abstract class StorageService {
  Future<List<FileModel>> getListFile();
  Future<void> addFile(FileModel file);
}