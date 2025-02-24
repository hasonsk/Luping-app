class PronunciationAssessmentResult {
  final String displayText;
  final List<NBest> nBest;

  PronunciationAssessmentResult({
    required this.displayText,
    required this.nBest,
  });

  factory PronunciationAssessmentResult.fromJson(Map<String, dynamic> json) {
    return PronunciationAssessmentResult(
      displayText: json['DisplayText'] ?? '',
      nBest: (json['NBest'] as List<dynamic>?)
              ?.map((e) => NBest.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
  // 🛠 Thêm phương thức toJson()
  Map<String, dynamic> toJson() {
    return {
      'DisplayText': displayText,
      'NBest': nBest.map((e) => e.toJson()).toList(),
    };
  }
}

class NBest {
  final double confidence;
  final String lexical;
  final String itn;
  final String maskedITN;
  final String display;
  final PronunciationAssessment pronunciationAssessment;
  final List<WordAssessment> words;

  NBest({
    required this.confidence,
    required this.lexical,
    required this.itn,
    required this.maskedITN,
    required this.display,
    required this.pronunciationAssessment,
    required this.words,
  });

  factory NBest.fromJson(Map<String, dynamic> json) {
    return NBest(
      confidence: (json['Confidence'] as num?)?.toDouble() ?? 0.0,
      lexical: json['Lexical'] ?? '',
      itn: json['ITN'] ?? '',
      maskedITN: json['MaskedITN'] ?? '',
      display: json['Display'] ?? '',
      pronunciationAssessment: PronunciationAssessment.fromJson(
          json['PronunciationAssessment'] as Map<String, dynamic>? ?? {}),
      words: (json['Words'] as List<dynamic>?)
              ?.map((e) => WordAssessment.fromJson(e as Map<String, dynamic>))
              .toList() ?? [],
    );
  }
  // 🛠 Thêm phương thức toJson()
  Map<String, dynamic> toJson() {
    return {
      'Confidence': confidence,
      'Lexical': lexical,
      'ITN': itn,
      'MaskedITN': maskedITN,
      'Display': display,
      'PronunciationAssessment': pronunciationAssessment.toJson(),
      'Words': words.map((e) => e.toJson()).toList(),
    };
  }
}

class PronunciationAssessment {
  final double accuracyScore;
  final double fluencyScore;
  final double completenessScore;
  final double pronScore;

  PronunciationAssessment({
    required this.accuracyScore,
    required this.fluencyScore,
    required this.completenessScore,
    required this.pronScore,
  });

  factory PronunciationAssessment.fromJson(Map<String, dynamic> json) {
    return PronunciationAssessment(
      accuracyScore: (json['AccuracyScore'] as num?)?.toDouble() ?? 0.0,
      fluencyScore: (json['FluencyScore'] as num?)?.toDouble() ?? 0.0,
      completenessScore: (json['CompletenessScore'] as num?)?.toDouble() ?? 0.0,
      pronScore: (json['PronScore'] as num?)?.toDouble() ?? 0.0,
    );
  }
  // 🛠 Thêm phương thức toJson()
  Map<String, dynamic> toJson() {
    return {
      'AccuracyScore': accuracyScore,
      'FluencyScore': fluencyScore,
      'CompletenessScore': completenessScore,
      'PronScore': pronScore,
    };
  }
}

class WordAssessment {
  final String word;
  final int offset;
  final int duration;
  final WordPronunciationAssessment pronunciationAssessment;
  final List<SyllableAssessment> syllables;
  final List<PhonemeAssessment> phonemes;

  WordAssessment({
    required this.word,
    required this.offset,
    required this.duration,
    required this.pronunciationAssessment,
    required this.syllables,
    required this.phonemes,
  });

  factory WordAssessment.fromJson(Map<String, dynamic> json) {
    return WordAssessment(
      word: json['Word'] ?? '',
      offset: json['Offset'] ?? 0,
      duration: json['Duration'] ?? 0,
      pronunciationAssessment: WordPronunciationAssessment.fromJson(
          json['PronunciationAssessment'] as Map<String, dynamic>? ?? {}),
      syllables: (json['Syllables'] as List<dynamic>?)
          ?.map((e) => SyllableAssessment.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      phonemes: (json['Phonemes'] as List<dynamic>?)
          ?.map((e) => PhonemeAssessment.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  // 🛠 Thêm phương thức `toJson()`
  Map<String, dynamic> toJson() {
    return {
      'Word': word,
      'Offset': offset,
      'Duration': duration,
      'AccuracyScore': pronunciationAssessment.accuracyScore, // ✅ Lấy từ pronunciationAssessment
      'ErrorType': pronunciationAssessment.errorType, // ✅ Lấy từ pronunciationAssessment
      'SyllableCount': syllables.length, // ✅ Đếm số lượng âm tiết
      'Syllables': syllables.map((s) => s.toJson()).toList(),
      'Phonemes': phonemes.map((p) => p.toJson()).toList(),
    };
  }
}

class WordPronunciationAssessment {
  final double accuracyScore;
  final String errorType;

  WordPronunciationAssessment({
    required this.accuracyScore,
    required this.errorType,
  });

  factory WordPronunciationAssessment.fromJson(Map<String, dynamic> json) {
    return WordPronunciationAssessment(
      accuracyScore: (json['AccuracyScore'] as num?)?.toDouble() ?? 0.0,
      errorType: json['ErrorType'] ?? '',
    );
  }
}

class SyllableAssessment {
  final String syllable;
  final int offset;
  final int duration;
  final double accuracyScore;

  SyllableAssessment({
    required this.syllable,
    required this.offset,
    required this.duration,
    required this.accuracyScore,
  });

  factory SyllableAssessment.fromJson(Map<String, dynamic> json) {
    return SyllableAssessment(
      syllable: json['Syllable'] ?? '',
      offset: json['Offset'] ?? 0,
      duration: json['Duration'] ?? 0,
      accuracyScore: (json['AccuracyScore'] ?? 0).toDouble(),
    );
  }

  // 🛠 Thêm phương thức toJson()
  Map<String, dynamic> toJson() {
    return {
      'Syllable': syllable,
      'Offset': offset,
      'Duration': duration,
      'AccuracyScore': accuracyScore,
    };
  }
}


class SyllablePronunciationAssessment {
  final double accuracyScore;

  SyllablePronunciationAssessment({
    required this.accuracyScore,
  });

  factory SyllablePronunciationAssessment.fromJson(Map<String, dynamic> json) {
    return SyllablePronunciationAssessment(
      accuracyScore: (json['AccuracyScore'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

// Added PhonemeAssessment class
class PhonemeAssessment {
  final String phoneme;
  final int offset;
  final int duration;
  final double accuracyScore;

  PhonemeAssessment({
    required this.phoneme,
    required this.offset,
    required this.duration,
    required this.accuracyScore,
  });

  factory PhonemeAssessment.fromJson(Map<String, dynamic> json) {
    return PhonemeAssessment(
      phoneme: json['Phoneme'] ?? '',
      offset: json['Offset'] ?? 0,
      duration: json['Duration'] ?? 0,
      accuracyScore: (json['AccuracyScore'] ?? 0).toDouble(),
    );
  }

  // 🛠 Thêm phương thức toJson()
  Map<String, dynamic> toJson() {
    return {
      'Phoneme': phoneme,
      'Offset': offset,
      'Duration': duration,
      'AccuracyScore': accuracyScore,
    };
  }
}


class PhonemePronunciationAssessment {
  final double accuracyScore;

  PhonemePronunciationAssessment({required this.accuracyScore});

  factory PhonemePronunciationAssessment.fromJson(Map<String, dynamic> json) {
    return PhonemePronunciationAssessment(
      accuracyScore: (json['AccuracyScore'] as num?)?.toDouble() ?? 0.0,
    );
  }
}