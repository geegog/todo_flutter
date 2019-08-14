import 'package:http/http.dart' as http;

class APIUtil {

  Map<String, String> _headers = {'Content-Type': 'application/json'};

  Future<dynamic> fetch(String uri) async {
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return response.body;
    } else {
      // If that response was not OK, throw an error.
      throw Exception(response.body);
    }
  }

  Future<dynamic> post(String uri, String body) async {
    final response = await http.post(uri, headers: _headers, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      // If server returns an OK response, parse the JSON.
      return response;
    } else {
      // If that response was not OK, throw an error.
      throw Exception(response.body);
    }
  }
}
