// import 'dart:ffi';
// import 'dart:html';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:chatbot_and_image_generator/colors.dart';
import 'package:chatbot_and_image_generator/feature_box.dart';
import 'package:chatbot_and_image_generator/open_ai_service.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:animate_do/animate_do.dart';

class Homepage extends StatefulWidget {
  Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int start = 200;
  int delay = 200;
  String? generated_img_url;
  String? generated_content;
  final FlutterTts flutterTts = FlutterTts();
  final OpenAi_service openAi_service = OpenAi_service();
  // String output = '';
  bool listen_start = false;
  SpeechToText speechToText = SpeechToText();
  // bool speechEnabled = false;
  String lastWords = '';

  @override
  void initState() {
    super.initState();
    initSpeech_to_text();
  }

  Future<void> initText_to_speech(String content) async {
    // await flutterTts.setSharedInstance(true);
    await flutterTts.setLanguage('en-US');
    await flutterTts.speak(content);
    setState(() {});
  }

  /// This has to happen only once per app
  Future<void> initSpeech_to_text() async {
    await speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    // print(output);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
      // print(lastWords);
    });
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(child: Text("Assistant")),
        centerTitle: true,
        leading: Icon(Icons.menu),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: ZoomIn(
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                          color: My_Colors.assistantCircleColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 110,
                        height: 110,
                        margin: EdgeInsets.only(top: 0.0),
                        decoration: BoxDecoration(
                            color: My_Colors.assistantCircleColor,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/virtualAssistant.png'))),
                      )
                    ],
                  ),
                ),
              ),
              FadeInRight(
                child: Visibility(
                  visible: generated_img_url == null,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    margin:
                        EdgeInsets.symmetric(horizontal: 20).copyWith(top: 30),
                    decoration: BoxDecoration(
                        border: Border.all(color: My_Colors.borderColor),
                        borderRadius: BorderRadius.circular(20)
                            .copyWith(topLeft: Radius.zero)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                          generated_content == null
                              ? "What can I do for you?"
                              : generated_content!,
                          style: TextStyle(
                              color: My_Colors.mainFontColor,
                              fontFamily: 'Cera-pro',
                              fontSize: generated_content == null ? 25 : 16)),
                    ),
                  ),
                ),
              ),
              if (generated_img_url != null)
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.network(generated_img_url!)),
                ),
              Visibility(
                visible: generated_content == null && generated_img_url == null,
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 10.0, left: 22.0),
                  child: Text("Here are few feature:-",
                      style: TextStyle(
                          fontFamily: 'Cera-pro',
                          color: My_Colors.mainFontColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              Visibility(
                visible: generated_content == null && generated_img_url == null,
                child: Column(
                  children: [
                    FadeInLeft(
                      delay: Duration(milliseconds: start),
                      child: Feature_box(
                        color: Colors.cyan.shade300,
                        header_text: "Chatgpt",
                        desc_text:
                            "a smarter way to stay orginied and informed with chatgpt",
                      ),
                    ),
                    FadeInLeft(
                      delay: Duration(milliseconds: start + delay),
                      child: Feature_box(
                        color: Colors.blueAccent,
                        header_text: "Dall-E",
                        desc_text:
                            "Get inspired and stay creative with your personal assistant powered bye DAll-E",
                      ),
                    ),
                    FadeInLeft(
                      delay: Duration(milliseconds: delay * 3),
                      child: Feature_box(
                        color: Colors.orangeAccent,
                        header_text: "Smart Voice Assistant",
                        desc_text:
                            "Get the best of both worlds with a voice assistant powered by Dall-E      and Chatgpt",
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: ZoomIn(
        delay: Duration(milliseconds: delay * 4),
        child: FloatingActionButton(
            backgroundColor: Colors.cyan.shade400,
            onPressed: () async {
              setState(() {
                listen_start = !listen_start;
              });
              if (await speechToText.hasPermission &&
                  speechToText.isNotListening) {
                await startListening();
              } else if (speechToText.isListening) {
                final speech = await openAi_service.is_prompt_api(lastWords);
                if (speech.contains('https')) {
                  generated_img_url = speech;
                  generated_content = null;
                  setState(() {});
                } else {
                  generated_img_url = null;
                  generated_content = speech;
                  setState(() {});
                }
                await initText_to_speech(speech.toString());
                await stopListening();
              } else {
                initSpeech_to_text();
              }
            },
            child: Icon(speechToText.isListening
                ? Icons.pause_rounded
                : Icons.mic_rounded)),
      ),
    );
  }
}
