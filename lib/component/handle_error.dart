import 'package:flutter/material.dart';

void HandlerError(page,msgErr){
  var pageFrom = page;
  var msgErrs = msgErr;
  var rst = 'ERROR REPORT FROM :$pageFrom, $msgErrs';
  print(rst);
}

class Handlerror{
  final String page;
  final String msgErr; 
  const Handlerror({this.page,this.msgErr ,Key key});

  void reportError(){
    var pageFrom = page;
    var msgErrs = msgErr;
    var rst = 'ERROR REPORT FROM :$pageFrom, $msgErrs';
    print(rst); 
  }
  
}
