import 'dart:async';
import 'dart:convert';
import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/services/interceptors.dart';

import '../constant.dart';

Map<String, String> customHeaders = {"content-type": "application/json"};

Future<dynamic> createConsumerUser(body) async {
  return await http.post(URIwrapper('/consumer'), body: body);
}

Uri URIwrapper(String url) {
  return Uri.parse(URL + url);
}

Future<bool> checkIfFilledService(String consumerid) async {
  final response =
      await http.get(URIwrapper('/consumer?consumer_id=' + consumerid));

  if (response.statusCode == 200) {
    if (jsonDecode(response.body)['message']['name'] != null) {
      return true;
    }
    return false;
  } else {
    return false;
  }
}

Future<Consumer> getConsumer(String consumerid) async {
  final response =
      await http.get(URIwrapper('/consumer?consumer_id=' + consumerid));

  if (response.statusCode == 200) {
    return Consumer.fromJson(jsonDecode(response.body)['message']);
  } else {
    return Consumer.fromJson({});
  }
}

Future<Seller> getSeller(String sellerId) async {
  final response = await http.get(URIwrapper('/seller?seller_id=' + sellerId));

  if (response.statusCode == 200) {
    print(jsonDecode(response.body)['message']);
    return Seller.fromJson(jsonDecode(response.body)['message']);
  } else {
    return Seller.fromJson({});
  }
}

Future<bool> checkIfFilledSellerService(String sellerId) async {
  final response = await http.get(URIwrapper('/seller?seller_id=' + sellerId));

  if (response.statusCode == 200) {
    if (jsonDecode(response.body)['message']['name'] != null) {
      return true;
    }
    return false;
  } else {
    return false;
  }
}

Future<List<Seller>> getAllSellers(String consumerid) async {
  final response = await http.get(
      URIwrapper('/subscription/consumer/getall?consumer_id=' + consumerid));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // print(jsonDecode(response.body)['message']);
    return parseSeller(jsonEncode(jsonDecode(response.body)['message']));
  } else {
    // If the server did not return a 200 OK response,
    // then return an exception.
    return [];
  }
}

Future<List<Consumer>> getAllSubscribedConsumers(String sellerid) async {
  final response = await http
      .get(URIwrapper('/subscription/seller/getall?seller_id=' + sellerid));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return parseConsumer(jsonEncode(jsonDecode(response.body)['message']));
  } else {
    // If the server did not return a 200 OK response,
    // then return an exception.
    return [];
  }
}

Future<List<Groups>> getAllGroupsSeller(String sellerId) async {
  final response =
      await http.get(URIwrapper('/groups/seller?seller_id=' + sellerId));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return parseGroups(jsonEncode(jsonDecode(response.body)['message']));
  } else {
    // If the server did not return a 200 OK response,
    // then return an exception.
    return [];
  }
}

Future<List<Groups>> getAllGroups(String sellerId) async {
  final response = await http
      .get(URIwrapper('/groups/getall/consumer?seller_id=' + sellerId));
  print(jsonDecode(response.body)['message']);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return parseGroups(jsonEncode(jsonDecode(response.body)['message']));
  } else {
    // If the server did not return a 200 OK response,
    // then return an exception.
    return [];
  }
}

Future<List<Products>> getAllProducts(String groupId) async {
  final response =
      await http.get(URIwrapper('/product/getall?group_id=' + groupId));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(jsonEncode(jsonDecode(response.body)['message']));

    return parseProducts(jsonEncode(jsonDecode(response.body)['message']));
  } else {
    // If the server did not return a 200 OK response,
    // then return an exception.
    return [];
  }
}

Future<List<Products>> getAllProductsSeller(String sellerId) async {
  final response = await http
      .get(URIwrapper('/product/seller/getall?seller_id=' + sellerId));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(jsonEncode(jsonDecode(response.body)['message']));
    return parseProducts(jsonEncode(jsonDecode(response.body)['message']));
  } else {
    // If the server did not return a 200 OK response,
    // then return an exception.
    return [];
  }
}

Future<dynamic> getAllOrders(String consumerId) async {
  final response = await http
      .get(URIwrapper('/order/consumer/getall?consumer_id=' + consumerId));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    // print(jsonEncode(jsonDecode(response.body)['message']));
    print(jsonDecode(response.body)['message']);

    return {
      "addresses":
          parseAddresses(jsonEncode(jsonDecode(response.body)['addresses'])),
      "products":
          parseProducts(jsonEncode(jsonDecode(response.body)['message']))
    };
  } else {
    // If the server did not return a 200 OK response,
    // then return an exception.
    return {"addresses": [], "products": []};
  }
}

Future<List<Products>> getAllOrdersConsumerSellers(
    String consumerId, String sellerId) async {
  final response = await http.get(URIwrapper(
      '/order/consumerSeller/getall?consumer_id=$consumerId&seller_id=$sellerId'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(jsonEncode(jsonDecode(response.body)['message']));

    return parseProducts(jsonEncode(jsonDecode(response.body)['message']));
  } else {
    // If the server did not return a 200 OK response,
    // then return an exception.
    return [];
  }
}

Future<dynamic> getDashboardContent(String sellerId) async {
  final response = await http
      .get(URIwrapper('/product/seller/dashboard?seller_id=' + sellerId));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return jsonDecode(response.body)['message'];
  } else {
    // If the server did not return a 200 OK response,
    // then return an exception.
    return [];
  }
}

