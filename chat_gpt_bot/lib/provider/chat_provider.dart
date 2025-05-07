import 'package:chat_gpt_bot/Model/chat_model.dart';
import 'package:chat_gpt_bot/core/services/Api_service.dart';
import 'package:chat_gpt_bot/widget/textWidget.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> chatList = [];

  List<ChatModel> get getChatList => chatList;

  void addUserMessage(String messag)async {
    try {
      //add user message to the list
      chatList.add(ChatModel(msg: messag, chatIndex: 0));
      //notify the listeners to update the UI
      notifyListeners();
    

    
    } catch (e) {
      print("Error in addUserMessage: $e");
      notifyListeners();
    }
  }
  Future<void> sendMessageGetAnswer(BuildContext context,String message)async{
    try{
        ApiService service = ApiService();
      var response =await service.sendMessagestoGPT(message);
      //add the response from the chat gpt  to the list
      chatList.addAll( response);
      notifyListeners();

    }catch(e){
      print("Error in sendMessageGetAnswer: $e");
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: TextWidget(label: "an error occurred$e"),
          backgroundColor: Colors.black,
          duration: Duration(seconds: 1), // Set the duration to 2 seconds
        ),
      );
    }
  }
}
