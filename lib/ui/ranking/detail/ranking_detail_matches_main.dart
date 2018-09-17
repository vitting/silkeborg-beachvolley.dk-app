import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_firestore.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_data.dart';

class RankingDetailMatches extends StatefulWidget {
  final String userId;

  const RankingDetailMatches({Key key, this.userId}) : super(key: key);
  @override
  _RankingDetailMatchesState createState() => _RankingDetailMatchesState();
}

//CHRISTIAN: Man skal slide mellem stat og matches
class _RankingDetailMatchesState extends State<RankingDetailMatches> {
  List<RankingMatchData> _matches = [];

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  _loadMatches() async {
    List<DocumentSnapshot> list =
        await RankingFirestore.getPlayerMatches(widget.userId);
    List<RankingMatchData> matches = list.map((DocumentSnapshot doc) {
      return RankingMatchData.fromMap(doc.data);
    }).toList();

    matches.sort((RankingMatchData a, RankingMatchData b) =>
        a.matchDate.compareTo(b.matchDate));

    setState(() {
      _matches = matches;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _main();
  }

  Widget _main() {
    return Container(
      constraints: BoxConstraints.expand(),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _matches.length,
        itemBuilder: (BuildContext context, int position) {
          RankingMatchData item = _matches[position];
          return Card(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(DateTimeHelpers.ddMMyyyy(item.matchDate)),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        flex: 2,
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 15.0,
                              backgroundImage: CachedNetworkImageProvider(
                                  item.winner1.photoUrl),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5.0),
                                child: Text(item.winner1.name),
                              ),
                            )
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 15.0,
                              backgroundImage: CachedNetworkImageProvider(
                                  item.winner1.photoUrl),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5.0),
                                child: Text(item.loser1.name),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 15.0,
                              backgroundImage: CachedNetworkImageProvider(
                                  item.winner2.photoUrl),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5.0),
                                child: Text(item.winner2.name),
                              ),
                            )
                          ],
                        ),
                      ),
                      Flexible(
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 15.0,
                              backgroundImage: CachedNetworkImageProvider(
                                  item.winner1.photoUrl),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5.0),
                                child: Text(item.loser2.name),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
