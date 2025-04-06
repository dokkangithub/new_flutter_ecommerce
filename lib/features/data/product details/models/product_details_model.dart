import '../../../domain/product details/entities/product_details.dart';

class ProductDetailsModel {
  final int id;
  final String slug;
  final String name;
  final String mainCategoryName;
  final int mainCategoryId;
  final String addedBy;
  final int sellerId;
  final int shopId;
  final String shopSlug;
  final String shopName;
  final String shopLogo;
  final List<PhotoModel> photos;
  final String thumbnailImage;
  final List<String> tags;
  final String priceHighLow;
  final List<dynamic> choiceOptions;
  final List<dynamic> colors;
  final bool hasVariation;
  final bool hasDiscount;
  final String discount;
  final String strokedPrice;
  final String mainPrice;
  final double calculablePrice;
  final String currencySymbol;
  final int currentStock;
  final String unit;
  final int rating;
  final int ratingCount;
  final int earnPoint;
  final String description;
  final dynamic downloads;
  final String videoLink;
  final BrandModel brand;
  final String link;
  final List<dynamic> wholesale;
  final int estShippingTime;

  ProductDetailsModel({
    required this.id,
    required this.slug,
    required this.name,
    required this.mainCategoryName,
    required this.mainCategoryId,
    required this.addedBy,
    required this.sellerId,
    required this.shopId,
    required this.shopSlug,
    required this.shopName,
    required this.shopLogo,
    required this.photos,
    required this.thumbnailImage,
    required this.tags,
    required this.priceHighLow,
    required this.choiceOptions,
    required this.colors,
    required this.hasVariation,
    required this.hasDiscount,
    required this.discount,
    required this.strokedPrice,
    required this.mainPrice,
    required this.calculablePrice,
    required this.currencySymbol,
    required this.currentStock,
    required this.unit,
    required this.rating,
    required this.ratingCount,
    required this.earnPoint,
    required this.description,
    required this.downloads,
    required this.videoLink,
    required this.brand,
    required this.link,
    required this.wholesale,
    required this.estShippingTime,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsModel(
      id: json['id'] ?? 0,
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      mainCategoryName: json['main_category_name'] ?? '',
      mainCategoryId: json['main_category_id'] ?? 0,
      addedBy: json['added_by'] ?? '',
      sellerId: json['seller_id'] ?? 0,
      shopId: json['shop_id'] ?? 0,
      shopSlug: json['shop_slug'] ?? '',
      shopName: json['shop_name'] ?? '',
      shopLogo: json['shop_logo'] ?? '',
      photos: (json['photos'] as List?)
          ?.map((photo) => PhotoModel.fromJson(photo))
          .toList() ??
          [],
      thumbnailImage: json['thumbnail_image'] ?? '',
      tags: (json['tags'] as List?)?.map((tag) => tag.toString()).toList() ?? [],
      priceHighLow: json['price_high_low'] ?? '',
      choiceOptions: json['choice_options'] ?? [],
      colors: json['colors'] ?? [],
      hasVariation: json['has_variation'] ?? false,
      hasDiscount: json['has_discount'] ?? false,
      discount: json['discount'] ?? '',
      strokedPrice: json['stroked_price'] ?? '',
      mainPrice: json['main_price'] ?? '',
      calculablePrice: (json['calculable_price'] ?? 0).toDouble(),
      currencySymbol: json['currency_symbol'] ?? '',
      currentStock: json['current_stock'] ?? 0,
      unit: json['unit'] ?? '',
      rating: json['rating'] ?? 0,
      ratingCount: json['rating_count'] ?? 0,
      earnPoint: json['earn_point'] ?? 0,
      description: json['description'] ?? '',
      downloads: json['downloads'],
      videoLink: json['video_link'] ?? '',
      brand: BrandModel.fromJson(json['brand'] ?? {}),
      link: json['link'] ?? '',
      wholesale: json['wholesale'] ?? [],
      estShippingTime: json['est_shipping_time'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'name': name,
      'main_category_name': mainCategoryName,
      'main_category_id': mainCategoryId,
      'added_by': addedBy,
      'seller_id': sellerId,
      'shop_id': shopId,
      'shop_slug': shopSlug,
      'shop_name': shopName,
      'shop_logo': shopLogo,
      'photos': photos.map((photo) => photo.toJson()).toList(),
      'thumbnail_image': thumbnailImage,
      'tags': tags,
      'price_high_low': priceHighLow,
      'choice_options': choiceOptions,
      'colors': colors,
      'has_variation': hasVariation,
      'has_discount': hasDiscount,
      'discount': discount,
      'stroked_price': strokedPrice,
      'main_price': mainPrice,
      'calculable_price': calculablePrice,
      'currency_symbol': currencySymbol,
      'current_stock': currentStock,
      'unit': unit,
      'rating': rating,
      'rating_count': ratingCount,
      'earn_point': earnPoint,
      'description': description,
      'downloads': downloads,
      'video_link': videoLink,
      'brand': brand.toJson(),
      'link': link,
      'wholesale': wholesale,
      'est_shipping_time': estShippingTime,
    };
  }

  ProductDetails toEntity() {
    return ProductDetails(
      id: id,
      slug: slug,
      name: name,
      mainCategoryName: mainCategoryName,
      mainCategoryId: mainCategoryId,
      shopName: shopName,
      shopLogo: shopLogo,
      photos: photos.map((photo) => photo.toEntity()).toList(),
      thumbnailImage: thumbnailImage,
      price: mainPrice,
      calculablePrice: calculablePrice,
      currencySymbol: currencySymbol,
      currentStock: currentStock,
      unit: unit,
      rating: rating,
      ratingCount: ratingCount,
      description: description,
      hasDiscount: hasDiscount,
      discount: discount,
      strokedPrice: strokedPrice,
      brand: brand.toEntity(),
      colors: colors.map((color) => color.toString()).toList(), // Convert List<dynamic> to List<String>
    );
  }}

class PhotoModel {
  final String variant;
  final String path;

  PhotoModel({
    required this.variant,
    required this.path,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      variant: json['variant'] ?? '',
      path: json['path'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'variant': variant,
      'path': path,
    };
  }

  Photo toEntity() {
    return Photo(
      variant: variant,
      path: path,
    );
  }
}

class BrandModel {
  final int id;
  final String name;
  final String slug;
  final String logo;

  BrandModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.logo,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      logo: json['logo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'logo': logo,
    };
  }

  Brand toEntity() {
    return Brand(
      id: id,
      name: name,
      slug: slug,
      logo: logo,
    );
  }
}

class ProductResponseModel {
  final List<ProductDetailsModel> data;
  final LinkModel links;
  final MetaModel meta;
  final bool success;
  final int status;

  ProductResponseModel({
    required this.data,
    required this.links,
    required this.meta,
    required this.success,
    required this.status,
  });

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductResponseModel(
      data: (json['data'] as List?)
          ?.map((product) => ProductDetailsModel.fromJson(product))
          .toList() ??
          [],
      links: LinkModel.fromJson(json['links'] ?? {}),
      meta: MetaModel.fromJson(json['meta'] ?? {}),
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((product) => product.toJson()).toList(),
      'links': links.toJson(),
      'meta': meta.toJson(),
      'success': success,
      'status': status,
    };
  }

  ProductResponse toEntity() {
    return ProductResponse(
      data: data.map((product) => product.toEntity()).toList(),
      links: links.toEntity(),
      meta: meta.toEntity(),
      success: success,
      status: status,
    );
  }
}

class LinkModel {
  final String? first;
  final String? last;
  final String? prev;
  final String? next;

