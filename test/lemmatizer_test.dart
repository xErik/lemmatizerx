import 'package:lemmatizerx/lemmatizerx.dart';
import 'package:test/test.dart';

void main() {
  var l = Lemmatizer();

  test('meeting: noun and verb', () {
    List<Lemma> lemmas = l.lemmas('meeting');
    var noun = lemmas.firstWhere((lemma) => lemma.pos == POS.NOUN);
    var verb = lemmas.firstWhere((lemma) => lemma.pos == POS.VERB);
    expect(noun.lemmas.contains('meeting'), true);
    expect(verb.lemmas.contains('meet'), true);
    expect(verb.form, 'meeting');
  });

  test('feet: noun', () {
    expect(l.lemma('feet', POS.NOUN).lemmas.contains('foot'), true);
    expect(l.lemma('feet', POS.NOUN).pos == POS.NOUN, true);
    expect(l.lemma('feet', POS.NOUN).form, 'feet');
  });

  test('feet: adjective', () {
    expect(l.lemma('bendier', POS.ADJ).lemmas.contains('bendy'), true);
  });

  test('dogs', () {
    expect(l.lemmas('dogs').first.lemmas.contains('dog'), true);
  });

  test('churches', () {
    expect(l.lemmas('churches').first.lemmas.contains('church'), true);
  });

  test('aardwolves', () {
    expect(l.lemmas('aardwolves').first.lemmas.contains('aardwolf'), true);
  });

  test('abaci', () {
    expect(l.lemmas('abaci').first.lemmas.contains('abacus'), true);
  });

  test('hardrock', () {
    expect(l.lemma('hardrock', POS.ADV).lemmas.contains('hardrock'), false);
  });

  test('book: noun, verb, adjective', () {
    expect(l.lemma('book', POS.NOUN).lemmas.contains('book'), true);
    expect(l.lemma('book', POS.VERB).lemmas.contains('book'), true);
    expect(l.lemma('book', POS.ADJ).lemmas.contains('book'), false);
  });

  test('flirtatiously: adverb', () {
    expect(l.lemma('flirtatiously', POS.ADV).lemmas.contains('flirtatiously'),
        true);
  });

  test('hardest: adverb, adjective', () {
    expect(l.lemma('hardest', POS.ADV).lemmas.contains('hard'), true);
    expect(l.lemma('hardest', POS.ADJ).lemmas.contains('hard'), true);
  });

  test('studies: noun verb', () {
    expect(l.lemma('studies', POS.VERB).lemmas.contains('study'), true);
    expect(l.lemma('studies', POS.NOUN).lemmas.contains('study'), true);
  });

  test('better: good', () {
    expect(l.lemma('better', POS.NOUN).lemmas.contains('better'), true);
    expect(l.lemma('better', POS.VERB).lemmas.contains('better'), true);
    expect(l.lemma('better', POS.ADJ).lemmas.contains('good'), true);
    expect(l.lemma('better', POS.ADJ).lemmas.contains('well'), true);
    expect(l.lemma('better', POS.ADV).lemmas.contains('well'), true);
  });

  test('lovely: adjective', () {
    expect(l.lemma('lovely', POS.ADJ).lemmas.contains('lovely'), true);
    expect(l.lemma('lovelier', POS.ADJ).lemmas.contains('lovely'), true);
    expect(l.lemma('loveliest', POS.ADJ).lemmas.contains('lovely'), true);
  });
}
