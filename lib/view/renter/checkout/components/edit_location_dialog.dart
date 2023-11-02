import 'package:flutter/material.dart';
import 'package:iclean_mobile_app/models/account.dart';
import 'package:iclean_mobile_app/utils/color_palette.dart';
import 'package:iclean_mobile_app/widgets/main_color_inkwell_full_size.dart';

import 'list_location_content.dart';

class EditLocationDialog extends StatelessWidget {
  const EditLocationDialog({
    super.key,
    required this.account,
  });

  final Account account;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const Text(
                  "Địa chỉ của bạn",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lato',
                  ),
                ),
                const Divider(
                  thickness: 0.5,
                  color: ColorPalette.greyColor,
                ),
                const ListLocationContent(),
                const Divider(
                  thickness: 0.5,
                  color: ColorPalette.greyColor,
                ),
                const SizedBox(height: 8),
                MainColorInkWellFullSize(
                  onTap: () {},
                  text: "Thêm địa chỉ khác",
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
