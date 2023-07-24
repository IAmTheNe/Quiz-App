import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whizz/src/common/constants/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quizwhizz'),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearch(),
              );
            },
            icon: const Icon(
              Icons.search,
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            backgroundImage: const CachedNetworkImageProvider(
                'https://scontent.fdad1-4.fna.fbcdn.net/v/t39.30808-6/362222624_1482954875782698_4218631403666751824_n.jpg?_nc_cat=103&cb=99be929b-3346023f&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=65Zhcu4XNhcAX-IJfoL&_nc_ht=scontent.fdad1-4.fna&oh=00_AfDwLV7-VHVWFJiJmz0SNSJUM6JfMj1d8gbB6enGwXXglw&oe=64C13E9A'),
          ),
          SizedBox(
            width: Constants.kPadding.w / 2,
          ),
        ],
      ),
    );
  }
}

class CustomSearch extends SearchDelegate {
  List<String> examples = [
    'Cấu trúc dữ liệu và giải thuật',
    'Vợ nhặt',
    'English 10 - Unit 6',
    'Ai là người hiểu Thương nhất?',
    'Christmas',
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final matchQuery = <String>[];
    for (final item in examples) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        final result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final matchQuery = <String>[];
    for (final item in examples) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        final result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}
