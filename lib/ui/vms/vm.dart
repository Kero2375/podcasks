import 'package:flutter/material.dart';

enum UiState { loading, error, success }

class Vm extends ChangeNotifier {
  UiState state = UiState.success;

  success() {
    state = UiState.success;
    notifyListeners();
  }

  error() {
    state = UiState.error;
    notifyListeners();
  }

  loading() {
    state = UiState.loading;
    notifyListeners();
  }
}
