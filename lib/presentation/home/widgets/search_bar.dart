import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/core/utils/constants/app_assets.dart';
import 'package:laravel_ecommerce/core/utils/widgets/custom_cached_image.dart';
import 'package:laravel_ecommerce/core/utils/widgets/custom_form_field.dart';

class CustomSearchBar extends StatefulWidget {
   const CustomSearchBar({super.key});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  TextEditingController searchController =TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextFormField(controller: searchController,hint: 'search for yours',),
        ),
        const SizedBox(width: 12),
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: CustomImage(assetPath: AppSvgs.filter),
        ),
      ],
    );
  }
}
