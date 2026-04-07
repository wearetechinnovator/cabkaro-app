import 'package:flutter/material.dart';
import 'review_card.dart';

class ReviewData {
  final String name;
  final String role;
  final String rating;
  final String comment;
  final String image;

  const ReviewData({
    required this.name,
    required this.role,
    required this.rating,
    required this.comment,
    required this.image,
  });
}

class ReviewSlider extends StatelessWidget {
  const ReviewSlider({super.key});

  static const List<ReviewData> _reviews = [
    ReviewData(
      image: "assets/images/avatarimg.png",
      name: 'Merry',
      role: 'Student',
      rating: '4.5',
      comment: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since.',
    ),
    ReviewData(
      image: "assets/images/avatar.png",
      name: 'Noah',
      role: 'Designer',
      rating: '4.8',
      comment: 'Professional driver, clean car and perfect timing. The whole ride felt smooth and safe for city travel.',
    ),
    ReviewData(
      image: "assets/images/avatarimg.png",
      name: 'Ava',
      role: 'Founder',
      rating: '4.6',
      comment: 'Booking was quick and transparent. I liked the route update and the comfort level during peak traffic.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth,
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: _reviews.length,
        itemBuilder: (context, index) {
          final review = _reviews[index];
          return ReviewCard(
            image:review.image,
            name: review.name,
            role: review.role,
            rating: review.rating,
            comment: review.comment,
          );
        },
      ),
    );
  }
}