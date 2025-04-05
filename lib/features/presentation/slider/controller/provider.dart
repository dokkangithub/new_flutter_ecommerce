import 'package:flutter/material.dart';
import '../../../../features/domain/slider/usecases/get_sliders_use_case.dart';
import '../../../data/slider/model/slider_model.dart';

enum SliderLoadingState { initial, loading, loaded, error }

class SliderProvider extends ChangeNotifier {
  final GetSlidersUseCase getSlidersUseCase;

  SliderLoadingState slidersState = SliderLoadingState.initial;
  SliderResponseModel? slidersResponse;
  String? errorMessage;

  SliderProvider({
    required this.getSlidersUseCase,
  });

  Future<void> getSliders() async {
    slidersState = SliderLoadingState.loading;
    notifyListeners();

    try {
      slidersResponse = await getSlidersUseCase();
      slidersState = SliderLoadingState.loaded;
    } catch (e) {
      slidersState = SliderLoadingState.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }
}
