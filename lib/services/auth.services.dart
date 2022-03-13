import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'dart:html';
import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/services/interceptors.dart';
import 'package:http_interceptor/http_interceptor.dart';
import '../constant.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Create storage
final storage = new FlutterSecureStorage();

// Write value

Future<dynamic> createConsumerUser(body) async {
  final response = await http.post(Uri.parse(URL + '/consumer'), body: body);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return true;
  } else {
    // If the server did not return a 200 OK response,
    // then return an exception.
    return false;
  }
}

Future<dynamic> loginConsumer(body) async {
  final response =
      await http.post(Uri.parse(URL + '/consumer/login'), body: body);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    // print(response.headers['bearer-token']);
    // print(jsonDecode(response.body)["user"]);

    dynamic decoded = jsonDecode(response.body)["user"];
    dynamic consumer_id = decoded.remove("consumer_id");
    decoded["sub"] = consumer_id;
    decoded['profile'] = 'CONSUMER';
    await storage.write(
        key: 'Bearer-Token', value: response.headers['bearer-token']);
    await storage.write(key: 'User', value: jsonEncode(decoded));
    await storage.write(key: 'date', value: response.headers['date']);
    await storage.write(
        key: 'cookie-token', value: response.headers['cookie-token']);

    return true;
  } else {
    // If the server did not return a 200 OK response,
    // then return an exception.
    return false;
  }
}

Future<dynamic> loginSeller(body) async {
  final response =
      await http.post(Uri.parse(URL + '/seller/login'), body: body);
  print(response.statusCode);
  if (response.statusCode == 200) {
    dynamic decoded = jsonDecode(response.body)["user"];
    dynamic seller_id = decoded.remove("seller_id");
    decoded["sub"] = seller_id;
    decoded['profile'] = 'SELLER';
    await storage.write(
        key: 'Bearer-Token', value: response.headers['bearer-token']);
    await storage.write(key: 'User', value: jsonEncode(decoded));
    await storage.write(key: 'date', value: response.headers['date']);
    await storage.write(
        key: 'cookie-token', value: response.headers['cookie-token']);
    print(await getCurrentUserAuth());
    return true;
  } else {
    // If the server did not return a 200 OK response,
    // then return an exception.
    return false;
  }
}

Future<dynamic> logout(body) async {
  final response =
      await http.post(Uri.parse(URL + '/seller/logout'), body: (body));

  await storage.deleteAll();
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return true;
  } else {
    // If the server did not return a 200 OK response,
    // then return an exception.
    return false;
  }
}

Future<dynamic> createSellerUser(body) async {
  final response = await http.post(Uri.parse(URL + '/seller'), body: body);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return true;
  } else {
    // If the server did not return a 200 OK response,
    // then return an exception.
    return false;
  }
}

Future<dynamic> getCurrentUser() async {
  return await getCurrentUserAuth();
}

dynamic getCurrentUserAuth() async {
  storage.readAll();
  dynamic data = await storage.readAll();
  return jsonDecode(data["User"]);
}
