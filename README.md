# lemmatizerx

Lemmatizer for text in English. Inspired by Python's `nltk.corpus.reader.wordnet.morphy`.

## Installing

In your pubspec.yaml:

```yaml
dependencies:
  lemmatizerx: ^0.0.1
```
## How To Use


```dart
import  'package:lemmatizerx/lemmatizer.dart';

Lemmatizer lemmatizer = Lemmatizer();

//
// Lookup single lemma
//

Lemma lemma = lemmatizer.lemma('books', POS.NOUN);
print(lemma.pos); // POS.NOUN
print(lemma.form); // books
print(lemma.lemmas); // [book]
print(lemma); // POS.NOUN books [book]

lemma = lemmatizer.lemma('loveliest', POS.ADJ);
print(lemma.pos); // POS.ADJ
print(lemma.form); // loveliest
print(lemma.lemmas); // [lovely]
print(lemma); // POS.ADJ loveliest [lovely]

//
// Lookup single lemma and fail
//

lemma = lemmatizer.lemma('wordDoesNotExist', POS.NOUN);
print(lemma.lemmasFound); // false
print(lemma.lemmasNotFound); // true

//
// Lookup multiple lemmas
//

List<Lemma> lemmas = lemmatizer.lemmas('meeting');

print(lemmas); // [POS.NOUN meeting [meeting], POS.VERB meeting [meet]]

Lemma noun = lemmas.firstWhere((lemma) => lemma.pos == POS.NOUN);
Lemma verb = lemmas.firstWhere((lemma) => lemma.pos == POS.VERB);

print(noun.lemmas); // [meeting]
print(verb.lemmas); // [meet]
```
### Powershell 

```ps1
> .\bin\lemma.ps1 meeting

[POS.NOUN meeting [meeting], POS.VERB meeting [meet]]
``` 

### Command line

Activate:

`dart pub global activate lemmatizerx`

Deactivate:

`dart pub global deactivate lemmatizerx`

```ps1
> lemma meeting

[POS.NOUN trees [tree], POS.VERB trees [tree]]
```
## Bugs and Requests

If you encounter any problems feel free to open an issue. If you feel the library is missing a feature, please raise a ticket on Github and I'll look into it. Pull request are also welcome.

https://github.com/xErik/lemmatizerx/issues

## Inspirations and Sources

Lemmatizer: The original package

https://pub.dev/packages/lemmatizer

Stopwords (use their lemma-data, later?)

https://lexically.net/wordsmith/support/lemma_lists.html

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
