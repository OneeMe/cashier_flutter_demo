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
    final dioAdapter =
        DioAdapter(dio: dio, matcher: const FullHttpRequestMatcher());
    setupMock(dioAdapter);
  } else {
    dio = Dio(BaseOptions(baseUrl: baseUrl));
  }
}

const payPath = '/pay';

Future<PaymentResponse> pay(String amount) async {
  Response response = await Future.any([
    dio.post(
      payPath,
      data: {
        'amount': amount,
      },
    ).catchError((e) {
      return Response(
          data: Map.from({
            'errorMessage': '网络请求失败',
            'success': false,
          }),
          requestOptions: RequestOptions(baseUrl: baseUrl));
    }),
    delayFor(3),
  ]);
  return PaymentResponse.fromJson(response.data.cast<String, dynamic>());
}

Future<Response<Map>> delayFor(int seconds) async {
  await Future.delayed(Duration(seconds: seconds));
  return Response(
      data: Map<String, dynamic>.from({
        'errorMessage': '网络请求失败',
        'success': false,
      }),
      requestOptions: RequestOptions(baseUrl: baseUrl));
}
