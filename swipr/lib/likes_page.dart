import 'package:flutter/material.dart';
import 'movies.dart';


class LikesPage extends StatefulWidget {

  final List<Movie> likes;
  LikesPage({Key? key, required this.likes}) : super(key: key);
  
  @override
  _LikesPageState createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333333),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1C),
        title: const Text("Liked Movies"),
      ),
      body: widget.likes.isEmpty
          ? const Center(child: Text("Like some movies to fill in your likes page!"))
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: widget.likes.length,
              itemBuilder: (context, index) {
                return GridTile(
                  footer: GridTileBar(
                  backgroundColor: Colors.black54,
                  title: Text(widget.likes[index].title), // replace with actual movie title if available
                  ),
                  child: Image.asset(widget.likes[index].posterUrl), // assuming likes are image URLs
                );
              },
            ),
    );
  }
}