import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

const baseURL = 'https://rest.coinapi.io/v1/exchangerate/';

Future<String> getExchangeRate(
    {@required String crypto, @required String currency}) async {
  http.Response response = await http.get(Uri.parse(
      baseURL + crypto + '/' + currency + '?apikey=' + env['API_KEY']));
  Map mapObject = jsonDecode(response.body);
  double rate = mapObject['rate'];
  return rate.toStringAsFixed(2);
}
