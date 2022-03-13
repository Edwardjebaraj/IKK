import 'dart:convert';

class Product {
  String image;
  String name;
  String description;
  double price;

  Product(this.image, this.name, this.description, this.price);
}

List<Consumer> parseConsumer(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Consumer>((json) => Consumer.fromJson(json)).toList();
}

class Consumer {
  String consumer_id;
  String name;
  String phone_number;
  String email;
  String address;
  String city;
  String zipcode;
  String business_name;
  String order_status;
  String display_picture;
  String created_at;
  String updated_at;

  Consumer(
      {this.consumer_id,
      this.name,
      this.phone_number,
      this.email,
      this.city,
      this.address,
      this.zipcode,
      this.business_name,
      this.order_status,
      this.display_picture,
      this.created_at,
      this.updated_at});

  Consumer.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        consumer_id = json['consumer_id'],
        phone_number = json['phone_number'],
        city = json['city'],
        address = json['address'],
        zipcode = json['zipcode'],
        business_name = json['business_name'],
        display_picture = json['display_picture'],
        order_status = json['order_status'],
        created_at = json['created_at'],
        updated_at = json['updated_at'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'consumer_id': consumer_id,
        'phone_number': phone_number,
        'city': city,
        'address': address,
        'zipcode': zipcode,
        'business_name': business_name,
        'order_status': order_status,
        'display_picture': display_picture,
        'created_at': created_at,
        'updated_at': updated_at
      };
}

List<Products> parseProducts(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Products>((json) => Products.fromJson(json)).toList();
}

class Products {
  String seller_id;
  String product_id;
  dynamic group_id;
  String order_id;
  String product_images;
  String product_name;
  String product_description;
  int price;
  int quantity;
  int orderedQuantity;
  String product_category;
  String address;
  String pickup_time;
  String created_at;
  String updated_at;
  String start_time;
  String end_time;
  String group_name;
  int delivery;
  int status;
  String order_status;
  Products({
    this.seller_id,
    this.product_id,
    this.order_id,
    this.group_id,
    this.product_images,
    this.product_name,
    this.product_description,
    this.price,
    this.pickup_time,
    this.address,
    this.quantity,
    this.product_category,
    this.start_time,
    this.end_time,
    this.delivery,
    this.status,
    this.order_status,
    this.group_name,
    this.created_at,
    this.updated_at,
  });
  Products.fromJson(Map<String, dynamic> json)
      : seller_id = json['seller_id'],
        product_id = json['product_id'],
        group_id = json['group_id'],
        order_id = json['order_id'],
        product_images = json['product_images'],
        product_name = json['product_name'],
        product_description = json['product_description'],
        price = json['price'],
        quantity = json['quantity'],
        orderedQuantity = json['orderedQuantity'] ?? 0,
        product_category = json['product_category'],
        start_time = json['start_time'],
        pickup_time = json['pickup_time'],
        address = json['address'],
        end_time = json['end_time'],
        delivery = json['delivery'],
        status = json['status'],
        order_status = json['order_status'],
        group_name = json['group_name'],
        created_at = json['created_at'],
        updated_at = json['updated_at'];

  Map<String, dynamic> toJson() => {
        'seller_id': seller_id,
        'product_id': product_id,
        'group_id': group_id,
        'order_id': order_id,
        'product_images': product_images,
        'product_name': product_name,
        'product_description': product_description,
        'price': price,
        'address': address,
        'quantity': quantity,
        'pickup_time': pickup_time,
        'orderedQuantity': orderedQuantity,
        'product_category': product_category,
        'start_time': start_time,
        'delivery': delivery,
        'end_time': end_time,
        'status': status,
        'order_status': order_status,
        'group_name': group_name,
        'created_at': created_at,
        'updated_at': updated_at
      };
}

List<Seller> parseSeller(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Seller>((json) => Seller.fromJson(json)).toList();
}

class Seller {
  String seller_id;
  String name;
  String phone_number;
  String business_category;
  String email;
  String address;
  String city;
  String zipcode;
  String business_name;
  String display_picture;
  String created_at;
  String updated_at;
  List<String> businessAddresses;

  Seller(
      {this.seller_id,
      this.name,
      this.phone_number,
      this.business_category,
      this.email,
      this.city,
      this.address,
      this.zipcode,
      this.business_name,
      this.display_picture,
      this.created_at,
      this.updated_at,
      this.businessAddresses});

  Seller.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        business_category = json['business_category'],
        seller_id = json['seller_id'],
        phone_number = json['phone_number'],
        city = json['city'],
        address = json['address'],
        zipcode = json['zipcode'],
        business_name = json['business_name'],
        display_picture = json['display_picture'],
        created_at = json['created_at'],
        updated_at = json['updated_at'],
        businessAddresses = json['business_addresses'].cast<String>();

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'business_category': business_category,
        'seller_id': seller_id,
        'phone_number': phone_number,
        'city': city,
        'address': address,
        'zipcode': zipcode,
        'business_name': business_name,
        'display_picture': display_picture,
        'created_at': created_at,
        'updated_at': updated_at,
        'business_addresses': businessAddresses
      };
}

List<Groups> parseGroups(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Groups>((json) => Groups.fromJson(json)).toList();
}

class Groups {
  String groupId;
  String sellerId;
  int delivery;
  int disabled;
  String startTime;
  String endTime;
  String groupName;

  String createdAt;
  String updatedAt;

  Groups(
      {this.groupId,
      this.sellerId,
      this.delivery,
      this.disabled,
      this.startTime,
      this.endTime,
      this.groupName,
      this.createdAt,
      this.updatedAt});

  Groups.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    sellerId = json['seller_id'];
    groupName = json['group_name'];
    delivery = json['delivery'];
    disabled = json['disabled'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group_id'] = this.groupId;
    data['seller_id'] = this.sellerId;
    data['group_name'] = this.groupName;
    data['delivery'] = this.delivery;
    data['disabled'] = this.delivery;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

List<Addresses> parseAddresses(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Addresses>((json) => Addresses.fromJson(json)).toList();
}

class Addresses {
  String addressId;
  String groupId;
  String pickupTime;
  String address;
  String createdAt;
  String updatedAt;

  Addresses(
      {this.groupId,
      this.addressId,
      this.pickupTime,
      this.address,
      this.createdAt,
      this.updatedAt});

  Addresses.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    addressId = json['address_id'];
    pickupTime = json['pickup_time'];
    address = json['address'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group_id'] = this.groupId;
    data['address_id'] = this.addressId;
    data['pickup_time'] = this.pickupTime;
    data['address'] = this.address;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
