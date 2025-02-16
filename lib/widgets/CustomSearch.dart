import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Show the results based on the query
    return Center(
      child: Text('You selected: $query'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show suggestions as the user types
    final suggestions = query.isEmpty
        ? ['Flutter', 'Dart', 'Android', 'iOS']
        : ['Flutter', 'Dart', 'Android', 'iOS']
            .where((str) => str.startsWith(query))
            .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () {
            query = suggestions[index];
            showResults(context);
          },
        );
      },
    );
  }
}
