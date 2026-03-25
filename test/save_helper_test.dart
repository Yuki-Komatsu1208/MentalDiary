import 'package:mental_diary/Entities/daily_status.dart';
import 'package:mental_diary/Helpers/save_helper.dart';
import 'package:mental_diary/Helpers/load_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

// ① テスト用の Fake Path Provider
class FakePathProvider extends PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return "/tmp"; // macOSでも必ず存在する
  }
}

void main() {
  // ② Flutter のテストバインディング
  TestWidgetsFlutterBinding.ensureInitialized();

  // ③ Fake プロバイダを登録
  setUpAll(() {
    PathProviderPlatform.instance = FakePathProvider();
  });

  // ④ SaveHelper のテスト
  test('エンティティのListを保存できる', () async {
    // Arrange
    final List<DailyStatus> entities = <DailyStatus>[
      DailyStatus(
        Date: DateTime.parse("2024-06-01"),
        Mood: 5,
        Interest: 4,
        Note: "Great day!",
      ),
      DailyStatus(
        Date: DateTime.parse("2024-06-02"),
        Stressed: 4,
        Note: "Not so good.",
      ),
    ];

    // Act
    await SaveHelper.saveStatus(entities);
    final Map<String, dynamic> loadedJson = await LoadHelper.loadLocalJson();

    // Assert
    expect(loadedJson.isNotEmpty, true);
    expect(
      loadedJson[DateTime.parse("2024-06-01").toIso8601String()]['Note'],
      "Great day!",
    );
    expect(
      loadedJson[DateTime.parse("2024-06-02").toIso8601String()]['Stressed'],
      4,
    );
  });

  test('指定日付の状態を読み込める', () async {
    // Arrange
    final DailyStatus targetStatus = DailyStatus(
      Date: DateTime.parse("2024-06-03"),
      Mood: 2,
      Interest: 3,
      Energy: 4,
      SleepQuality: 5,
      Stressed: 1,
      Note: "Saved automatically",
    );

    // Act
    await SaveHelper.saveSingleStatus(targetStatus);
    final DailyStatus loadedStatus = await LoadHelper.loadStatusByDate(
      DateTime.parse("2024-06-03"),
    );

    // Assert
    expect(loadedStatus.Date, DateTime.parse("2024-06-03"));
    expect(loadedStatus.Mood, 2);
    expect(loadedStatus.Interest, 3);
    expect(loadedStatus.Note, "Saved automatically");
  });
}
