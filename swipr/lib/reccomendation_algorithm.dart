import 'package:http/http.dart' as http;
import 'dart:convert';
import 'movies.dart';
import 'users.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';




Future<Movie> fetchGptResponse(String userMessage, User user, Set<String> selectedPreferences) async {
  const apiKey = String.fromEnvironment("OPEN_AI_API_KEY"); // Replace with your actual API key
  const url = 'https://api.openai.com/v1/chat/completions';

  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/${user.username}_responses.txt');

  if (await file.exists()) {
    // String contents = await file.readAsString();


    List<String> lines = await file.readAsLines();

    if (lines.length > 40) {
      // Remove the oldest line
      lines.removeAt(0);
      lines.removeAt(1);
      lines.removeAt(2);
      lines.removeAt(3);
      lines.removeAt(4);
      lines.removeAt(5);
      

      // Write the remaining lines back to the file
      await file.writeAsString(lines.join('\n'));
    }

  String contents = lines.join('\n');
    
    print('File contents: $contents');


    final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    },
    body: jsonEncode({
      'max_tokens': 3000,
      'model': 'gpt-4', // Specify the model if needed
      'messages': [
        {'role': 'system', 'content': initialSystemMessage},
        {'role': 'user', 'content': '$userMessage,but none of these movies:$contents, with these preferences:$selectedPreferences'},
      ],
    }),
  );

  if (response.statusCode == 200) {
    // return Movie.fromJson(jsonDecode(response.body)['choices'][0]['text']);
    // print('Raw response: ${response.body}');
    // String Title = response.body["content"]["title"];
    // print("Title: "+Title);
    // var data = jsonDecode(response.body);
    // var latestMessage = data['choices'][0]['message']['content'];
    // return Movie.fromJson(jsonDecode(latestMessage));
    var data = jsonDecode(response.body);
    var content = data['choices'][0]['message']['content'];
    return parseMovieFromContent(content, user);
  } else {
    // print('Status code: ${response.statusCode}');
    // print('Response body: ${response.body}');
    throw Exception('Failed to load response from OpenAI');
  }


  } else {
    print('File does not exist');

    final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    },
    body: jsonEncode({
      'max_tokens': 3000,
      'model': 'gpt-4', // Specify the model if needed
      'messages': [
        {'role': 'system', 'content': initialSystemMessage},
        {'role': 'user', 'content': userMessage},
      ],
    }),
  );

  if (response.statusCode == 200) {
    // print('Raw response: ${response.body}');
    var data = jsonDecode(response.body);
    var content = data['choices'][0]['message']['content'];
    return parseMovieFromContent(content, user);
  } else {
    // print('Status code: ${response.statusCode}');
    // print('Response body: ${response.body}');
    throw Exception('Failed to load response from OpenAI');
  }

  }
  
}

Movie parseMovieFromContent(String content, User user) {
  var lines = content.split('\n');

  // Helper function to clean and extract values
  String extractValue(String line) {
    var colonIndex = line.indexOf(':');
    if (colonIndex != -1) {
      return line.substring(colonIndex + 1).trim().replaceAll('"', '').replaceAll(',', '').replaceAll(')', '');
    }
    throw Exception('Invalid line format: $line');
  }

  // Helper function to extract lists
  List<String> extractList(String line) {
    var startIndex = line.indexOf('[');
    var endIndex = line.indexOf(']');
    if (startIndex != -1 && endIndex != -1) {
      return line.substring(startIndex + 1, endIndex).split(',').map((e) => e.trim().replaceAll('"', '')).toList();
    }
    throw Exception('Invalid list format: $line');
  }

  try {
    var title = extractValue(lines[1]);
    var posterUrl = extractValue(lines[2]);
    var description = extractValue(lines[3]);
    var genres = extractList(lines[4]);
    var actors = extractList(lines[5]);
    var directors = extractList(lines[6]);

    

    writeResponseToFile(user, Movie(
      title: title,
      posterUrl: posterUrl,
      description: description,
      genres: genres,
      actors: actors,
      directors: directors,
    ));

    return Movie(
      title: title,
      posterUrl: posterUrl,
      description: description,
      genres: genres,
      actors: actors,
      directors: directors,
    );
  } catch (e) {
    print('Error parsing movie content: $e');
    rethrow;
  }

}



void writeResponseToFile(User user, Movie movie) async {
  // print("writeResponseToFile called"); // Debug print
  try {
    final directory = await getApplicationDocumentsDirectory();
    var file = File('${directory.path}/${user.username}_responses.txt');
    // print("Writing to file at: ${file.path}"); // Debug print
    // Append the movie title to the file
    var sink = file.openWrite(mode: FileMode.append);
    sink.writeln(movie.title);
    await sink.close();
  } catch (e) {
    print('Error writing response to file: $e');
  }
}



