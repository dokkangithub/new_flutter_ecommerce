import '../../../domain/slider/repositories/slider_repository.dart';
import '../datasources/slider_remote_datasource.dart';
import '../model/slider_model.dart';

class SliderRepositoryImpl implements SliderRepository {
  final SliderRemoteDataSource sliderRemoteDataSource;

  SliderRepositoryImpl(this.sliderRemoteDataSource);

  @override
  Future<SliderResponseModel> getSliders() async {
    return await sliderRemoteDataSource.getSliders();
  }
}