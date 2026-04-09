import 'VO/daily_status_score.dart';

///日々の感情状態を保存するクラス
class DailyStatus {
  DailyStatus({
    //日付は必須
    required this.Date,
    DailyStatusScore? Mood,
    DailyStatusScore? Interest,
    DailyStatusScore? Energy,
    DailyStatusScore? SleepQuality,
    DailyStatusScore? Stressed,
    this.Note = '',
  }) : Mood = Mood ?? DailyStatusScore(DailyStatusParameter.mood, 5),
       Interest =
           Interest ?? DailyStatusScore(DailyStatusParameter.interest, 5),
       Energy = Energy ?? DailyStatusScore(DailyStatusParameter.energy, 5),
       SleepQuality =
           SleepQuality ??
           DailyStatusScore(DailyStatusParameter.sleepQuality, 5),
       Stressed =
           Stressed ?? DailyStatusScore(DailyStatusParameter.stressed, 5);

  //日付
  DateTime Date;

  ///ステータスを１〜５で保存
  //気分
  DailyStatusScore Mood;
  //興味・喜び
  DailyStatusScore Interest;
  //活力
  DailyStatusScore Energy;
  //睡眠品質
  DailyStatusScore SleepQuality;
  //不安、ストレス
  DailyStatusScore Stressed;

  ///メモ
  String Note;

  //デフォルトの状態を返す
  static DailyStatus defaultStatus() {
    return DailyStatus(Date: DateTime.now());
  }

  DailyStatusScore scoreOf(DailyStatusParameter parameter) {
    switch (parameter) {
      case DailyStatusParameter.mood:
        return Mood;
      case DailyStatusParameter.interest:
        return Interest;
      case DailyStatusParameter.energy:
        return Energy;
      case DailyStatusParameter.sleepQuality:
        return SleepQuality;
      case DailyStatusParameter.stressed:
        return Stressed;
    }
  }

  void updateScore(DailyStatusParameter parameter, int value) {
    final DailyStatusScore score = DailyStatusScore(parameter, value);
    switch (parameter) {
      case DailyStatusParameter.mood:
        Mood = score;
      case DailyStatusParameter.interest:
        Interest = score;
      case DailyStatusParameter.energy:
        Energy = score;
      case DailyStatusParameter.sleepQuality:
        SleepQuality = score;
      case DailyStatusParameter.stressed:
        Stressed = score;
    }
  }

  int get summaryScore {
    final int convertedStressScore = 6 - Stressed.value;
    return ((Mood.value +
                    Interest.value +
                    Energy.value +
                    SleepQuality.value +
                    convertedStressScore) /
                5)
            .round();
  }

  String get summaryLabel {
    switch (summaryScore) {
      case 5:
        return '高い集中と安定感があります';
      case 4:
        return '落ち着いたバランスです';
      case 3:
        return 'フラットな一日です';
      case 2:
        return '少し休息を優先したい状態です';
      default:
        return 'ゆっくり整える日です';
    }
  }

  //JSON形式からDailyStatusオブジェクトを生成
  factory DailyStatus.fromJson(dynamic json) {
    if (json.isEmpty) {
      return DailyStatus.defaultStatus();
    }
    return DailyStatus(
      Date: DateTime.parse(json['Date'] ?? DateTime.now().toIso8601String()),
      Mood: DailyStatusScore(DailyStatusParameter.mood, json['Mood'] ?? 5),
      Interest: DailyStatusScore(
        DailyStatusParameter.interest,
        json['Interest'] ?? 5,
      ),
      Energy: DailyStatusScore(
        DailyStatusParameter.energy,
        json['Energy'] ?? 5,
      ),
      SleepQuality: DailyStatusScore(
        DailyStatusParameter.sleepQuality,
        json['SleepQuality'] ?? 5,
      ),
      Stressed: DailyStatusScore(
        DailyStatusParameter.stressed,
        json['Stressed'] ?? 5,
      ),
      Note: json['Note'] ?? '',
    );
  }

  //DailyStatusオブジェクトをJSON形式に変換
  Map<String, dynamic> toJson() {
    return {
      "Date": Date.toIso8601String(),
      "Mood": Mood.value,
      "Interest": Interest.value,
      "Energy": Energy.value,
      "SleepQuality": SleepQuality.value,
      "Stressed": Stressed.value,
      "Note": Note,
    };
  }
}
