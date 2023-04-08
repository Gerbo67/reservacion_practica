import 'package:flutter/material.dart';

class LoadingWidgetController {
  LoadingWidgetController._();

  static final LoadingWidgetController instance = LoadingWidgetController._();
  static final LoadingWidgetController machInstance =
      LoadingWidgetController._();

  ValueNotifier<bool> loadingNotifier = ValueNotifier<bool>(false);

  bool loadingValue() => loadingNotifier.value;

  void loading() {
    loadingNotifier.value = true;
  }

  void close() {
    loadingNotifier.value = false;
  }

  void clear() {
    close();
  }
}
