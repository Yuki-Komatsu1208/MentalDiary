enum DailyStatusParameter {
  mood,
  interest,
  energy,
  sleepQuality,
  stressed,
}

const List<DailyStatusParameter> dailyStatusParameterDisplayOrder =
    <DailyStatusParameter>[
      DailyStatusParameter.mood,
      DailyStatusParameter.interest,
      DailyStatusParameter.energy,
      DailyStatusParameter.sleepQuality,
      DailyStatusParameter.stressed,
    ];

class DailyStatusParameterDefinition {
  const DailyStatusParameterDefinition({
    required this.label,
    required this.valueLabels,
    required this.minHint,
    required this.maxHint,
  });

  final String label;
  final List<String> valueLabels;
  final String minHint;
  final String maxHint;
}

const Map<DailyStatusParameter, DailyStatusParameterDefinition>
dailyStatusParameterDefinitions = <DailyStatusParameter, DailyStatusParameterDefinition>{
  DailyStatusParameter.mood: DailyStatusParameterDefinition(
    label: '気分',
    valueLabels: <String>[
      'かなり落ち込む',
      '少し沈む',
      'ふつう',
      '安定している',
      'とても良い',
    ],
    minHint: 'かなり落ち込む',
    maxHint: 'とても良い',
  ),
  DailyStatusParameter.interest: DailyStatusParameterDefinition(
    label: '興味・関心',
    valueLabels: <String>[
      'ほとんど湧かない',
      '少し湧く',
      'ふつう',
      'しっかり湧く',
      '強く湧く',
    ],
    minHint: 'ほとんど湧かない',
    maxHint: '強く湧く',
  ),
  DailyStatusParameter.energy: DailyStatusParameterDefinition(
    label: '活力',
    valueLabels: <String>[
      'ほとんど動けない',
      'かなり低い',
      'ふつう',
      '十分にある',
      'とても満ちている',
    ],
    minHint: 'ほとんど動けない',
    maxHint: 'とても満ちている',
  ),
  DailyStatusParameter.sleepQuality: DailyStatusParameterDefinition(
    label: '睡眠の質',
    valueLabels: <String>[
      '全く眠れない',
      'あまり眠れない',
      'ふつう',
      '概ね眠れている',
      '安眠できている',
    ],
    minHint: '全く眠れない',
    maxHint: '安眠できている',
  ),
  DailyStatusParameter.stressed: DailyStatusParameterDefinition(
    label: 'ストレス・不安を感じる',
    valueLabels: <String>[
      'まったく不安を感じない',
      '少し感じる',
      'やや感じる',
      'かなり感じる',
      '強く不安を感じる',
    ],
    minHint: 'まったく不安を感じない',
    maxHint: '強く不安を感じる',
  ),
};

extension DailyStatusParameterDefinitionX on DailyStatusParameter {
  DailyStatusParameterDefinition get definition {
    return dailyStatusParameterDefinitions[this]!;
  }
}

class DailyStatusScore {
  DailyStatusScore(this.parameter, int value) : value = value.clamp(1, 5);

  final DailyStatusParameter parameter;

  final int value;

  String getDisplayValue() {
    final List<String> labels = parameter.definition.valueLabels;
    final int currentIndex = value - 1;
    if (currentIndex < 0 || currentIndex >= labels.length) {
      return value.toString();
    }

    return labels[currentIndex];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'parameter': parameter.name, 'value': value};
  }
}
