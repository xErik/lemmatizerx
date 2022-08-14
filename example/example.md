```dart
import  'package:lemmatizerx/lemmatizerx.dart';

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