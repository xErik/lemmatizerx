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