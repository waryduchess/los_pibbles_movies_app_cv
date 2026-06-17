import 'package:flutter/material.dart';

class MovieReviewCard extends StatelessWidget {
  final String user;
  final String review;
  final String date;
  final String rating;

  const MovieReviewCard({
    super.key,
    required this.user,
    required this.review,
    required this.date,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1F2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text(user,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis)),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  const SizedBox(width: 4),
                  Text(rating, style: const TextStyle(color: Colors.white)),
                ],
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(review,
              style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
              maxLines: 5,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 12),
          Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}