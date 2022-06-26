import 'package:active_ecommerce_flutter/screens/mp3_screen.dart';
import 'package:active_ecommerce_flutter/screens/music_list.dart';
import 'package:flutter/material.dart';

class ListenRow extends StatelessWidget {
  ListenRow({Key key, this.title}) : super(key: key);
  String title;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 50,
              width: 5,
              color: Colors.redAccent,
            ),
            SizedBox(
              width: 10,
            ),
            Text(title,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold))
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Mp3Screen()));
          },
          child: Card(
            elevation: 0.01,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            child: Container(
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Text("See All",
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
