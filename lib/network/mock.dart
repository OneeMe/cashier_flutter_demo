import 'package:cashier_flutter_demo/network/pay.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void setupMock(DioAdapter adapter) {
  adapter.onPost(
    payPath,
    (server) => server.reply(200, {
      'errorMessage': '',
      'success': true,
    }),
    data: {
      'amount': '100',
    },
  );
  adapter.onPost(
    payPath,
    (server) => server.reply(200, {
      'errorMessage': '余额不足',
      'success': false,
    }),
    data: {
      'amount': '99',
    },
  );
  adapter.onPost(
      payPath,
      (server) => server.reply(
            200,
            {
              'errorMessage': '余额不足',
              'success': false,
            },
            delay: const Duration(seconds: 4),
          ),
      data: {
        'amount': '101',
      });
}
