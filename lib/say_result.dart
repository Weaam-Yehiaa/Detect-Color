import 'package:flutter_tts/flutter_tts.dart';

Future<void> sayResult( text)
async {
  FlutterTts ftts = FlutterTts();
//your custom configuration
  await ftts.setLanguage("en-US");
  await ftts.setSpeechRate(0.5); //speed of speech
  await ftts.setVolume(1.0); //volume of speech
  await ftts.setPitch(1); //pitc of sound

  //play text to sp
  var result = await ftts.speak(text);
  if(result == 1){
    //speaking
  }else{
    //not speaking
  }

}