import 'package:chat_gpt_bot/provider/chat_provider.dart';
import 'package:chat_gpt_bot/views/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {

  runApp(ChangeNotifierProvider(
    create: (context) => ChatProvider(),
    child: const MyApp()));
}

class MyApp extends StatelessWidget {


  
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat GPT Bot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ChatScreen( ),
    );
  }
}

