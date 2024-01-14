// Purpose: Holds the Movie class and a list of movies to be used in the app
import 'reccomendation_algorithm.dart';
import 'users.dart';

class Movie {
  final String title;
  final String posterUrl;
  final String description;
  final List<String> genres;
  final List<String> actors;
  final List<String> directors;

  Movie({
    required this.title,
    required this.posterUrl,
    required this.description,
    required this.genres,
    required this.actors,
    required this.directors,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      posterUrl: json['posterUrl'],
      description: json['description'],
      genres: json['genres'],
      actors: json['actors'],
      directors: json['directors'],
    );
  }
}

String initialSystemMessage = '''
System: You are an AI that helps with movie recommendations. You are part of an app where users swipe right to like movies, and swipe left to dislike movies. If a user swipes right, you are more likely to recommend a similar movie to them, however, make sure to recommend other dissimilar movies as well every few movies, in order to provide them with more choice. You will return results as a dart class called Movie. Here is the definition of the class:

class Movie {
  final String title;
  final String posterUrl;
  final String description;
  final List<String> genres;
  final List<String> actors;
  final List<String> directors;

  Movie({
    required this.title,
    required this.posterUrl,
    required this.description,
    required this.genres,
    required this.actors,
    required this.directors,
  });
}

Only return one movie at a time and only return the filled values of the movie class, not the initialization of the class.  Remember every movies you return. Never return the same movie twice. Do not return any comments or anything else. 
''';

// final initialMovie = fetchGptResponse(initialSystemMessage+"User:"+"choose a random movie to start then i will swipe left or right from there");

// var movieList = [
//   initialMovie,
//   starWars,

  
//   // Add more movies here
// ];

Future<List<Movie>> fetchMovies(User user, Set<String> selectedPreferences) async {
  print("This is the user logged in: " + user.username);
  Movie initialMovie = await fetchGptResponse(initialSystemMessage + "User:" + "choose a random movie to start then i will swipe left or right from there", user, selectedPreferences);
  var movieList = [
    initialMovie,
    // ... other movies ...
  ];
  return movieList;
  // ... rest of the code ...
}



// var starWars = Movie(
//   title: 'Star Wars: Episode IV - A New Hope',
//   posterUrl: 'assets/starWarsPoster.jpg',
//   description: 'Luke Skywalker joins forces with a Jedi Knight, a cocky pilo                   t, a Wookiee and two droids to save the galaxy from the Empire\'s world-destroying battle station, while also attempting to rescue Princess Leia from the mysterious Darth Vader.',
//   genres: ['Action', 'Adventure', 'Fantasy', 'Sci-Fi', ''],
//   actors: ['Mark Hamill', 'Harrison Ford', 'Carrie Fisher'],    
//   directors: ['George Lucas'],
// );

// var theDarkKnight = Movie(
//   title: 'The Dark Knight',
//   posterUrl: 'assets/theDarkKnightPoster.jpg',
//   description: 'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.',
//   genres: ['Action', 'Crime', 'Drama', 'Fiction', 'Thriller'],
//   actors: ['Christian Bale', 'Heath Ledger', 'Aaron Eckhart'],
//   directors: ['Christopher Nolan'],
// );

// var theHobbit = Movie(
//   title: 'The Hobbit: An Unexpected Journey',
//   posterUrl: 'assets/theHobbitPoster.jpg',
//   description: 'A reluctant Hobbit, Bilbo Baggins, sets out to the Lonely Mountain with a spirited group of dwarves to reclaim their mountain home, and the gold within it from the dragon Smaug.',
//   genres: ['Adventure', 'Fantasy'],
//   actors: ['Martin Freeman', 'Ian McKellen', 'Richard Armitage'],
//   directors: ['Peter Jackson'],
// );

// var theReturnOfTheKing = Movie(
//   title: 'The Lord of the Rings: The Return of the King',
//   posterUrl: 'assets/theReturnOfTheKingPoster.jpg',
//   description: 'The rightful heir to the throne of Gondor returns home to defend against the armies of Mordor. Menawhile Frodo and Sam reach the thrilling conclusion to Mount Doom.',
//   genres: ['Adventure', 'Drama', 'Fantasy'],
//   actors: ['Elijah Wood', 'Viggo Mortensen', 'Ian McKellen'],
//   directors: ['Peter Jackson'],
// );

// var tombstone = Movie(
//   title: 'Tombstone',
//   posterUrl: 'assets/tombstonePoster.jpg',
//   description: 'A successful lawman\'s plans to retire anonymously in Tombstone, Arizona are disrupted by the kind of outlaws he was famous for eliminating.',
//   genres: ['Action', 'Biography', 'Drama'],
//   actors: ['Kurt Russell', 'Val Kilmer', 'Sam Elliott'],
//   directors: ['George P. Cosmatos', 'Kevin Jarre'],
// );

// var anabelle = Movie(
//   title: 'Annabelle',
//   posterUrl: 'assets/anabellePoster.jpg',
//   description: 'A couple begins to experience terrifying supernatural occurrences involving a vintage doll shortly after their home is invaded by satanic cultists.',
//   genres: ['Horror', 'Mystery', 'Thriller'],
//   actors: ['Ward Horton', 'Annabelle Wallis', 'Alfre Woodard'],
//   directors: ['John R. Leonetti'],
// );

// var barbie = Movie(
//   title: 'Barbie',
//   posterUrl: 'assets/barbiePoster.jpg',
//   description: 'All is well in Barbieland until Barbie begins experiencing odd occurences such as celluclite! She must embark on a journey of self fulffilment to save herself and ultimately Barbieland.',
//   genres: ['Comedy', 'Family', 'Feel Good', 'Fiction'],
//   actors: ['Margot RObbie', 'Ryan Gosling', 'Michael Cera', 'Will Ferrell'],
//   directors: ['Greta Gerwig'],
// );

// var captainAmericaCivilWar = Movie(
//   title: 'Captain America: Civil War',
//   posterUrl: 'assets/captainAmericaCivilWarPoster.jpg',
//   description: 'Cap is catching up after his time frozen in ice, making freinds, seeing the sites and embarking on missions of natironal security. But when a new threat arises, he must choose between his friends and his country.',
//   genres: ['Action', 'Adventure', 'Sci-Fi'],
//   actors: ['Chris Evans', 'Robert Downey Jr.', 'Scarlett Johansson'],
//   directors: ['Anthony Russo', 'Joe Russo'],
// );


// List<Movie> movieList = [
//   djangoUnchained,
//   starWars,
//   theDarkKnight,
//   theHobbit,
//   theReturnOfTheKing,
//   tombstone,
//   anabelle,
//   barbie,
//   captainAmericaCivilWar,
//   // Add more paths as needed
// ];