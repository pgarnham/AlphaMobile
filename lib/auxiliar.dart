import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SaveContext {
  static BuildContext buildContext;

  void init(BuildContext context) {
    buildContext = context;
  }
}
