import 'package:chatview3/chatview3.dart';
import 'package:chatview3/src/extensions/extensions.dart';
import 'package:flutter/material.dart';

class Chatview2StateWidget extends StatelessWidget {
  const Chatview2StateWidget({
    super.key,
    this.chatview2StateWidgetConfig,
    required this.chatview2State,
    this.onReloadButtonTap,
  });

  /// Provides configuration of chat view's different states such as text styles,
  /// widgets and etc.
  final ChatView2StateWidgetConfiguration? chatview2StateWidgetConfig;

  /// Provides current state of chat view.
  final ChatView2State chatview2State;

  /// Provides callback when user taps on reload button in error and no messages
  /// state.
  final VoidCallBack? onReloadButtonTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: chatview2StateWidgetConfig?.widget ??
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                (chatview2StateWidgetConfig?.title
                    .getChatview2StateTitle(chatview2State))!,
                style: chatview2StateWidgetConfig?.titleTextStyle ??
                    const TextStyle(
                      fontSize: 22,
                    ),
              ),
              if (chatview2StateWidgetConfig?.subTitle != null)
                Text(
                  (chatview2StateWidgetConfig?.subTitle)!,
                  style: chatview2StateWidgetConfig?.subTitleTextStyle,
                ),
              if (chatview2State.isLoading)
                CircularProgressIndicator(
                  color: chatview2StateWidgetConfig?.loadingIndicatorColor,
                ),
              if (chatview2StateWidgetConfig?.imageWidget != null)
                (chatview2StateWidgetConfig?.imageWidget)!,
              if (chatview2StateWidgetConfig?.reloadButton != null)
                (chatview2StateWidgetConfig?.reloadButton)!,
              if (chatview2StateWidgetConfig != null &&
                  (chatview2StateWidgetConfig?.showDefaultReloadButton)! &&
                  chatview2StateWidgetConfig?.reloadButton == null &&
                  (chatview2State.isError || chatview2State.noMessages)) ...[
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: onReloadButtonTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        chatview2StateWidgetConfig?.reloadButtonColor ??
                            const Color(0xffEE5366),
                  ),
                  child: const Text('Reload'),
                )
              ]
            ],
          ),
    );
  }
}
