import 'package:flutter/material.dart';
import 'review_card.dart';

// File-level reviews so other widgets can read the current count.
const List<ReviewData> _reviews = [
  ReviewData(
    image: "assets/images/avatarimg.png",
    name: 'Merry',
    role: 'Student',
    rating: '4.5',
    comment:
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since.',
  ),
  ReviewData(
    image: "assets/images/avatar.png",
    name: 'Noah',
    role: 'Designer',
    rating: '4.8',
    comment:
        'Professional driver, clean car and perfect timing. The whole ride felt smooth and safe for city travel.',
  ),
  ReviewData(
    image: "assets/images/avatarimg.png",
    name: 'Ava',
    role: 'Founder',
    rating: '4.6',
    comment:
        'Booking was quick and transparent. I liked the route update and the comfort level during peak traffic.',
  ),
];

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

class ReviewSlider extends StatefulWidget {
  const ReviewSlider({super.key, required this.onPageChanged});
  final ValueChanged<int> onPageChanged;


  static int get count => _reviews.length;

  @override
  State<ReviewSlider> createState() => _ReviewSliderState();
}

class _ReviewSliderState extends State<ReviewSlider> {
  final _controller = PageController(viewportFraction: 1);

  static const List<ReviewData> _reviews = [
    ReviewData(
      image: "assets/images/avatarimg.png",
      name: 'Merry',
      role: 'Student',
      rating: '4.5',
      comment:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since.',
    ),

    ReviewData(
      image: "assets/images/avatar.png",
      name: 'Noah',
      role: 'Designer',
      rating: '4.8',
      comment:
          'Professional driver, clean car and perfect timing. The whole ride felt smooth and safe for city travel.',
    ),
    ReviewData(
      image: "assets/images/avatarimg.png",
      name: 'Ava',
      role: 'Founder',
      rating: '4.6',
      comment:
          'Booking was quick and transparent. I liked the route update and the comfort level during peak traffic.',
    ),
    
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: double.infinity,
      child: PageView.builder(
        padEnds: false,
        clipBehavior: Clip.none,
        controller: _controller,
        onPageChanged: widget.onPageChanged,
        itemCount: _reviews.length,
        itemBuilder: (context, index) {
          final review = _reviews[index];

          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double value = 1.0;

              if (_controller.position.haveDimensions) {
                value = _controller.page! - index;
                value = (1 - (value.abs() * 0.2)).clamp(0.85, 1.0);
              }

              return Center(
                child: Transform.scale(scale: value, child: child),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: ReviewCard(
                image: review.image,
                name: review.name,
                role: review.role,
                rating: review.rating,
                comment: review.comment,
              ),
            ),
          );
        },
      ),
    );
  }
}
