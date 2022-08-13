import 'dart:convert';
import 'dart:io';

/// Combines tool/defs/*.txt into a dart file: lib/generated/lemmas.dart
///
/// dart run .\tool\txt2dart.dart
///
import 'package:path/path.dart';

final mapper = {
  'stopwords': 'stopwords',
  'adj_exc': 'replaceAdjectives',
  'adv_exc': 'replaceAdverbs',
  'noun_exc': 'replaceNouns',
  'verb_exc': 'replaceVerbs',
  'index_adj': 'keepAdjectives',
  'index_adv': 'keepAdverbs',
  'index_noun': 'keepNouns',
  'index_verb': 'keepVerbs',
};

void main() {
  Map<String, List<String>> result = {};
  Directory('./tool/defs/').listSync().forEach((file) {
    String name = basename(file.path);
    name = name.substring(0, name.lastIndexOf('.'));
    // print(name);
    List<String> words = File(file.path)
        .readAsLinesSync()
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    result.putIfAbsent(mapper[name]!, () => words);
  });

  String out = 'class LemmaHelper {';

  result.forEach((String key, List<String> val) {
    final hasName = 'has' + capitalize(key);
    final getName = 'get' + capitalize(key);
    if (key == 'stopwords' || key.contains('keep')) {
      out += 'static final $key = ${json.encode(val)};';
      out += 'static bool $hasName(word) => $key.contains(word);';
    } else {
      final map = {};
      val.forEach((line) {
        final splits = line.split(RegExp(r'\s+'));
        final range = splits.getRange(1, splits.length).toList();
        map.putIfAbsent(splits[0], () => range);
      });
      out += 'static final $key = ${json.encode(map)};';
      out += 'static bool $hasName(word) => $key.containsKey(word);';
      out += 'static List<String> $getName(word) => $key[word]!;';
    }
  });

  out += '}';

  File('./lib/src/lemmas.dart').writeAsStringSync(out);
}

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