  LinkModel({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  factory LinkModel.fromJson(Map<String, dynamic> json) {
    return LinkModel(
      first: json['first'],
      last: json['last'],
      prev: json['prev'],
      next: json['next'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first': first,
      'last': last,
      'prev': prev,
      'next': next,
    };
  }

  Links toEntity() {
    return Links(
      first: first,
      last: last,
      prev: prev,
      next: next,
    );
  }
}

class MetaLinkModel {
  final String? url;
  final String label;
  final bool active;

  MetaLinkModel({
    this.url,
    required this.label,
    required this.active,
  });

  factory MetaLinkModel.fromJson(Map<String, dynamic> json) {
    return MetaLinkModel(
      url: json['url'],
      label: json['label'] ?? '',
      active: json['active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'active': active,
    };
  }

  MetaLink toEntity() {
    return MetaLink(
      url: url,
      label: label,
      active: active,
    );
  }
}

class MetaModel {
  final int currentPage;
  final int from;
  final int lastPage;
  final List<MetaLinkModel> links;
  final String path;
  final int perPage;
  final int to;
  final int total;

  MetaModel({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.links,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  factory MetaModel.fromJson(Map<String, dynamic> json) {
    return MetaModel(
      currentPage: json['current_page'] ?? 0,
      from: json['from'] ?? 0,
      lastPage: json['last_page'] ?? 0,
      links: (json['links'] as List?)
          ?.map((link) => MetaLinkModel.fromJson(link))
          .toList() ??
          [],
      path: json['path'] ?? '',
      perPage: json['per_page'] ?? 0,
      to: json['to'] ?? 0,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'from': from,
      'last_page': lastPage,
      'links': links.map((link) => link.toJson()).toList(),
      'path': path,
      'per_page': perPage,
      'to': to,
      'total': total,
    };
  }

  Meta toEntity() {
    return Meta(
      currentPage: currentPage,
      from: from,
      lastPage: lastPage,
      links: links.map((link) => link.toEntity()).toList(),
      path: path,
      perPage: perPage,
      to: to,
      total: total,
    );
  }
}

