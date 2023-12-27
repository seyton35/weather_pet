enum ApiClientExeptionType { network, apiKey, other, emptyResponse }

class ApiClientExeption implements Exception {
  final ApiClientExeptionType type;

  ApiClientExeption(this.type);
}
