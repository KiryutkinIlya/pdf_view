import 'package:bloc/bloc.dart';
import 'package:pdf_view/models/file_model.dart';
import 'package:pdf_view/services/storage_service_impl.dart';
import 'main_page_event.dart';
import 'main_page_state.dart';
import 'package:collection/collection.dart';
class MainPageBloc extends Bloc<FileEvent, FileState> {


  MainPageBloc() : super(FileInitialState()) {
    on<FileOpenedOutDeviceEvent>((event, emit) async {
      emit(FileOpenedLoadingState());

      emit(FileOpenedState(event.file.path));
      List<FileModel> files = await StorageServiceImpl().getListFile();
      final temp = files.firstWhereOrNull((element) => element.path == event.file.path);
      if(temp == null) {
        await StorageServiceImpl().addFile(event.file);
        files = await StorageServiceImpl().getListFile();
      }
      emit(FileLoadedResentState(files: files));

    });

    on<FileGetRecentEvent>((event, emit) async {
      emit(FileOpenedLoadingState());
      List<FileModel> files = await StorageServiceImpl().getListFile();
      emit(FileLoadedResentState(files: files));
    });

    on<FileOpenedInDeviceEvent>((event, emit) async {
      emit(FileOpenedState(event.file.path));
    });

    on<FileResetEvent>((event, emit) {
      emit(FileInitialState());
    });
  }
}