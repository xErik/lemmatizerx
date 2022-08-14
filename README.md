# lemmatizerx

Lemmatizer for text in English. Inspired by Python's `nltk.corpus.reader.wordnet.morphy`.

For now, it is advisable to check the quality of the results when relying on this API.

Pull requests welcome.

## Installing

In your pubspec.yaml:

```yaml
dependencies:
  lemmatizerx: ^0.0.1
```
## Usage


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

## Inspirations and Sources

Lemmatizer: The original package

https://pub.dev/packages/lemmatizer

Stopwords (use their lemma-data, later?)

https://lexically.net/wordsmith/support/lemma_lists.html

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
