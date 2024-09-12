import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  int _currentIndex = 0;
  PageController _pageController = PageController();

  int get currentIndex => _currentIndex;
  PageController get pageController => _pageController;

  void setIndex(int index) {
    _currentIndex = index;
    _pageController.jumpToPage(index);
    notifyListeners();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
