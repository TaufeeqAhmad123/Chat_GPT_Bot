import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_gpt_bot/core/utils/const.dart';
import 'package:chat_gpt_bot/provider/chat_provider.dart';
import 'package:chat_gpt_bot/widget/chatWidget.dart';
import 'package:chat_gpt_bot/widget/textWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;

  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final ScrollController _scrollController;
  @override
  @override
  void initState() {
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _scrollController = ScrollController();
    super.initState();
  }

  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: scaffoldBackgroundColor,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/chat-gpt.png'),
        ),
        title: const Text(
          "Gpt-Bot",
          style: TextStyle(
            letterSpacing: 3,
            color: Colors.white70,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert_rounded,
              color: Colors.white70,
              size: 31,
            ),
          ),
        ],
      ),
      backgroundColor: scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Image.asset('assets/chat.jpg')
            chatProvider.chatList.isEmpty ? const Spacer() : const SizedBox(),
            chatProvider.chatList.isEmpty
                ? SizedBox(
                    height: 70,
                    child: DefaultTextStyle(
                      style: GoogleFonts.kanit(
                        color: Colors.amber[400],
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                      child: AnimatedTextKit(
                        isRepeatingAnimation: false,
                        repeatForever: false,
                        displayFullTextOnTap: true,
                        totalRepeatCount: 1,
                        animatedTexts: [
                          TyperAnimatedText(
                            "Welcome to Gpt-Bot \n How can I help you ?",
                          ),
                        ],
                      ),
                    ),
                  )
                : Flexible(
                    child: ListView.builder(
                      itemCount: chatProvider.chatList.length,
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        return chatWidget(
                          chatProvider: chatProvider,
                          chatIndex: chatProvider.getChatList[index].chatIndex,
                          msg: chatProvider.getChatList[index].msg,
                          shouldAnimate:
                              chatProvider.getChatList.length - 1 == index,
                        );
                      },
                    ),
                  ),
            if (_isTyping) ...[
              SpinKitThreeBounce(color: Colors.amber[300], size: 40),
            ],
            chatProvider.chatList.isEmpty ? const Spacer() : const SizedBox(),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 21),
              child: Row(
                children: [
                  Expanded(
                    child: Material(
                      borderRadius: BorderRadius.circular(45),
                      color: Colors.amber[200],
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 22,
                                vertical: 14,
                              ),
                              child: TextField(
                                focusNode: _focusNode,
                                style: GoogleFonts.kanit(
                                  fontSize: 19,
                                  color: Colors.black,
                                ),
                                controller: _controller,
                                onSubmitted: (value) async {
                                  await sendMessage(chatProvider);
                                },
                                decoration: InputDecoration.collapsed(
                                  hintText: "How can I help you ?",
                                  hintStyle: GoogleFonts.kanit(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[900],
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 13),
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: Colors.grey[800],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: IconButton(
                        onPressed: () async {
                          await sendMessage(chatProvider);
                        },
                        icon: const Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scrollListToEND() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut,
    );
  }

  Future<void> sendMessage(ChatProvider provider) async {
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "You cant send multiple messages at a time",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(label: "Please type a message"),
          backgroundColor: Colors.black,
          duration: Duration(seconds: 1), // Set the duration to 2 seconds
        ),
      );
      return;
    }
    try {
      String msg = _controller.text.trim();
      setState(() {
        _isTyping = true;
        provider.addUserMessage(msg);
        //_controller.clear();
        _focusNode.unfocus();
      });
      await provider.sendMessageGetAnswer(context, msg);
      _controller.clear();
      setState(() {});
    } catch (e) {
      log("error $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidget(label: e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        scrollListToEND();
        _isTyping = false;
      });
    }
  }
}
