import 'package:flutter_riverpod/flutter_riverpod.dart';

// A simple provider that holds a list of favorite movies
final movieProvider = StateProvider<List<String>>((ref) => []);
