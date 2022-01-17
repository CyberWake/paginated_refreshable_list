import 'dart:convert';

import 'package:example/list_tiles/update_profile_club_tile.dart';
import 'package:example/list_tiles/update_profile_player_tile.dart';
import 'package:example/player.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:paginated_refreshable_list/paginated_refreshable_list.dart';

import 'club.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Player? selectedPlayer;
  Club? selectedClub;
  final String authToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NDI0NDQyOTMsImV4cCI6MTY0MjQ1MTQ5MywiYXVkIjoiNjFkZTlkZjljNTMzMGEwMDE5OTc5NTIwIn0.yPrsh8lqmKSCenhijPgJyGkOixj2PoscszICsdfqbG0";

  void selectPlayer(Player tappedPlayer) {
    setState(() {
      selectedPlayer = tappedPlayer;
    });
  }

  void selectClub(Club tappedClub) {
    setState(() {
      selectedClub = tappedClub;
    });
  }

  Future<List<Club>> fetchClubList(
      int itemToLoad, int pageToRequest, int itemsLoaded) async {
    final result = await http.get(
      Uri.parse(
          'https://dev-api.lineuppolo.com/api/club?page=$pageToRequest&limit=$itemToLoad'),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
        'Authorization': authToken,
      },
    );
    if (result.statusCode == 200) {
      return (((jsonDecode(result.body))['result']['result'] as List)
          .map((e) => Club.fromJson(e as Map<String, dynamic>))
          .toList());
    } else {
      return [];
    }
  }

  Future<List<Player>> fetchPlayerList(
      int itemToLoad, int pageToRequest, int itemsLoaded) async {
    final result = await http.get(
      Uri.parse(
          'https://dev-api.lineuppolo.com/api/player?page=$pageToRequest&limit=$itemToLoad'),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
        'Authorization': authToken,
      },
    );
    if (result.statusCode == 200) {
      return (((jsonDecode(result.body))['result']['result'] as List)
          .map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList());
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: Column(),
      ),
      body: true
          ? SingleChildScrollView(
              child: PaginatedRefreshableListGenerator<Club>(
                fetchList: fetchClubList,
                itemLoadCount: 10,
                noDataWidget: Container(
                  height: 150,
                  width: 150,
                  alignment: Alignment.center,
                  child: const Text('No Data to show'),
                ),
                builder: (context, index, currentItem, isLastItem) {
                  return UpdateProfileClubTile(
                      onTap: () => selectClub(currentItem),
                      currentClub: currentItem,
                      isSelected: currentItem == selectedClub,
                      showSeparator: !isLastItem);
                },
              ),
            )
          : true
              ? PaginatedRefreshableListBuilder<Club>(
                  fetchList: fetchClubList,
                  itemLoadCount: 10,
                  refreshConfig:
                      RefreshIndicatorConfig(showRefreshIndicator: true),
                  // loadingBuilder: (context, index) {
                  //   return Container(
                  //     color: Colors.red[(index + 1) * 100],
                  //     height: 100,
                  //   );
                  // },
                  // loadingBuilderCount: 3,
                  // loadingWidget: const Text('Loading data'),
                  noDataWidget: Container(
                    height: 150,
                    width: 150,
                    alignment: Alignment.center,
                    child: const Text('No Data to show'),
                  ),
                  builder: (context, index, currentItem, isLastItem) {
                    return UpdateProfileClubTile(
                        onTap: () => selectClub(currentItem),
                        currentClub: currentItem,
                        isSelected: currentItem == selectedClub,
                        showSeparator: !isLastItem);
                  },
                )
              : PaginatedRefreshableListBuilder<Player>(
                  fetchList: fetchPlayerList,
                  itemLoadCount: 10,
                  loadingListBuilder: (context, index) {
                    return Container(
                      color: Colors.red[(index + 1) * 100],
                      height: 100,
                    );
                  },
                  noDataWidget: Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    child: const Text('No Data to show'),
                  ),
                  loadingBuilderItemCount: 3,
                  refreshConfig:
                      RefreshIndicatorConfig(showRefreshIndicator: true),
                  loadingWidget: const Center(child: Text('Loading data')),
                  builder: (context, index, currentItem, isLastItem) {
                    return UpdateProfilePlayerTile(
                      onTap: () => selectPlayer(currentItem),
                      currentPlayer: currentItem,
                      isSelected: currentItem == selectedPlayer,
                      showSeparator: !isLastItem,
                    );
                  },
                ),
    );
  }
}
