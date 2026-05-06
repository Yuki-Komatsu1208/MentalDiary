import 'package:flutter/material.dart';

import '../../Entities/VO/daily_status_score.dart';
import '../../Entities/period_summary.dart';

///期間サマリ結果を表示するシートUI
class PeriodSummarySheet extends StatelessWidget {
  const PeriodSummarySheet({super.key, required this.summary});

  final PeriodSummary summary;

  ///平均値カードUIを返す
  Widget _buildAverageCard(
    BuildContext context,
    DailyStatusParameter parameter,
  ) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final DailyStatusParameterDefinition definition = parameter.definition;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF2F2924), width: 1.0),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              definition.label,
              style: textTheme.titleMedium?.copyWith(
                color: const Color(0xFF171411),
              ),
            ),
          ),
          Text(
            summary.hasEntries ? summary.formattedAverageOf(parameter) : '-',
            style: textTheme.titleLarge?.copyWith(
              color: const Color(0xFF171411),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  ///ノートカードUIを返す
  Widget _buildNoteCard(BuildContext context, DateTime date, String note) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF2F2924), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${date.month}月${date.day}日',
            style: textTheme.titleMedium?.copyWith(
              color: const Color(0xFF6A5F54),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            note,
            style: textTheme.bodyLarge?.copyWith(color: const Color(0xFF171411)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('期間サマリ', style: textTheme.headlineMedium),
            const SizedBox(height: 18),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Text('サマリ', style: textTheme.titleLarge),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF201A15),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      summary.naturalLanguageSummary,
                      style: textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFFFAF3E7),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('各種パラメータの平均', style: textTheme.titleLarge),
                  const SizedBox(height: 10),
                  ...dailyStatusParameterDisplayOrder.map((
                    DailyStatusParameter parameter,
                  ) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _buildAverageCard(context, parameter),
                    );
                  }),
                  const SizedBox(height: 14),
                  Text(
                    '${PeriodSummary.formatDateRange(summary.startDate, summary.endDate)}のメモ',
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  if (summary.noteStatuses.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFF2F2924),
                          width: 1.0,
                        ),
                      ),
                      child: Text(
                        summary.hasEntries
                            ? 'この期間のメモはありません。'
                            : 'この期間の記録はありません。',
                        style: textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF5C544C),
                        ),
                      ),
                    )
                  else
                    ...summary.noteStatuses.map((status) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildNoteCard(
                          context,
                          status.Date,
                          status.Note.trim(),
                        ),
                      );
                    }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
