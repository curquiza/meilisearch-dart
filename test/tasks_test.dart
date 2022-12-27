import 'package:meilisearch/src/query_parameters/cancel_tasks_query.dart';
import 'package:test/test.dart';

import 'utils/client.dart';

void main() {
  group('Cancel Tasks', () {
    setUpClient();

    test('cancels tasks given an input', () async {
      var date = DateTime.now();
      var response = await client
          .cancelTasks(
              params: CancelTasksQuery(uids: [1, 2], beforeStartedAt: date))
          .waitFor();

      expect(response.status, 'succeeded');
      expect(response.details!['originalFilter'],
          '?beforeStartedAt=${Uri.encodeComponent(date.toUtc().toIso8601String())}&uids=1%2C2');
    });
  });
}
