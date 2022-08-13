library lemmatizer;

import 'package:lemmatizerx/src/lemmas.dart';

enum POS { NOUN, VERB, ADJ, ADV, ABBR, UNKNOWN }

class Lemma {
  POS pos = POS.UNKNOWN;
  String form;
  List<String> lemmas = [];
  Lemma(this.pos, this.form, this.lemmas);
  Lemma.notFound(this.form);
  Lemma.notChange(this.pos, this.form) {
    lemmas.add(form);
  }

  bool lemmaSameAsForm() {
    return form == lemmas[0] && lemmas.length == 1;
  }

  bool get lemmasNotFound {
    return pos == POS.UNKNOWN;
  }

  bool get lemmasFound {
    return pos != POS.UNKNOWN;
  }

  String toString() {
    return pos.toString() + ' ' + form + ' ' + lemmas.toString();
  }
}

class Lemmatizer {
  static const Map<POS, List<List<String>>> MORPHOLOGICAL_SUBSTITUTIONS = {
    POS.NOUN: [
      ['s', ''],
      ['ses', 's'],
      ['ves', 'f'],
      ['xes', 'x'],
      ['zes', 'z'],
      ['ches', 'ch'],
      ['shes', 'sh'],
      ['men', 'man'],
      ['ies', 'y']
    ],
    POS.VERB: [
      ['s', ''],
      ['ies', 'y'],
      ['ied', 'y'],
      ['es', 'e'],
      ['es', ''],
      ['ed', 'e'],
      ['ed', ''],
      ['ing', 'e'],
      ['ing', '']
    ],
    POS.ADJ: [
      ['er', ''],
      ['est', ''],
      ['er', 'e'],
      ['est', 'e']
    ],
    POS.ADV: [], // only hard defs at the moment
    POS.ABBR: [],
    POS.UNKNOWN: []
  };

  List<Lemma> lemmas(String form) {
    List<Lemma> lemmas = [];

    for (POS pos in POS.values) {
      if (pos == POS.UNKNOWN) {
        continue;
      }
      Lemma lem = lemma(form, pos);
      if (lem.lemmasFound) {
        lemmas.add(lem);
      }
    }
    return lemmas;
  }

  Lemma lemma(String form, POS pos) {
    if (pos == POS.UNKNOWN) {
      throw 'Illegal parameter: ${pos.name}';
    }
    return _eachLemma(form, pos);
  }

  Lemma _eachLemma(String form, POS pos) {
    // exception = replacePOS
    switch (pos) {
      case POS.NOUN:
        if (LemmaHelper.hasReplaceNouns(form)) {
          return Lemma(POS.NOUN, form, LemmaHelper.getReplaceNouns(form));
        }
        break;
      case POS.VERB:
        if (LemmaHelper.hasReplaceVerbs(form)) {
          return Lemma(POS.VERB, form, LemmaHelper.getReplaceVerbs(form));
        }
        break;
      case POS.ADJ:
        if (LemmaHelper.hasReplaceAdjectives(form)) {
          return Lemma(POS.ADJ, form, LemmaHelper.getReplaceAdjectives(form));
        }
        break;
      case POS.ADV:
        if (LemmaHelper.hasReplaceAdverbs(form)) {
          return Lemma(POS.ADV, form, LemmaHelper.getReplaceAdverbs(form));
        }
        break;
      default:
      // do nothing
    }

    return _eachSubstitutions(form, pos);
  }

  Lemma _eachSubstitutions(String form, POS pos) {
    // index = keepPOS
    switch (pos) {
      case POS.NOUN:
        if (LemmaHelper.hasKeepNouns(form)) {
          return Lemma.notChange(POS.NOUN, form);
        }
        break;
      case POS.VERB:
        if (LemmaHelper.hasKeepVerbs(form)) {
          return Lemma.notChange(POS.VERB, form);
        }
        break;
      case POS.ADJ:
        if (LemmaHelper.hasKeepAdjectives(form)) {
          return Lemma.notChange(POS.ADJ, form);
        }
        break;
      case POS.ADV:
        if (LemmaHelper.hasKeepAdverbs(form)) {
          return Lemma.notChange(POS.ADV, form);
        }
        break;
      default:
      // do nothing
    }

    List<List<String>> substitutions = MORPHOLOGICAL_SUBSTITUTIONS[pos]!;
    for (var substitution in substitutions) {
      String search = substitution[0];
      String replace = substitution[1];
      if (form.endsWith(search)) {
        String cut = form.substring(0, form.length - search.length);
        Lemma res = _eachSubstitutions(cut + replace, pos);
        if (res.lemmasFound) {
          return res;
        }
      }
    }
    return Lemma.notFound(form);
  }
}
