import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:audio_experiments/language.dart';



class VoiceTextHome extends StatefulWidget {


  @override
  VoiceTextHomeState createState() {
    return new VoiceTextHomeState();
  }
}

class VoiceTextHomeState extends State<VoiceTextHome> {
  SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;

  String transcription = '';

  //String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_MyAppState.activateSpeechRecognizer... ');
    _speech = new SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setCurrentLocaleHandler(onCurrentLocale);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech
        .activate()
        .then((res) => setState(() => _speechRecognitionAvailable = res));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        actions: [
          new PopupMenuButton<Language>(
            onSelected: _selectLangHandler,
            itemBuilder: (BuildContext context) => _buildLanguagesWidgets,
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[

                FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.purple,
                  child: Icon(Icons.cancel, size: 24.0, color: Colors.purpleAccent,),
                  onPressed: (){
                    if( _isListening)
                      cancel();
                    else
                      null;
                  },
                ),
                SizedBox(width: 10.0,),
                FloatingActionButton(
                  backgroundColor: Colors.purple,
                  child: Icon(Icons.mic, size: 40.0,),
                  onPressed: (){
                    if( _speechRecognitionAvailable && !_isListening)
                      start();
                    else
                      null;
                  },
                ),
                SizedBox(width: 10.0,),
                FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.purple,
                  child: Icon(Icons.stop, size: 24.0, color: Colors.purpleAccent,),
                  onPressed: (){
                    if( _isListening)
                      stop();
                    else
                      null;
                  },
                ),
              ],
            ),

            SizedBox(height: 20.0,),
            Container(
                width: MediaQuery.of(context).size.width*0.7,
                decoration: new BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: new BorderRadius.circular(5.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 15.0),
                child: Text(transcription))
          ],
        ),
      ),
    );
  }


  List<CheckedPopupMenuItem<Language>> get _buildLanguagesWidgets => languages
      .map((l) => new CheckedPopupMenuItem<Language>(
    value: l,
    checked: selectedLang == l,
    child: new Text(l.name),
  ))
      .toList();

  void _selectLangHandler(Language lang) {
    setState(() => selectedLang = lang);
  }

  Widget _buildButton({String label, VoidCallback onPressed}) => new Padding(
      padding: new EdgeInsets.all(12.0),
      child: new RaisedButton(
        color: Colors.cyan.shade600,
        onPressed: onPressed,
        child: new Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ));

  void start() => _speech
      .listen(locale: selectedLang.code)
      .then((result) => print('_MyAppState.start => result $result'));

  void cancel() =>
      _speech.cancel().then((result) => setState(() => _isListening = result));

  void stop() =>
      _speech.stop().then((result) => setState(() => _isListening = result));

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  void onCurrentLocale(String locale) {
    print('_MyAppState.onCurrentLocale... $locale');
    setState(
            () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() => setState(() => _isListening = true);

  void onRecognitionResult(String text) => setState(() => transcription = text);

  void onRecognitionComplete() => setState(() => _isListening = false);
}
