import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:chatbot_and_image_generator/secret.dart';

class OpenAi_service {
  final List<Map<String, String>> messages = [];
  Future<String> is_prompt_api(String prompt) async {
    try {
      final response =
          await http.post(Uri.parse('https://api.openai.com/v1/completions'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $apikey',
              },
              body: jsonEncode({
                "model": "gpt-3.5-turbo",
                "messages": [
                  {
                    "role": "user",
                    "content": prompt,
                  },
                ]
              }));
      print(response.body);
      if (response.statusCode == 200) {
        String content =
            jsonDecode(response.body)['choices'][0]['message']['content'];
        content = content.trim();
        switch (content) {
          case 'Yes':
          case 'yes':
          case 'Yes.':
          case 'yes.':
            final response = await dellE_api(prompt);
            return response;
          default:
            final response = await chatgpt_api(prompt);
            return response;
        }
      }
      return 'Some Internal Error Occured';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> chatgpt_api(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final response = await http.post(
          Uri.parse('https://api.openai.com/v1/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apikey',
          },
          body: jsonEncode({"model": "gpt-3.5-turbo", "messages": messages}));
      if (response.statusCode == 200) {
        String content =
            jsonDecode(response.body)['choices'][0]['message']['content'];
        content = content.trim();
        messages.add({'role': 'assistent', 'content': content});
        return content;
      }
      return 'Some Internal Error Occured';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> dellE_api(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final response = await http.post(
          Uri.parse('https://api.openai.com/v1/images/generations'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apikey',
          },
          body: jsonEncode({
            "model": "dall-e-3",
            "prompt": prompt,
            "n": 1,
            // "size": "1024x1024"
          }));
      print(response.body);
      if (response.statusCode == 200) {
        String image_url = jsonDecode(response.body)['data'][0]['url'];
        image_url = image_url.trim();
        messages.add({'role': 'assistant', 'content': image_url});
        return image_url;
      }
      return 'Some Internal Error Occured';
    } catch (e) {
      return e.toString();
    }
  }
}
