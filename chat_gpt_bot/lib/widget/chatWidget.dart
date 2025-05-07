import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_gpt_bot/core/utils/const.dart';
import 'package:chat_gpt_bot/provider/chat_provider.dart';
import 'package:chat_gpt_bot/widget/textWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class chatWidget extends StatelessWidget {
  final int chatIndex;
  final String msg;
  final bool shouldAnimate;
  const chatWidget({
    super.key,
    required this.chatProvider,
    required this.chatIndex,
    required this.msg,
    required this.shouldAnimate,
  });

  final ChatProvider chatProvider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: chatIndex == 0 ? scaffoldBackgroundColor : Colors.white,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            margin: EdgeInsets.only(left: chatIndex != 0 ? 70 : 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                     margin:  EdgeInsets.only(top: chatIndex==0 ? 0 : 10,),
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: chatIndex == 0
                        ? Colors.white.withOpacity(0.5)
                        : Colors.white,
                        backgroundImage: AssetImage(
                      chatIndex == 0 ? 'assets/user1.jpg' : 'assets/robo.jpg',
                     
                    ),
                    
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: chatIndex == 0
                      ? TextWidget(label: msg)
                      : shouldAnimate
                      ? DefaultTextStyle(
                          style: GoogleFonts.kanit(
                            color: Colors.grey[900],
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                          child: AnimatedTextKit(
                            isRepeatingAnimation: false,
                            repeatForever: false,
                            displayFullTextOnTap: true,
                            totalRepeatCount: 1,
                            animatedTexts: [TyperAnimatedText(msg.trim())],
                          ),
                        )
                      : Text(
                          msg.trim(),
                          style: GoogleFonts.kanit(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 19,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
