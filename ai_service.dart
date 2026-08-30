/// The single seam through which the app talks to AI features.
///
/// Screens and view-models only ever depend on this interface — never on an
/// LLM SDK directly. The real implementation (Phase 5+) calls your own
/// backend endpoint (Cloud Function / Supabase Edge Function), which holds
/// the provider API key server-side. That keeps the client free of secrets
/// and lets you switch LLM providers by changing one backend config value,
/// with zero app changes.
abstract class AiService {
  /// General tutoring: explain a topic/question at MBBS level.
  /// [mode] lets the UI request variants: "simple", "detailed", "5-mark",
  /// "10-mark", "viva", "mcq", "clinical-correlation".
  Future<String> explainTopic({
    required String prompt,
    String mode = 'simple',
  });

  /// Ask a question grounded in a previously uploaded document. The backend
  /// retrieves only the top-k relevant chunks (RAG) rather than sending the
  /// whole PDF.
  Future<String> askAboutDocument({
    required String documentId,
    required String question,
  });

  /// Generate MCQs for a topic at a given difficulty.
  Future<List<Map<String, dynamic>>> generateMcqs({
    required String topicId,
    required int count,
    required String difficulty, // easy | medium | hard
  });

  /// Generate flashcards from a topic or an uploaded document's notes.
  Future<List<Map<String, String>>> generateFlashcards({
    String? topicId,
    String? documentId,
    required int count,
  });

  /// One turn of the clinical case simulator. The backend keeps the model in
  /// an examiner/patient role; the UI must always show the "educational
  /// simulation, not real patient advice" disclaimer alongside responses.
  Future<String> clinicalCaseTurn({
    required String caseId,
    required String studentInput,
  });
}

/// Mock implementation so UI work isn't blocked on backend setup.
/// Replaced by a real `HttpAiService` in Phase 5.
class MockAiService implements AiService {
  @override
  Future<String> explainTopic({
    required String prompt,
    String mode = 'simple',
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 'This is a mock AI explanation for "$prompt" ($mode mode). '
        'Connect a real backend in Phase 5 to replace this.';
  }

  @override
  Future<String> askAboutDocument({
    required String documentId,
    required String question,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 'Mock answer grounded in document $documentId for: "$question".';
  }

  @override
  Future<List<Map<String, dynamic>>> generateMcqs({
    required String topicId,
    required int count,
    required String difficulty,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.generate(
      count,
      (i) => {
        'question': 'Mock $difficulty question ${i + 1} for $topicId',
        'options': ['Option A', 'Option B', 'Option C', 'Option D'],
        'correctIndex': 0,
        'explanation': 'Mock explanation.',
      },
    );
  }

  @override
  Future<List<Map<String, String>>> generateFlashcards({
    String? topicId,
    String? documentId,
    required int count,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.generate(
      count,
      (i) => {
        'front': 'Mock question ${i + 1}',
        'back': 'Mock answer ${i + 1}',
      },
    );
  }

  @override
  Future<String> clinicalCaseTurn({
    required String caseId,
    required String studentInput,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 'Mock examiner response to "$studentInput" for case $caseId. '
        'Educational simulation only — not real patient advice.';
  }
}
