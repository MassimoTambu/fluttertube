import 'package:flutter/material.dart';
import 'package:fluttertube/ui/widgets/ft_search_element.dart';
import 'package:googleapis/youtube/v3.dart';

class SearchTab extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final SearchListResponse? response;
  final void Function(String) search;
  final void Function(String?) setMediaId;

  const SearchTab({
    required this.isLoading,
    required this.errorMessage,
    required this.search,
    required this.setMediaId,
    required this.response,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Cerca',
              ),
              onSubmitted: search,
            ),
          ),
          buildSearchResults(context),
        ],
      ),
    );
  }

  Widget buildSearchResults(BuildContext context) {
    Widget child;

    if (isLoading) {
      child = Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (response != null) {
      // CHECK IF IS EMPTY RESULT
      if (response!.items!.length == 0) {
        child = Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "🤷🏽‍♀️",
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(height: 10),
              const Text(
                'Nessun risultato',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      } else {
        child = Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: response!.items!.length,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Questi sono i primi 10 risultati trovati:"),
                    const SizedBox(height: 10),
                    getListChildren(index),
                  ],
                );
              }
              return getListChildren(index);
            },
          ),
        );
      }
    } else if (response == null) {
      child = Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "🕵🏽‍♂️",
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 10),
            const Text(
              'Nessuna ricerca effettuata',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    } else {
      throw 'Not Implemented';
    }

    return child;
  }

  Widget getListChildren(int index) {
    if (response != null && errorMessage == null) {
      return FTSearchElement(response!.items![index], setMediaId);
    } else if (errorMessage != null) {
      return Container(child: Text(errorMessage!));
    }

    throw 'Not implemented';
  }
}
