import 'package:dio/dio.dart';
import 'package:weather_pet/domain/entity/weather_response_current.dart';

enum ApiClientExeptionType { Network, Auth, Other, BadResponce }

class ApiClientExeption implements Exception {
  final ApiClientExeptionType type;

  ApiClientExeption(this.type);
}

class WeatherApiClient {
  final _client = Dio();
  static const _host = 'http://api.weatherapi.com/v1';
  static const _apiKey = 'e40192c1cd8449dc8b7140101231412';

  Uri _makeUri(String path, [Map<String, dynamic>? params]) {
    var uri = Uri.parse('$_host/$path');
    if (params != null) {
      return uri.replace(queryParameters: params);
    } else {
      return uri;
    }
  }

  Future<T> _get<T>(
    String path,
    T Function(dynamic json) parser, [
    Map<String, dynamic>? parametrs,
  ]) async {
    final url = _makeUri(path, parametrs);
    try {
      final json = (await _client.getUri(url)).data;

      // _validateResponse(res, json);
      final result = parser(json);
      return result;
      // } on SocketException {
      //   throw ApiClientExeption(ApiClientExeptionType.Network);
      // } on ApiClientExeption {
      //   rethrow;
    } catch (_) {
      throw ApiClientExeption(ApiClientExeptionType.Other);
    }
  }

  Future<WeatherResponceCurrent> currentWeather({
    required String location,
  }) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = WeatherResponceCurrent.fromJson(jsonMap);
      return response;
    }

    final result = _get(
      'current.json',
      parser,
      <String, dynamic>{
        'key': _apiKey,
        'q': location,
      },
    );
    return result;
  }

  Future<WeatherResponceCurrent> forecastWeather({
    required String location,
  }) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = WeatherResponceCurrent.fromJson(jsonMap);
      return response;
    }

    final result = _get(
      'forecast.json',
      parser,
      <String, dynamic>{
        'key': _apiKey,
        'q': location,
        'days': '7',
      },
    );
    return result;
  }

  //todo only in english!
  Future<dynamic> searchLocation({
    required String location,
  }) async {
    return false;
  }
}
