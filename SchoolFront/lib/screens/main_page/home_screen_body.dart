import 'package:flutter/material.dart';
import 'package:school/dataclasses/review.dart';
import 'package:school/screens/main_page/widgets/home_screen_widgets.dart';


class HomeScreenBody extends StatelessWidget {
  final String profileImageUrl;
  final List<Review> reviews;

  const HomeScreenBody({
    Key? key,
    required this.profileImageUrl,
    required this.reviews,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.blue.shade100],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: buildInfoCard()),
            const SizedBox(width: 20),
            Expanded(child: buildProfileAndReviews(context, profileImageUrl, reviews)),
          ],
        ),
      ),
    );
  }
}
