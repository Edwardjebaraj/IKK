import 'dart:convert';

class ProductItem {
  ProductItem({
    this.productId,
    this.sellerId,
    this.productName,
    this.productDescription,
    this.productImages,
    this.quantity,
    this.price,
    this.productCategory,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  String productId;
  String sellerId;
  String productName;
  String productDescription;
  String productImages;
  int quantity;
  int price;
  String productCategory;
  int status;
  String createdAt;
  String updatedAt;

  factory ProductItem.fromRawJson(String str) =>
      ProductItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductItem.fromJson(Map<String, dynamic> json) => ProductItem(
        productId: json["product_id"],
        sellerId: json["seller_id"],
        productName: json["product_name"],
        productDescription: json["product_description"],
        productImages: json["product_images"],
        quantity: json["quantity"],
        price: json["price"],
        productCategory: json["product_category"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "seller_id": sellerId,
        "product_name": productName,
        "product_description": productDescription,
        "product_images": productImages,
        "quantity": quantity,
        "price": price,
        "product_category": productCategory,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class OrderItem {
  OrderItem({
    this.orderId,
    this.consumerId,
    this.productId,
    this.quantity,
    this.orderStatus,
    this.createdAt,
    this.updatedAt,
  });

  String orderId;
  String consumerId;
  String productId;
  String quantity;
  String orderStatus;
  String createdAt;
  String updatedAt;

  factory OrderItem.fromRawJson(String str) =>
      OrderItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        orderId: json["order_id"],
        consumerId: json["consumer_id"],
        productId: json["product_id"],
        quantity: json["quantity"],
        orderStatus: json["order_status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "consumer_id": consumerId,
        "product_id": productId,
        "quantity": quantity,
        "order_status": orderStatus,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
