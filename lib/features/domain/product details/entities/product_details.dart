class ProductDetails {
  final int id;
  final String slug;
  final String name;
  final String mainCategoryName;
  final int mainCategoryId;
  final String shopName;
  final String shopLogo;
  final List<Photo> photos;
  final String thumbnailImage;
  final String price;
  final double calculablePrice;
  final String currencySymbol;
  final int currentStock;
  final String unit;
  final int rating;
  final int ratingCount;
  final String description;
  final bool hasDiscount;
  final String discount;
  final String strokedPrice;
  final Brand brand;
  final List<String> colors; // Added colors field

  ProductDetails({
    required this.id,
    required this.slug,
    required this.name,
    required this.mainCategoryName,
    required this.mainCategoryId,
    required this.shopName,
    required this.shopLogo,
    required this.photos,
    required this.thumbnailImage,
    required this.price,
    required this.calculablePrice,
    required this.currencySymbol,
    required this.currentStock,
    required this.unit,
    required this.rating,
    required this.ratingCount,
    required this.description,
    required this.hasDiscount,
    required this.discount,
    required this.strokedPrice,
    required this.brand,
    required this.colors, // Added to constructor
  });
}

class Photo {
  final String variant;
  final String path;

  Photo({
    required this.variant,
    required this.path,
  });
}

class Brand {
  final int id;
  final String name;
  final String slug;
  final String logo;

  Brand({
    required this.id,
    required this.name,
    required this.slug,
    required this.logo,
  });
}

class ProductResponse {
  final List<ProductDetails> data;
  final Links links;
  final Meta meta;
  final bool success;
  final int status;

  ProductResponse({
    required this.data,
    required this.links,
    required this.meta,
    required this.success,
    required this.status,
  });
}

class Links {
  final String? first;
  final String? last;
  final String? prev;
  final String? next;

  Links({
    this.first,
    this.last,
    this.prev,
    this.next,
  });
}

class MetaLink {
  final String? url;
  final String label;
  final bool active;

  MetaLink({
    this.url,
    required this.label,
    required this.active,
  });
}

class Meta {
  final int currentPage;
  final int from;
  final int lastPage;
  final List<MetaLink> links;
  final String path;
  final int perPage;
  final int to;
  final int total;

  Meta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.links,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });
}