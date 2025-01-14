
import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pdf_view/models/file_model.dart';
import 'package:pdf_view/services/storage_service.dart';

class StorageServiceImpl implements StorageService{
  @override
  Future<List<FileModel>> getListFile()async{
    final storage = FlutterSecureStorage();
    final files = await storage.read(key: 'files');
    if(files !=null) {
      List<FileModel> fileModels = _deserializeFileModelList(files);
      return await _filterExistingFiles(fileModels);
    }else{
    return [];
    }
  }
   //TODO подумать на счет внутри addFile изпользовать getListFile
  @override
  Future<void> addFile(FileModel file) async {
    final storage = FlutterSecureStorage();
    final files = await storage.read(key: 'files');
    if(files != null) {
      List<FileModel> fileModels = _deserializeFileModelList(files);
      fileModels.add(file);
      await storage.write(key: 'files', value: _serializeFileModelList(fileModels));
    }else{
      List<FileModel> fileModels = [file];
      await storage.write(key: 'files', value: _serializeFileModelList(fileModels));
    }
  }

  String _serializeFileModelList(List<FileModel> fileModels) {
    return json.encode(fileModels.map((file) => {
      'path': file.path,
      'name': file.name,
    }).toList());
  }
  List<FileModel> _deserializeFileModelList(String jsonString) {
    try {
      List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((jsonItem) {
        return FileModel(
          path: jsonItem['path'],
          name: jsonItem['name'],
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }
  Future<bool> _fileExists(String path) async {
    final file = File(path);
    return await file.exists();
  }

  Future<List<FileModel>> _filterExistingFiles(List<FileModel> files) async {
    final List<FileModel> filteredFiles = [];

    for (final fileModel in files) {
      final file = File(fileModel.path);
      if (await file.exists()) {
        filteredFiles.add(fileModel);
      }
    }

    return filteredFiles;
  }
}