//データの永続化処理を行うヘルパークラス
import 'dart:convert';
import 'dart:io';
import 'package:mental_diary/Entities/daily_status.dart';
import 'package:path_provider/path_provider.dart';

class SaveHelper {
  static const _fileName = 'emotion_daily_data.json';

  //単一の状態を保存する
  static Future<void> saveSingleStatus(DailyStatus status) async {
    await saveStatus(<DailyStatus>[status]);
  }

  //状態一覧を日付キーのJSON形式で保存する
  static Future<void> saveStatus(List<DailyStatus> statuses) async {
    //JSONファイルが存在しなければ生成
    await _checkJsonFile();

    //既存データを読み込む
    final Map<String, dynamic> storedJson = await _loadStoredJson();

    //日付の新しい順にソート
    statuses.sort((a, b) => b.Date.compareTo(a.Date));
    for (final DailyStatus status in statuses) {
      storedJson[status.Date.toIso8601String()] = status.toJson();
    }

    await _writeToJson(storedJson);
  }

  //日付キーのJSONデータ全体を書き込む
  static Future<void> _writeToJson(Map<String, dynamic> jsonData) async {
    final File file = await _getLocalFile();
    await file.writeAsString(jsonEncode(jsonData));
  }

  //保存済みJSONデータを読み込む
  static Future<Map<String, dynamic>> _loadStoredJson() async {
    try {
      final File file = await _getLocalFile();
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
  static Future<void> _checkJsonFile() async {
    final File file = await _getLocalFile();
    if (!(await file.exists())) {
      await file.writeAsString(jsonEncode({}));
    }
  }
}
