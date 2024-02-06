import 'package:flutter/material.dart';
import 'package:chatview3/chatview3.dart';

/// This widget for alternative of excessive amount of passing arguments
/// over widgets.
class Chatview2InheritedWidget extends InheritedWidget {
  const Chatview2InheritedWidget({
    Key? key,
    required Widget child,
    required this.featureActiveConfig,
    required this.chatController,
    required this.currentUser,
  }) : super(key: key, child: child);
  final FeatureActiveConfig featureActiveConfig;
  final ChatController chatController;
  final ChatUser currentUser;

  static Chatview2InheritedWidget? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Chatview2InheritedWidget>();

  @override
  bool updateShouldNotify(covariant Chatview2InheritedWidget oldWidget) =>
      oldWidget.featureActiveConfig != featureActiveConfig;
}
