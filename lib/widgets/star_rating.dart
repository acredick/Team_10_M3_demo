import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final int rating;
  final int starCount;
  final double size;
  final Color color;
  final void Function(int)? onChanged;
  final double spacing;

  const StarRating({
    super.key,
    required this.rating,
    this.starCount = 5,
    this.size = 30,
    this.color = Colors.amber,
    this.onChanged,
    this.spacing = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(starCount, (index) {
        return Padding(
          padding: EdgeInsets.only(right: index < starCount - 1 ? spacing : 0),
          child: GestureDetector(
            onTap: onChanged != null ? () => onChanged!(index + 1) : null,
            child: Icon(
              index < rating ? Icons.star : Icons.star_border,
              color: color,
              size: size,
            ),
          ),
        );
      }),
    );
  }
}