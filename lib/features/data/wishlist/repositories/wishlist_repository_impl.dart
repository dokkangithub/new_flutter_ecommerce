import '../../../domain/wishlist/entities/wishlist_details.dart';
import '../../../domain/wishlist/repositories/wishlist_details_repository.dart';
import '../datasources/wishlist_remote_datasource.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistRemoteDataSource remoteDataSource;

  WishlistRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<WishlistItem>> getWishlist() async {
    final models = await remoteDataSource.getWishlist();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<WishlistCheck> checkWishlist(String slug) async {
    final model = await remoteDataSource.checkWishlist(slug);
    return model.toEntity();
  }

  @override
  Future<void> addToWishlist(String slug) async {
    await remoteDataSource.addToWishlist(slug);
  }

  @override
  Future<void> removeFromWishlist(String slug) async {
    await remoteDataSource.removeFromWishlist(slug);
  }
}