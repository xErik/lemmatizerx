import 'dart:io';

import 'package:lemmatizerx/lemmatizerx.dart';

main(List<String> args) {
  if (args.isEmpty) {
    print('USAGE: dart run cmd <WORD>');
    exit(0);
  }
  Lemmatizer l = Lemmatizer();
  print(l.lemmas(args.elementAt(0)));
}
