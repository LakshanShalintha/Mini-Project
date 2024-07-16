import 'package:google_generative_ai/google_generative_ai.dart';

class AIServices {
  final model = GenerativeModel(
    model: "gemini-1.5-pro-latest",
    apiKey: "AIzaSyCVvMSw88d29co-TsEBuREFbXFsaRmrwLU",
  );

  Future<String> generateStory(String data) async {
    final prompt = """
    I want you to create a detailed audio book story based on the following data: $data.

    Here are the guidelines for the story structure:
    - The story should be approximately 2000 words long.
    """;

    final content = [Content.text(prompt)];

    try {
      final response = await model.generateContent(
        content,
        generationConfig: GenerationConfig(
          temperature: 0.6,
          responseMimeType: "application/json",
          topP: 0.95,
          topK: 64,
        ),
      );
      print(response.text);  // This will print the response for debugging
      return response.text ?? 'No content generated';
    } catch (e) {
      if (e.toString().contains('Resource has been exhausted')) {
        return 'Quota exceeded. Please try again later.';
      } else {
        return 'An error occurred: $e';
      }
    }
  }
}

