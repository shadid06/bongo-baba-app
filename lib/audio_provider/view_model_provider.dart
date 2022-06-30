import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class ViewModelProvider extends ChangeNotifier {
  bool isLoop = false;
  bool isNavProvider = false;
  int globalIndexProvider;
  List<Audio> audioListProvider = [];
  Audio selectedAudioProvider;

  setIsLoop(loop) {
    isLoop = loop;
    notifyListeners();
  }

  setIsNavProvider(nav) {
    isNavProvider = nav;
    notifyListeners();
  }

  setIsGlobalIndexProvider(index) {
    globalIndexProvider = index;
    notifyListeners();
  }

  setAudioProvider(list) {
    audioListProvider = list;
    notifyListeners();
  }

  setSelectedAudioProvider(select) {
    selectedAudioProvider = select;
    notifyListeners();
  }
}
