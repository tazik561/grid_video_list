class CategoryItemModel {
  Pagination pagination;
  List<Data> data;

  CategoryItemModel({this.pagination, this.data});

  CategoryItemModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pagination {
  int currentPage;
  int total;
  int lastPage;
  int perPage;

  Pagination({this.currentPage, this.total, this.lastPage, this.perPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    total = json['total'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['total'] = this.total;
    data['last_page'] = this.lastPage;
    data['per_page'] = this.perPage;
    return data;
  }
}

class Data {
  int id;
  String title;
  String source;
  String description;
  String format;
  bool isMain;
  bool isFollowed;
  bool isBought;
  int viewCount;
  String rate;
  List<String> tags;
  Product product;
  Category category;

  Data(
      {this.id,
      this.title,
      this.source,
      this.description,
      this.format,
      this.isMain,
      this.isFollowed,
      this.isBought,
      this.viewCount,
      this.rate,
      this.tags,
      this.product,
      this.category});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    source = json['source'];
    description = json['description'];
    format = json['format'];
    isMain = json['is_main'];
    isFollowed = json['is_followed'];
    isBought = json['is_bought'];
    viewCount = json['view_count'];
    rate = json['rate'];
    tags = json['tags'].cast<String>();
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['source'] = this.source;
    data['description'] = this.description;
    data['format'] = this.format;
    data['is_main'] = this.isMain;
    data['is_followed'] = this.isFollowed;
    data['is_bought'] = this.isBought;
    data['view_count'] = this.viewCount;
    data['rate'] = this.rate;
    data['tags'] = this.tags;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    return data;
  }
}

class Product {
  int id;
  String title;
  String price;
  int userId;
  String createdAt;
  String updatedAt;

  Product(
      {this.id,
      this.title,
      this.price,
      this.userId,
      this.createdAt,
      this.updatedAt});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['price'] = this.price;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Category {
  String title;
  int viewCount;

  Category({this.title, this.viewCount});

  Category.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    viewCount = json['view_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['view_count'] = this.viewCount;
    return data;
  }
}
