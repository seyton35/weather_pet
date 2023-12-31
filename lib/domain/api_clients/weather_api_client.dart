import 'dart:convert';
import 'dart:io';

import 'package:weather_pet/domain/api_clients/api_clients_exception.dart';
import 'package:weather_pet/domain/entity/location_response.dart';
import 'package:weather_pet/domain/entity/weather_response_current.dart';

class WeatherApiClient {
  final _client = HttpClient();
  static const _host = 'http://api.weatherapi.com/v1';
  static const _apiKey = '1d4e9b05530c426e910111546232912';

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
      final req = await _client.getUrl(url);
      final res = await req.close();
      final dynamic json = await res.jsonDecode();
      _validateResponse(res, json);
      final result = parser(json);
      return result;
    } on SocketException {
      throw ApiClientExeption(ApiClientExeptionType.network);
    } on ApiClientExeption {
      rethrow;
    } catch (_) {
      throw ApiClientExeption(ApiClientExeptionType.other);
    }
  }

  void _validateResponse(HttpClientResponse res, dynamic json) {
    final statusCode = res.statusCode;
    if (statusCode != 200) {
      final dynamic status = json['status_code'];
      final code = status is int ? status : 0;
      if (statusCode == 400) {
        if (code == 1006) {
          throw ApiClientExeption(ApiClientExeptionType.emptyResponse);
        }
      }
      if (statusCode == 403) {
        if (code == 2007 || code == 2008 || code == 2009) {
          throw ApiClientExeption(ApiClientExeptionType.apiKey);
        }
      }
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
    required String days,
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
        'days': days,
      },
    );
    return result;
  }

  Future<List<LocationResponse>> searchLocation({
    required String query,
  }) async {
    parser(json) {
      json as List;
      final List<LocationResponse> locationList = [];
      json.map((item) {
        final jsonMap = item as Map<String, dynamic>;
        locationList.add(LocationResponse.fromJson(jsonMap));
      }).toList();
      return locationList;
    }

    final result = _get(
      'search.json',
      parser,
      <String, dynamic>{
        'key': _apiKey,
        'q': query,
      },
    );
    return result;
  }
}

extension HttpClientResponseJsonDecode on HttpClientResponse {
  Future<dynamic> jsonDecode() async {
    return transform(utf8.decoder)
        .toList()
        .then((value) => value.join())
        .then<dynamic>((v) => json.decode(v));
  }
}
