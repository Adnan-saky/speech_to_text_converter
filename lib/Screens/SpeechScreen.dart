import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:translator/translator.dart';

import '../Widgets/Widgets.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({Key? key}) : super(key: key);

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  stt.SpeechToText? _speechToText;
  bool _isListening = false;
  String _text = "";

  void listen() async {
    if (!_isListening) {
      bool available = await _speechToText!.initialize(
        onStatus: (val) => print("on Status: $val"),
        onError: (val) => print("on Error : $val"),
      );
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speechToText!.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() {
        _isListening = false;
      });
      _speechToText!.stop();
    }
  }

  /// --------------------------     Translator   --------------------------------------

  GoogleTranslator translator = GoogleTranslator();
  String? _translatedText ;

  translate(){
    translator.translate(_text, to: "bn").then((output){
      setState((){
        _translatedText = output.toString();
      });
    });
  }
  @override
  void initState() {
    _speechToText = stt.SpeechToText();
    _translatedText = "";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Voice Translator"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Colors.blue,
        duration: const Duration(milliseconds: 1000),
        repeat: true,
        repeatPauseDuration: const Duration(milliseconds: 200),
        endRadius: 75.0,
        child: FloatingActionButton(
          onPressed: listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_off_rounded),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Speech To Text",
              style: TextStyle(
                  fontSize: 32,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: CustomContainer(
              widget: SingleChildScrollView(
                reverse: true,
                child: SelectableText(
                  _text,
                  showCursor: false,
                  toolbarOptions: const ToolbarOptions(
                      copy: true,
                      selectAll: true,
                      cut: false,
                      paste: false
                  ),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: translate,
              child: const Text("Translate to Bengali "),
            ),
          ),
          Center(
            child: CustomContainer(
              widget:  SingleChildScrollView(
                reverse: true,
                child: Text(
                  _translatedText!,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
