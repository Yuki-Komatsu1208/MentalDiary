///日々の感情状態を保存するクラス
class DailyStatus {
  DailyStatus({
    //日付は必須
    required this.Date,
    this.Mood = 5,
    this.Interest = 5,
    this.Energy = 5,
    this.SleepQuality = 5,
    this.Stressed = 5,
    this.Note = '',
  });

  //日付
  DateTime Date;

  ///ステータスを１〜５で保存
  //気分
  int Mood = 5;
  //興味・喜び
  int Interest = 5;
  //活力
  int Energy = 5;
  //睡眠品質
  int SleepQuality = 5;
  //不安、ストレス
  int Stressed = 5;

  ///メモ
  String Note;

  //デフォルトの状態を返す
  static DailyStatus defaultStatus() {
    return DailyStatus(Date: DateTime.now());
  }

  //JSON形式からDailyStatusオブジェクトを生成
  factory DailyStatus.fromJson(dynamic json) {
    if (json.isEmpty) {
      return DailyStatus.defaultStatus();
    }
    return DailyStatus(
      Date: DateTime.parse(json['Date'] ?? DateTime.now().toIso8601String()),
      Mood: json['Mood'] ?? 5,
      Interest: json['Interest'] ?? 5,
      Energy: json['Energy'] ?? 5,
      SleepQuality: json['SleepQuality'] ?? 5,
      Stressed: json['Stressed'] ?? 5,
      Note: json['Note'] ?? '',
    );
  }

  //DailyStatusオブジェクトをJSON形式に変換
  Map<String, dynamic> toJson() {
    return {
      "Date": Date.toIso8601String(),
      "Mood": Mood,
      "Interest": Interest,
      "Energy": Energy,
      "SleepQuality": SleepQuality,
      "Stressed": Stressed,
      "Note": Note,
    };
  }
}
