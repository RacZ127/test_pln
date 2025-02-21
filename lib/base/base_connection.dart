import 'package:get/get.dart';
import 'base_url.dart';

class BaseConnection extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = BaseUrl.BASE;

    httpClient.addRequestModifier<dynamic>((request) {
      print("=== REQUEST ===");
      print("Method: ${request.method}");
      print("URL: ${request.url}");
      print("Headers: ${request.headers}");
      if (request.bodyBytes != null) {
        if (request.bodyBytes is List<int>) {
          final bytes = request.bodyBytes as List<int>;
          if (bytes.isNotEmpty) {
            print("Body: ${String.fromCharCodes(bytes)}");
          } else {
            print("Body: empty List<int>");
          }
        } else {
          print("Body: request.bodyBytes is of type ${request.bodyBytes.runtimeType} (tidak bisa dicetak langsung)");
        }
      } else {
        print("Body: null");
      }
      return request;
    });

    httpClient.addResponseModifier<dynamic>((request, response) {
      print("=== RESPONSE ===");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.bodyString}");
      return response;
    });

    super.onInit();
  }

  Future<Response> getRequest(String endpoint) async {
    if (endpoint.startsWith('/')) {
      endpoint = endpoint.substring(1);
    }
    final fullUrl = '${BaseUrl.BASE}$endpoint';
    print("GET Request to: $fullUrl");
    final response = await get(fullUrl);
    print("GET Response: ${response.statusCode} ${response.body}");
    return response;
  }

  Future<Response> postRequest(String endpoint, dynamic body) async {
    if (endpoint.startsWith('/')) {
      endpoint = endpoint.substring(1);
    }
    final fullUrl = '${BaseUrl.BASE}$endpoint';
    print("POST Request to: $fullUrl");
    print("Request Body: $body");
    final response = await post(fullUrl, body);
    print("POST Response: ${response.statusCode} ${response.body}");
    return response;
  }

  Future<Response> putRequest(String endpoint, dynamic body) async {
    if (endpoint.startsWith('/')) {
      endpoint = endpoint.substring(1);
    }
    final fullUrl = '${BaseUrl.BASE}$endpoint';
    print("PUT Request to: $fullUrl");
    print("Request Body: $body");
    final response = await put(fullUrl, body);
    print("PUT Response: ${response.statusCode} ${response.body}");
    return response;
  }

  Future<Response> deleteRequest(String endpoint) async {
    if (endpoint.startsWith('/')) {
      endpoint = endpoint.substring(1);
    }
    final fullUrl = '${BaseUrl.BASE}$endpoint';
    print("DELETE Request to: $fullUrl");
    final response = await delete(fullUrl);
    print("DELETE Response: ${response.statusCode} ${response.body}");
    return response;
  }
}
