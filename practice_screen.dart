import 'package:flutter/material.dart';

/// Placeholder hub for Phase 6 (MCQs), Phase 8 (Flashcards), Phase 9 (PYQs),
/// and the Clinical Case Simulator.
class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Practice')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.fact_check_rounded,
                  size: 48, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              Text('Practice', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                'MCQs, flashcards, PYQs, and clinical cases arrive in Phases 6, 8 and 9.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
