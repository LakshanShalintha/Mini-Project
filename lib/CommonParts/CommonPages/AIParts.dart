import 'package:google_generative_ai/google_generative_ai.dart';

class AIServices {
  // Initialize the GenerativeModel with the API key and model
  final model = GenerativeModel(
    model: "gemini-1.5-pro-latest",
    apiKey: "AIzaSyCVvMSw88d29co-TsEBuREFbXFsaRmrwLU",
  );

  // Method to generate a story based on input data
  Future<String?> generateStory(String data) async {
    // Define the prompt with the user's data
    final prompt = """
    I want you to create a detailed audio book story based on the following data: $data.

    Here are the guidelines for the story structure:
    - The story should be approximately 5000 words long and I want to speech this text using elevenlab API.
    """;

    // Create a list of content with the prompt text
    final content = [Content.text(prompt)];

    try {
      // Generate content using the model
      final response = await model.generateContent(
        content,
        generationConfig: GenerationConfig(
          temperature: 0.6,
          responseMimeType: "application/json",
          topP: 0.95,
          topK: 64,
        ),
      );

      // Check if the response text is not null or empty
      if (response.text != null && response.text!.isNotEmpty) {
        print(response.text);  // Print the response for debugging
        return response.text;
      } else {
        return 'No content generated';  // Return a message if no content is generated
      }
    } catch (e) {
      print('Error: $e');  // Log the error for debugging

      // Handle specific errors with user-friendly messages
      if (e.toString().contains('Resource has been exhausted')) {
        return 'Quota exceeded. Please try again later.';
      } else if (e.toString().contains('Invalid API key')) {
        return 'Invalid API key. Please check your API key and try again.';
      } else if (e.toString().contains('Network error')) {
        return 'Network error. Please check your internet connection and try again.';
      } else {
        return 'An error occurred: $e';  // Return a general error message
      }
    }
  }
}
