library lemmatizer;

import 'package:lemmatizerx/src/lemmas.dart';

enum POS { NOUN, VERB, ADJ, ADV, ABBR, UNKNOWN }

/// A data transfer object.
/// "pos" defines the type: NOUN, VERB, ADJ, ADV.
/// "form" is the orignal word.
/// "lemmas" is a list holding found lemmas.
class Lemma {
  POS pos = POS.UNKNOWN;
  String form;
  List<String> lemmas = [];
  Lemma(this.pos, this.form, this.lemmas);
  Lemma.notFound(this.form);
  // Lemma.notChange(this.pos, this.form) {
  //   lemmas.add(form);
  // }

  // Returns whether there a single lemma and is it the same as
  // the supplied form (word).
  bool lemmaSameAsForm() {
    return form == lemmas[0] && lemmas.length == 1;
  }

  // Returns whether no lemmas have been found.
  bool get lemmasNotFound {
    return pos == POS.UNKNOWN;
  }

  // Returns whether lemmas have been found.
  bool get lemmasFound {
    return pos != POS.UNKNOWN;
  }

  /// String representation.
  String toString() {
    return pos.toString() + ' ' + form + ' ' + lemmas.toString();
  }
}

/// Lemmatizer takes a form (word) as an argument and returns
/// Lemma-obect(s).
///
/// Even if no lemma has been found, a Lemma-object is returned.
///
/// Use "lemma.lemmasFound == true"
/// to check whether any lemmas have been found.
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

  /// Given a form (word), returns a list of lemmas.
  /// The same form (word) may result in multpiple lemmas, like in
  /// the case of "meeting", which is a NOUN as well as a VERB.
  ///
  /// Use "lemma.lemmasFound == true"
  /// to check whether any lemmas have been found.
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

  /// Given a form (word) and a Part-Of-Speech parameter, this
  /// method will return a Lemma.
  ///
  /// Use "lemma.lemmasFound == true"
  /// to check whether any lemmas have been found.
  Lemma lemma(String form, POS pos) {
    if (pos == POS.UNKNOWN) {
      throw 'Illegal parameter: ${pos.name}';
    }
    form = form.toLowerCase();
    return _checkReplacement(form, form, pos);
  }

  Lemma _checkReplacement(String formOriginal, String formModified, POS pos) {
    // exception = replacePOS
    switch (pos) {
      case POS.NOUN:
        if (LemmaHelper.hasReplaceNouns(formModified)) {
          return Lemma(POS.NOUN, formOriginal,
              LemmaHelper.getReplaceNouns(formModified));
        }
        break;
      case POS.VERB:
        if (LemmaHelper.hasReplaceVerbs(formModified)) {
          return Lemma(POS.VERB, formOriginal,
              LemmaHelper.getReplaceVerbs(formModified));
        }
        break;
      case POS.ADJ:
        if (LemmaHelper.hasReplaceAdjectives(formModified)) {
          return Lemma(POS.ADJ, formOriginal,
              LemmaHelper.getReplaceAdjectives(formModified));
        }
        break;
      case POS.ADV:
        if (LemmaHelper.hasReplaceAdverbs(formModified)) {
          return Lemma(POS.ADV, formOriginal,
              LemmaHelper.getReplaceAdverbs(formModified));
        }
        break;
      default:
      // do nothing
    }

    return _checkKeep(formOriginal, formModified, pos);
  }

  Lemma _checkKeep(String formOriginal, String formModified, POS pos) {
    // index = keepPOS
    switch (pos) {
      case POS.NOUN:
        if (LemmaHelper.hasKeepNouns(formModified)) {
          return Lemma(POS.NOUN, formOriginal, [formModified]);
        }
        break;
      case POS.VERB:
        if (LemmaHelper.hasKeepVerbs(formModified)) {
          return Lemma(POS.VERB, formOriginal, [formModified]);
        }
        break;
      case POS.ADJ:
        if (LemmaHelper.hasKeepAdjectives(formModified)) {
          return Lemma(POS.ADJ, formOriginal, [formModified]);
        }
        break;
      case POS.ADV:
        if (LemmaHelper.hasKeepAdverbs(formModified)) {
          return Lemma(POS.ADV, formOriginal, [formModified]);
        }
        break;
      default:
      // do nothing
    }
    return _eachSubstitutions(formOriginal, formModified, pos);
  }

  Lemma _eachSubstitutions(String formOriginal, String formModified, POS pos) {
    List<List<String>> substitutions = MORPHOLOGICAL_SUBSTITUTIONS[pos]!;
    for (var substitution in substitutions) {
      String search = substitution[0];
      String replace = substitution[1];
      if (formModified.endsWith(search)) {
        String cut =
            formModified.substring(0, formModified.length - search.length);
        Lemma res = _checkKeep(formOriginal, cut + replace, pos);
        if (res.lemmasFound) {
          return res;
        }
      }
    }
    return Lemma.notFound(formOriginal);
  }

  // Lemma _eachSubstitutions(String formOriginal, String formModified, POS pos) {
  //   List<List<String>> substitutions = MORPHOLOGICAL_SUBSTITUTIONS[pos]!;
  //   for (var substitution in substitutions) {
  //     String search = substitution[0];
  //     String replace = substitution[1];
  //     if (formOriginal.endsWith(search)) {
  //       String cut =
  //           formOriginal.substring(0, formOriginal.length - search.length);
  //       Lemma res = _checkKeep(cut + replace, pos);
  //       if (res.lemmasFound) {
  //         return res;
  //       }
  //     }
  //   }
  //   return Lemma.notFound(formOriginal);
  // }
}
