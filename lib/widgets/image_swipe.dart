import 'package:flutter/material.dart';

class ImageSwipe extends StatefulWidget {
  final List imageList;
  final double height;
  ImageSwipe({this.imageList, this.height});
  @override
  _ImageSwipeState createState() => _ImageSwipeState();
}

class _ImageSwipeState extends State<ImageSwipe> {

  int _selectedPage = 0;
  Color ash = Color(0xFFECF1F7);
  Color blue = Color(0xFF0007A7).withOpacity(0.7);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ash,
      height: widget.height,
      child: Stack(
        children: [
          PageView(
            onPageChanged: (num) {
              setState(() {
                _selectedPage = num;
              });
            },
            children: [
              for(var i = 0; i < widget.imageList.length; i++)
                Container(
                  child: Image.network(
                    "${widget.imageList[i]}",
                    fit: BoxFit.fitHeight,
                    scale: 1,
                  ),
                )
            ],
          ),
          Positioned(
            bottom: 60.0,
            left: 0,
            right: 0,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for(var i=0; i<widget.imageList.length; i++)
                  AnimatedContainer(duration: Duration(
                      milliseconds: 300
                  ),
                    curve: Curves.easeOutCubic,
                    margin: EdgeInsets.symmetric(
                      horizontal: 5.0,
                    ),
                    width: _selectedPage == i ? 35.0 : 10.0,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
