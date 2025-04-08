import 'package:flutter/material.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../domain/wishlist/entities/wishlist_details.dart';
import '../../../domain/wishlist/usecases/add_wishlist_usecases.dart';
import '../../../domain/wishlist/usecases/check_wishlist_usecases.dart';
import '../../../domain/wishlist/usecases/get_wishlist_usecases.dart';
import '../../../domain/wishlist/usecases/remove_wishlist_usecases.dart';

class WishlistProvider extends ChangeNotifier {
  final GetWishlistUseCase getWishlistUseCase;
  final CheckWishlistUseCase checkWishlistUseCase;
  final AddToWishlistUseCase addToWishlistUseCase;
  final RemoveFromWishlistUseCase removeFromWishlistUseCase;

  WishlistProvider({
    required this.getWishlistUseCase,
    required this.checkWishlistUseCase,
    required this.addToWishlistUseCase,
    required this.removeFromWishlistUseCase,
  });

  LoadingState wishlistState = LoadingState.loading;
  List<WishlistItem> wishlistItems = [];
  String wishlistError = '';
  Map<String, bool> wishlistStatus = {};
  String? lastActionMessage;

  Future<void> fetchWishlist() async {
    try {
      wishlistState = LoadingState.loading;
      notifyListeners();

      wishlistItems = await getWishlistUseCase();
      wishlistState = LoadingState.loaded;
    } catch (e) {
      wishlistState = LoadingState.error;
      wishlistError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<bool> isInWishlist(String slug) async {
    try {
      final check = await checkWishlistUseCase(slug);
      wishlistStatus[slug] = check.isInWishlist;
      notifyListeners();
      return check.isInWishlist;
    } catch (e) {
      wishlistError = e.toString();
      return false;
    }
  }

  Future<void> addToWishlist(String slug) async {
    try {
      final result = await addToWishlistUseCase(slug);
      wishlistStatus[slug] = result.isInWishlist;
      lastActionMessage = result.message;
      await fetchWishlist(); // Refresh wishlist
      notifyListeners();
    } catch (e) {
      wishlistError = e.toString();
      notifyListeners();
    }
  }

  Future<void> removeFromWishlist(String slug) async {
    try {
      final result = await removeFromWishlistUseCase(slug);
      wishlistStatus[slug] = result.isInWishlist;
      lastActionMessage = result.message;
      await fetchWishlist(); // Refresh wishlist
      notifyListeners();
    } catch (e) {
      wishlistError = e.toString();
      notifyListeners();
    }
  }

  // Method to clear the entire wishlist
  Future<void> clearWishlist() async {
    try {
      // Create a copy to avoid modifying during iteration
      final itemsToRemove = List<WishlistItem>.from(wishlistItems);

      for (var item in itemsToRemove) {
        await removeFromWishlist(item.slug);
      }

      lastActionMessage = "Wishlist cleared successfully";
      notifyListeners();
    } catch (e) {
      wishlistError = e.toString();
      notifyListeners();
    }
  }
}