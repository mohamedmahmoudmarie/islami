import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../models/hadith_model.dart';
import '../widgets/details_layout.dart';

class HadithDetailsScreen extends StatelessWidget {
  static const routeName = '/hadith-details';
  const HadithDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hadith = ModalRoute.of(context)!.settings.arguments as HadithModel;

    return DetailsLayout(
      appBarTitle: 'Hadith ${hadith.number}',
      title: hadith.title,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 130),
        child: Text(
          hadith.content,
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          style: const TextStyle(
            color: AppColors.gold,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            height: 2,
          ),
        ),
      ),
    );
  }
}
