import "package:flutter/material.dart";

var data = [
    {
      "type": "info",
      "author": "Helle Nielsen",
      "date": "25-07-2018 09:23",
      "title": "Grill på lørdag",
      "body": "På lørdag griller vi på banerne fra kl. 18 til 20 og alle er velkomne til at deltage og der vil være noget sjovt at lave efter at vi har grillet. Men man skal tilmelde sig hurtigt for ellers er der ikke mange pladser tilbage. Og der kan forekomme at der er andre der gerne vil lege eller lavet noget som vi ikke har forudset.",
      "comments": [
        {
          "body": "Noget om noget med noget mere på",
          "author": "Christian Nicolaisen",
          "date": "25-07-2018 11:58"
        }
      ]
    },
    {
      "type": "game",
      "author": "Henrik Nielsen",
      "date": "23-07-2018 10:23",
      "title": "Nogen der vil spille onsdag kl. 141, men jeg kan desværre kun til kl. 8",
      "body": "",
      "comments": [
        {
          "body": "Jeg vil gerne",
          "author": "Christian Nicolaisen",
          "date": "25-07-2018 11:58"
        },
        {
          "body": "Jeg vil også gerne",
          "author": "Maria Gasbjerg",
          "date": "25-07-2018 14:58"
        },
        {
          "body": "Klar",
          "author": "Carsten Højmark",
          "date": "24-07-2018 11:19"
        }
      ]
    }
  ];

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
      itemBuilder: (BuildContext context, int position) {
        return _item(data[position]);
      } ,
    );
  }

  Widget _item(Map<String, Object> item) {
    return ListBody(
          children: <Widget>[
            ListTile(
              title: Text(item["title"]),
              subtitle: item["body"] != "" ? Text(
                  item["body"],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis) : null,
              leading: Icon(
                item["type"] == "info" ? Icons.info : Icons.store_mall_directory,
                size: 40.0
              ),
              onTap: () {

              },
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 74.0, top: 5.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.access_time,
                    size: 12.0
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 5.0),
                    child: Text(
                      "25-08-2018 - 11:59",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 12.0),
                    )
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 20.0),
                    child: Icon(
                      Icons.chat_bubble_outline,
                      size: 12.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 5.0),
                    child: Text(
                      "12",
                      style: TextStyle(
                        fontSize: 12.0
                      ),
                    )
                  )
                ],
              ),
            )
          ],
        );
  }
}
