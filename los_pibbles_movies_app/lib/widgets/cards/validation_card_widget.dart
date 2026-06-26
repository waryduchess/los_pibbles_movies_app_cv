import 'package:flutter/material.dart';

class ValidationCardWidget extends StatelessWidget {
  final String title;
  final Map<String, bool> requirements;

  const ValidationCardWidget({
    super.key,
    required this.title,
    required this.requirements,
  });

  Widget _buildRequirementItem(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Icon(
              Icons.pets,
              size: 14,
              color: isMet ? Colors.greenAccent.shade400 : Colors.redAccent.shade400,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isMet ? Colors.greenAccent.shade400 : Colors.redAccent.shade400,
                fontSize: 13,
                fontWeight: isMet ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3), 
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
          ...requirements.entries.map(
            (entry) => _buildRequirementItem(entry.key, entry.value),
          ),
        ],
      ),
    );
  }
}