import 'daily_status.dart';
import 'VO/daily_status_score.dart';

///指定期間の集計結果を保持するクラス
class PeriodSummary {
  PeriodSummary({
    required this.startDate,
    required this.endDate,
    required this.statuses,
  });

  final DateTime startDate;
  final DateTime endDate;
  final List<DailyStatus> statuses;

  ///指定期間内の状態一覧から集計結果を生成する
  factory PeriodSummary.fromStatusMap({
    required Map<DateTime, DailyStatus> statusMap,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final DateTime normalizedStartDate = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );
    final DateTime normalizedEndDate = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
    );

    final List<DailyStatus> filteredStatuses = statusMap.entries
        .where((MapEntry<DateTime, DailyStatus> entry) {
          final DateTime date = DateTime(
            entry.key.year,
            entry.key.month,
            entry.key.day,
          );
          return !date.isBefore(normalizedStartDate) &&
              !date.isAfter(normalizedEndDate);
        })
        .map((MapEntry<DateTime, DailyStatus> entry) => entry.value)
        .toList()
      ..sort((DailyStatus a, DailyStatus b) => a.Date.compareTo(b.Date));

    return PeriodSummary(
      startDate: normalizedStartDate,
      endDate: normalizedEndDate,
      statuses: filteredStatuses,
    );
  }

  ///対象データが存在するかどうかを返す
  bool get hasEntries => statuses.isNotEmpty;

  ///各パラメータの平均値を返す
  double averageOf(DailyStatusParameter parameter) {
    if (!hasEntries) {
      return 0;
    }

    final int total = statuses.fold(0, (int sum, DailyStatus status) {
      return sum + status.scoreOf(parameter).value;
    });
    return total / statuses.length;
  }

  ///表示用に小数第一位へ整形した平均値を返す
  String formattedAverageOf(DailyStatusParameter parameter) {
    return averageOf(parameter).toStringAsFixed(1);
  }

  ///期間全体の総合スコアを返す
  int get summaryScore {
    if (!hasEntries) {
      return 0;
    }

    final double convertedStressAverage =
        6 - averageOf(DailyStatusParameter.stressed);
    return ((averageOf(DailyStatusParameter.mood) +
                averageOf(DailyStatusParameter.interest) +
                averageOf(DailyStatusParameter.energy) +
                averageOf(DailyStatusParameter.sleepQuality) +
                convertedStressAverage) /
            5)
        .round()
        .clamp(1, 5);
  }

  ///期間サマリの自然言語を返す
  String get naturalLanguageSummary {
    final String rangeLabel = '${_formatDate(startDate)}〜${_formatDate(endDate)}';
    if (!hasEntries) {
      return '$rangeLabelは記録がまだありませんでした。';
    }

    return '$rangeLabelまでは${DailyStatus.summaryLabelForScore(summaryScore)}。';
  }

  ///期間内でメモが存在する記録のみ返す
  List<DailyStatus> get noteStatuses {
    return statuses.where((DailyStatus status) {
      return status.Note.trim().isNotEmpty;
    }).toList();
  }

  ///表示用の日付ラベルを返す
  static String formatDateRange(DateTime startDate, DateTime endDate) {
    return '${_formatDate(startDate)}〜${_formatDate(endDate)}';
  }

  ///月日表記へ整形する
  static String _formatDate(DateTime date) {
    return '${date.month}月${date.day}日';
  }
}
