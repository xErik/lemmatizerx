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
import  'package:lemmatizerx/lemmatizerx.dart';

Lemmatizer lemmatizer = Lemmatizer();

//
// Lookup single lemma
//

Lemma lemma = lemmatizer.lemma('books', POS.NOUN);
print(lemma.pos); // POS.NOUN
print(lemma.form); // book
print(lemma.lemmas); // [book]
print(lemma); // POS.NOUN book [book]

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

Lemma noun = lemmas.firstWhere((lemma) => lemma.pos == POS.NOUN);
Lemma verb = lemmas.firstWhere((lemma) => lemma.pos == POS.VERB);

print(noun.lemmas); // [meeting]
print(verb.lemmas); // [meet]
```

## Inspirations and Sources

Lemmatizer: The original package

https://pub.dev/packages/lemmatizer

Stopwords (use their lemma-data, later?)

https://lexically.net/wordsmith/support/lemma_lists.html

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
