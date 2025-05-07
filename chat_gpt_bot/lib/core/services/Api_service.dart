import 'dart:convert';
import 'dart:io';
import 'package:chat_gpt_bot/Model/chat_model.dart';
import 'package:chat_gpt_bot/core/utils/api_dummy.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<ChatModel>> sendMessagestoGPT(String message) async {
    try {
      var response = await http.post(
        Uri.parse("$BASE_URL/chat/completions"),
        headers: {
          'Authorization': 'Bearer $Api_Key',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'model': modelId,

          "messages": [
            {'role': 'user', 'content': message},
          ],
        }),
      );
      Map jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }
      List<ChatModel> chatList = [];
      if (jsonResponse['choices'].length > 0) {
        chatList = List.generate(
          jsonResponse["choices"].length,
          (index) => ChatModel(
            msg: jsonResponse["choices"][index]["message"]["content"],
            chatIndex: 1,
          ),
        );
        return chatList;
      } else {
        print("Error Response: ${response.body}");
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}
