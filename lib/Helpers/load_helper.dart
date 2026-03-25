//データの永続化処理を行うヘルパークラス
import 'dart:convert';
import 'dart:io';
import 'package:mental_diary/Entities/daily_status.dart';
import 'package:path_provider/path_provider.dart';

class LoadHelper {
  static const _fileName = 'emotion_daily_data.json';

  //指定日付の状態を読み込む
  static Future<DailyStatus> loadStatusByDate(DateTime date) async {
    final Map<DateTime, DailyStatus> statusMap = await loadDailyStatusMap();
    final DateTime normalizedDate = _normalizeDate(date);
    return statusMap[normalizedDate] ?? DailyStatus(Date: normalizedDate);
  }

  //ローカルファイルからDailyStatusマップの読み込みを行う
  static Future<Map<DateTime, DailyStatus>> loadDailyStatusMap() async {
    try {
      final Map<String, dynamic> jsonData = await loadLocalJson();
      return convertJsonToDailyStatusMap(jsonData);
    } on FormatException
    //JSONのフォーマットエラー時は空のマップを返す
    {
      return {};
    }
  }

  //DailyStatusマップをJSONデータに変換
  static Map<DateTime, DailyStatus> convertJsonToDailyStatusMap(
    Map<String, dynamic> jsonData,
  ) {
    final Map<DateTime, DailyStatus> statusMap = <DateTime, DailyStatus>{};
    if (jsonData.isEmpty) {
      return statusMap;
    }
    jsonData.forEach((String key, dynamic value) {
      final DateTime date = _normalizeDate(DateTime.parse(key));
      final Map<String, dynamic> dailyStatusJson = Map<String, dynamic>.from(
        value,
      );
      final DailyStatus status = DailyStatus.fromJson(<String, dynamic>{
        'Date': key,
        ...dailyStatusJson,
      });

      statusMap[date] = status;
    });

    return statusMap;
  }

  //JSONデータの読み取り
  static Future<Map<String, dynamic>> loadLocalJson() async {
    try {
      final File file = await _getLocalFile();
      if (!await file.exists()) {
        //読み込むデータがなければJSONを新たに生成する
        await createJsonFile();
      }

      final String contents = await file.readAsString();
      return Map<String, dynamic>.from(jsonDecode(contents));
    } catch (e) {
      return {};
    }
  }

  //ローカルファイルのパス取得
  static Future<File> _getLocalFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  //Jsonファイルの生成
  static Future<void> createJsonFile() async {
    final File file = await _getLocalFile();
    if (!(await file.exists())) {
      await file.writeAsString(jsonEncode({}));
    }
  }

  //日付の時刻部分を切り落として比較用に正規化する
  static DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
