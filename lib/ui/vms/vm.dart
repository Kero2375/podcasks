import 'dart:developer';

import 'package:flutter/material.dart';

enum UiState { loading, error, success }

class Vm extends ChangeNotifier {
  UiState state = UiState.success;

  success() {
    state = UiState.success;
    try {
      notifyListeners();
    } catch(e) {
      log("cannot notify listeners: $e");
    }
  }

  error() {
    state = UiState.error;
    try {
      notifyListeners();
    } catch(e) {
      log("cannot notify listeners: $e");
    }
  }

  loading() {
    state = UiState.loading;
    try {
      notifyListeners();
    } catch(e) {
      log("cannot notify listeners: $e");
    }
  }

  update() {
    try {
      notifyListeners();
    } catch(e) {
      log("cannot notify listeners: $e");
    }
  }
}
