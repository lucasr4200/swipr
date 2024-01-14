import 'package:flutter/material.dart';
import 'likes_page.dart';
import 'preferences_page.dart';
import 'movies.dart';
import 'reccomendation_algorithm.dart';
import 'login_page.dart';
import 'users.dart';


List<Movie>? movieList;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swipr',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}

class HomePage extends StatefulWidget {

  final User userLoggedIn;
  final Movie movie;

  HomePage({Key? key, required this.userLoggedIn, required this.movie});
  // HomePage.withMovieList({Key? key, required this.userLoggedIn, required this.movieList});
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  int currentIndex = 0;

  List<Movie> likes = [];

  bool isLoading = false;

  List<Movie>? movieList = []; // Initialize movieList

  Set<String> selectedPreferences = {};


  @override
  void initState() {
    super.initState();
    movieList = [widget.movie]; // Add the fetched movie to movieList
  }


void swipeCard(bool swipeRight) {
  if (swipeRight && movieList != null && currentIndex < movieList!.length) {
    // Add to likes if swiping right
    likes.add(movieList![currentIndex]);
  }

  // Fetch new movie
  fetchGptResponse("user:" + (swipeRight ? "swipe right" : "swipe left"),widget.userLoggedIn, selectedPreferences).then((newMovie) {
    print("Fetched new movie: ${newMovie.title}");
    setState(() {
      movieList!.add(newMovie); // Add new movie to the list
      print("Added new movie to movieList: ${movieList}");
      movieList!.removeAt(currentIndex); // Remove the swiped movie
      print("Removed swiped movie from movieList: ${movieList}");

      // Update currentIndex
      if (currentIndex >= movieList!.length) {
        currentIndex = movieList!.length - 1;
      }
      isLoading = false;
    });
  }).catchError((error) {
    print('Error fetching new movie: $error');
    setState(() {
      isLoading = false;
    });
  });

  // Set loading state
  setState(() {
    isLoading = true;
  });
}



  @override
  Widget build(BuildContext context) {
      if (isLoading) {
        return const Scaffold(
          backgroundColor:  Color(0xFF333333),
          body: Center(
          child: CircularProgressIndicator(),
          ),
        );
      }

    return Scaffold(
      backgroundColor: const Color(0xFF333333),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1C),
        title: const Text('Swipr', 
        style: TextStyle(color: Color(0xFFFFFFFF)),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0, left: 274.0),
            child: Positioned(
              // top: 10.0, // adjust the values as needed
              // right: 10.0,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PreferencesPage(selectedPreferences: selectedPreferences,)),);
                },
                icon: const Icon(Icons.tune, color: Colors.blue, size: 30.0),
                label: const Text ("Preferences"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B3A67),
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
            ),
          ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
            if (movieList?.isEmpty ?? true)
            const Text(
              'No more movies to show',
              style: TextStyle(fontSize: 24),
            ),
            if (movieList?.isNotEmpty ?? false)
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.grey[800],
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      ),
                      title: Text(movieList![currentIndex].title),
                      titleTextStyle: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 24, fontWeight: FontWeight.bold),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            const SizedBox(height: 10),
                            DefaultTextStyle(
                              style: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 18),
                              child: Text('Genres: ${movieList![currentIndex].genres.join(', ')}'),
                            ),
                            const SizedBox(height: 10),
                            DefaultTextStyle(
                              style: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 18),
                              child: Text('Actors: ${movieList![currentIndex].actors.join(', ')}'),
                            ),
                            const SizedBox(height: 10),
                            DefaultTextStyle(
                              style: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 18),
                              child: Text('Director: ${movieList![currentIndex].directors}'),
                            ),
                            const SizedBox(height: 10),
                            DefaultTextStyle(
                              style: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 18),
                              child: Text('Description: ${movieList![currentIndex].description}'),
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Close'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Dismissible(
                // key: Key('$currentIndex'),
                key: Key(movieList![currentIndex].title),
                onDismissed: (direction) {
                  swipeCard(direction == DismissDirection.endToStart ? false : true);
                },
                child: (currentIndex >= 0 && currentIndex < movieList!.length)
                ? Image.asset(
                  movieList![currentIndex].posterUrl,
                  fit: BoxFit.cover,
                  // errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  // // You can return any widget here. For example, a green Container:
                  // return Container(color: Colors.green);
                  // },
                ): Container(),

              ),
            ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FloatingActionButton(
                onPressed: () => swipeCard(false), // Swipe left
                child: Icon(Icons.close, color: Color(0xFFCCCCCC)),
                backgroundColor: const Color(0xFF4169E1),
              ),
              FloatingActionButton(
                onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LikesPage(likes: likes)),);
                },
                child: const Icon(Icons.favorite),
                backgroundColor: const Color(0xFFFFD700),
              ),
              FloatingActionButton(
                onPressed: () => swipeCard(true), // Swipe right
                child: Icon(Icons.check, color: Colors.white),
                backgroundColor: const Color(0xFFFF355E),
              ),
            ],
          ),
        ],
      ),
        ],
      ),
    );
  }
}
