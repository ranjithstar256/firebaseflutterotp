import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'movie_provider.dart'; // Make sure to import your provider file

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MovieScreen(),
    );
  }
}

class MovieScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access the list of movies from the provider
    final movies = ref.watch(movieProvider);

    final TextEditingController movieController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Favorite Movies')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: movieController,
              decoration: InputDecoration(
                labelText: 'Add a Movie',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (movieController.text.isNotEmpty) {
                  // Add the movie to the list
                  ref.read(movieProvider.notifier).state = [
                    ...movies,
                    movieController.text.trim()
                  ];
                  movieController.clear(); // Clear the text field after adding
                }
              },
              child: Text('Add Movie'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return ListTile(
                    title: Text(movie),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
