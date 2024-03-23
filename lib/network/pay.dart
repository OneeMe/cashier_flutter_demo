import 'package:cashier_flutter_demo/network/mock.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

late Dio dio;

class PaymentResponse {
  final String errorMessage;
  final bool success;

  PaymentResponse({
    required this.errorMessage,
    required this.success,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      errorMessage: json['errorMessage'],
      success: json['success'],
    );
  }
}

const baseUrl = 'https://wechat.qq.com';

void setupNetwork(bool enableMock) {
  if (enableMock) {
    dio = Dio(BaseOptions(baseUrl: baseUrl));
    final dioAdapter = DioAdapter(dio: dio, matcher: const UrlRequestMatcher());
    setupMock(dioAdapter);
  } else {
    dio = Dio(BaseOptions(baseUrl: baseUrl));
  }
}

const payPath = '/pay';

Future<PaymentResponse> pay(String amount) async {
  Response response = await dio.post(
    payPath,
    data: {
      'amount': amount,
    },
  );
  return PaymentResponse.fromJson(response.data);
}