Future<List<Consumer>> getAllOrdersSeller(String sellerId) async {
  final response =
      await http.get(URIwrapper('/order/seller/getall?seller_id=' + sellerId));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return parseConsumer(jsonEncode(jsonDecode(response.body)['message']));
  } else {
    // If the server did not return a 200 OK response,
    // then return an exception.
    return [];
  }
}

Future<bool> createSubscription(String consumerid, String email) async {
  final response = await http.post(
      URIwrapper('/subscription/email?consumer_id=' + consumerid),
      body: {"email": email});

  if (jsonDecode(response.body)['message'] == true) {
    // If the server did return a 200 OK response,
    print(jsonDecode(response.body)['message'].runtimeType);
    // then parse the JSON.
    return true;
  } else {
    // If the server did not return a 200 OK response,
    // then return an exception.
    return false;
  }
}

Future<dynamic> createOrder(String groupid, String consumerid, String productId,
    int quantity, String orderStatus, totalQuantity) async {
  Map data = {
    "consumer_id": consumerid,
    "product_id": productId,
    "quantity": quantity.toString(),
    "order_status": orderStatus
  };

  final response = await http.post(
      URIwrapper('/order?group_id=$groupid&total_quantity=$totalQuantity'),
      body: data);

  if (response.statusCode == 302) {
    return 'available';
  }
  if (jsonDecode(response.body)['message'] == true) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return true;
  } else {
    // If the server did not return a 200 OK response,
    // then return an exception.
    return false;
  }
}

Future<bool> deleteOrderFromCart(
    String group_id, String orderid, String productId, int quantity) async {
  final response = await http.delete(URIwrapper(
      '/order/consumer?order_id=$orderid&quantity=$quantity&product_id=$productId&group_id=$group_id'));
  if (jsonDecode(response.body)['message'] == true) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return true;
  } else {
    // If the server did not return a 200 OK response,
    // then return an exception.
    return false;
  }
}

Future<bool> updateConsumer(dynamic bodyData) async {
  final response = await http.put(URIwrapper('/consumer'), body: bodyData);
  print(response.statusCode);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    return true;
  } else {
    // If the server did not return a 200 OK response,
    // then return an exception.
    return false;
  }
}

Future<bool> updateSeller(dynamic bodyData) async {
  final response = await http.put(URIwrapper('/seller'), body: bodyData);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    return true;
  } else {
    // If the server did not return a 200 OK response,
    // then return an exception.
    return false;
  }
}

Future<bool> addProductSeller(dynamic bodyData) async {
  Map<String, String> customHeaders = {"content-type": "application/json"};
  final response = await http.post(URIwrapper('/product'),
      headers: customHeaders, body: jsonEncode(bodyData));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    return true;
  } else {
    // If the server did not return a 200 OK response,
    // then return an exception.
    return false;
  }
}

Future<bool> addGroupSeller(dynamic bodyData) async {
  final response = await http.post(URIwrapper('/groups'),
      headers: customHeaders, body: jsonEncode(bodyData));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    return true;
  } else {
    // If the server did not return a 200 OK response,
    // then return an exception.
    return false;
  }
}

Future<bool> updateProductGroup(dynamic bodyData) async {
  final response = await http.post(URIwrapper('/groupsProducts'),
      headers: customHeaders, body: jsonEncode(bodyData));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    return true;
  } else {
    // If the server did not return a 200 OK response,
    // then return an exception.
    return false;
  }
}

Future<bool> editGroupSeller(dynamic bodyData) async {
  final response = await http.put(URIwrapper('/groups'),
      headers: customHeaders, body: jsonEncode(bodyData));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    return true;
  } else {
    // If the server did not return a 200 OK response,
    // then return an exception.
    return false;
  }
}

Future<bool> updateOrderStatusByOrder(String orderId, String status) async {
  final response = await http.put(URIwrapper('/order?consumer_id=$orderId'),
      // headers: customHeaders,
      body: {"order_id": orderId, "order_status": status});

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    return true;
  } else {
    // If the server did not return a 200 OK response,
    // then return an exception.
    return false;
  }
}

Future<dynamic> updateOrderStatus(
    String consumerId, String addressId, String paymentType) async {
  print(addressId);
  final response = await http.put(URIwrapper(
      '/order/consumer?consumer_id=$consumerId&address_id=$addressId&payment_type=$paymentType'));

  if (response.statusCode == 409) {
    return 'outOfStock';
  }

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    return true;
  } else {
    // If the server did not return a 200 OK response,
    // then return an exception.
    return false;
  }
}

Future<bool> deleteSubscription(String consumerid, String sellerId) async {
  final response = await http.delete(URIwrapper(
      '/subscription?consumer_id=' + consumerid + '&seller_id=' + sellerId));

  if (jsonDecode(response.body)['message'] == 'deleted successfully') {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return true;
  } else {
    // If the server did not return a 200 OK response,
    // then return an exception.
    return false;
  }
}
