/*
 * Copyright (c) 2022 Simform Solutions
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
import 'package:chatview3/chatview3.dart';
import 'package:chatview3/src/widgets/chat_list_widget.dart';
import 'package:chatview3/src/widgets/chat_view2_inherited_widget.dart';
import 'package:chatview3/src/widgets/chatview2_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart';
import '../values/custom_time_messages.dart';
import 'send_message_widget.dart';

class ChatView2 extends StatefulWidget {
  const ChatView2({
    Key? key,
    required this.chatController,
    required this.currentUser,
    this.local = "en",
    this.onSendTap,
    this.profileCircleConfig,
    this.chatBubbleConfig,
    this.repliedMessageConfig,
    this.swipeToReplyConfig,
    this.replyPopupConfig,
    this.reactionPopupConfig,
    this.loadMoreData,
    this.loadingWidget,
    this.messageConfig,
    this.isLastPage,
    this.appBar,
    ChatBackgroundConfiguration? chatBackgroundConfig,
    this.typeIndicatorConfig,
    this.sendMessageBuilder,
    this.showTypingIndicator = false,
    this.sendMessageConfig,
    this.onChatListTap,
    required this.chatview2State,
    Chatview2StateConfiguration? chatview2StateConfig,
    this.featureActiveConfig = const FeatureActiveConfig(),
  })  : chatBackgroundConfig =
            chatBackgroundConfig ?? const ChatBackgroundConfiguration(),
        chatview2StateConfig =
            chatview2StateConfig ?? const Chatview2StateConfiguration(),
        super(key: key);

  /// Provides configuration related to user profile circle avatar.
  final ProfileCircleConfiguration? profileCircleConfig;

  final String local;

  /// Provides configurations related to chat bubble such as padding, margin, max
  /// width etc.
  final ChatBubbleConfiguration? chatBubbleConfig;

  /// Allow user to giving customisation different types
  /// messages.
  final MessageConfiguration? messageConfig;

  /// Provides configuration for replied message view which is located upon chat
  /// bubble.
  final RepliedMessageConfiguration? repliedMessageConfig;

  /// Provides configurations related to swipe chat bubble which triggers
  /// when user swipe chat bubble.
  final SwipeToReplyConfiguration? swipeToReplyConfig;

  /// Provides configuration for reply snack bar's appearance and options.
  final ReplyPopupConfiguration? replyPopupConfig;

  /// Provides configuration for reaction pop up appearance.
  final ReactionPopupConfiguration? reactionPopupConfig;

  /// Allow user to give customisation to background of chat
  final ChatBackgroundConfiguration chatBackgroundConfig;

  /// Provides callback when user actions reaches to top and needs to load more
  /// chat
  final VoidCallBackWithFuture? loadMoreData;

  /// Provides widget for loading view while pagination is enabled.
  final Widget? loadingWidget;

  /// Provides flag if there is no more next data left in list.
  final bool? isLastPage;

  /// Provides call back when user tap on send button in text field. It returns
  /// message, reply message and message type.
  final StringMessageCallBack? onSendTap;

  /// Provides builder which helps you to make custom text field and functionality.
  final ReplyMessageWithReturnWidget? sendMessageBuilder;

  @Deprecated('Use [ChatController.setTypingIndicator]  instead')

  /// Allow user to show typing indicator.
  final bool showTypingIndicator;

  /// Allow user to giving customisation typing indicator.
  final TypeIndicatorConfiguration? typeIndicatorConfig;

  /// Provides controller for accessing few function for running chat.
  final ChatController chatController;

  /// Provides configuration of default text field in chat.
  final SendMessageConfiguration? sendMessageConfig;

  /// Provides current state of chat.
  final ChatView2State chatview2State;

  /// Provides configuration for chat view state appearance and functionality.
  final Chatview2StateConfiguration? chatview2StateConfig;

  /// Provides current user which is sending messages.
  final ChatUser currentUser;

  /// Provides configuration for turn on/off specific features.
  final FeatureActiveConfig featureActiveConfig;

  /// Provides parameter so user can assign chatview2Appbar.
  final Widget? appBar;

  /// Provides callback when user tap on chat list.
  final VoidCallBack? onChatListTap;

  @override
  State<ChatView2> createState() => Chatview2State();
}

class Chatview2State extends State<ChatView2>
    with SingleTickerProviderStateMixin {
  final GlobalKey<SendMessageWidgetState> _sendMessageKey = GlobalKey();
  ValueNotifier<ReplyMessage> replyMessage =
      ValueNotifier(const ReplyMessage());

  ChatController get chatController => widget.chatController;

  // bool get showTypingIndicator => widget.showTypingIndicator;

  ChatBackgroundConfiguration get chatBackgroundConfig =>
      widget.chatBackgroundConfig;

  ChatView2State get chatview2State => widget.chatview2State;

  Chatview2StateConfiguration? get chatview2StateConfig =>
      widget.chatview2StateConfig;

  FeatureActiveConfig get featureActiveConfig => widget.featureActiveConfig;

  @override
  void initState() {
    super.initState();
    setLocaleMessages('en', ReceiptsCustomMessages());
    // Adds current user in users list.
    chatController.chatUsers.add(widget.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    // Scroll to last message on in hasMessages state.
    // ignore: deprecated_member_use_from_same_package
    if (widget.showTypingIndicator ||
        widget.chatController.showTypingIndicator &&
            chatview2State.hasMessages) {
      chatController.scrollToLastMessage();
    }
    return Chatview2InheritedWidget(
      chatController: chatController,
      featureActiveConfig: featureActiveConfig,
      currentUser: widget.currentUser,
      child: Container(
        height:
            chatBackgroundConfig.height ?? MediaQuery.of(context).size.height,
        width: chatBackgroundConfig.width ?? MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: chatBackgroundConfig.backgroundColor ?? Colors.white,
          image: chatBackgroundConfig.backgroundImage != null
              ? DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(chatBackgroundConfig.backgroundImage!),
                )
              : null,
        ),
        padding: chatBackgroundConfig.padding,
        margin: chatBackgroundConfig.margin,
        child: Column(
          children: [
            if (widget.appBar != null) widget.appBar!,
            Expanded(
              child: Stack(
                children: [
                  if (chatview2State.isLoading)
                    Chatview2StateWidget(
                      chatview2StateWidgetConfig:
                          chatview2StateConfig?.loadingWidgetConfig,
                      chatview2State: chatview2State,
                    )
                  else if (chatview2State.noMessages)
                    Chatview2StateWidget(
                      chatview2StateWidgetConfig:
                          chatview2StateConfig?.noMessageWidgetConfig,
                      chatview2State: chatview2State,
                      onReloadButtonTap:
                          chatview2StateConfig?.onReloadButtonTap,
                    )
                  else if (chatview2State.isError)
                    Chatview2StateWidget(
                      chatview2StateWidgetConfig:
                          chatview2StateConfig?.errorWidgetConfig,
                      chatview2State: chatview2State,
                      onReloadButtonTap:
                          chatview2StateConfig?.onReloadButtonTap,
                    )
                  else if (chatview2State.hasMessages)
                    ValueListenableBuilder<ReplyMessage>(
                      valueListenable: replyMessage,
                      builder: (_, state, child) {
                        return ChatListWidget(
                          // ignore: deprecated_member_use_from_same_package
                          showTypingIndicator: widget.showTypingIndicator,
                          local: widget.local == "en" ? "en_US" : "ar_SA",
                          replyMessage: state,
                          chatController: widget.chatController,
                          chatBackgroundConfig: widget.chatBackgroundConfig,
                          reactionPopupConfig: widget.reactionPopupConfig,
                          typeIndicatorConfig: widget.typeIndicatorConfig,
                          chatBubbleConfig: widget.chatBubbleConfig,
                          loadMoreData: widget.loadMoreData,
                          isLastPage: widget.isLastPage,
                          replyPopupConfig: widget.replyPopupConfig,
                          loadingWidget: widget.loadingWidget,
                          messageConfig: widget.messageConfig,
                          profileCircleConfig: widget.profileCircleConfig,
                          repliedMessageConfig: widget.repliedMessageConfig,
                          swipeToReplyConfig: widget.swipeToReplyConfig,
                          onChatListTap: widget.onChatListTap,
                          assignReplyMessage: (message) => _sendMessageKey
                              .currentState
                              ?.assignReplyMessage(message),
                        );
                      },
                    ),
                  if (featureActiveConfig.enableTextField)
                    SendMessageWidget(
                      key: _sendMessageKey,
                      chatController: chatController,
                      sendMessageBuilder: widget.sendMessageBuilder,
                      sendMessageConfig: widget.sendMessageConfig,
                      backgroundColor: chatBackgroundConfig.backgroundColor,
                      onSendTap: _onSendTap,
                      onReplyCallback: (reply) => replyMessage.value = reply,
                      onReplyCloseCallback: () =>
                          replyMessage.value = const ReplyMessage(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSendTap(
    String message,
    ReplyMessage replyMessage,
    MessageType messageType,
  ) {
    if (widget.sendMessageBuilder == null) {
      if (widget.onSendTap != null) {
        widget.onSendTap!(message, replyMessage, messageType);
      }
      _assignReplyMessage();
    }
    chatController.scrollToLastMessage();
  }

  void _assignReplyMessage() {
    if (replyMessage.value.message.isNotEmpty) {
      replyMessage.value = const ReplyMessage();
    }
  }

  @override
  void dispose() {
    replyMessage.dispose();
    super.dispose();
  }
}
