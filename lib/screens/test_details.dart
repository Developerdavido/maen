
import 'package:flutter/material.dart';

class TestDetails extends StatefulWidget {
  @override
  _TestDetailsState createState() => _TestDetailsState();
}

class _TestDetailsState extends State<TestDetails> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height,
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.32),
                    padding: EdgeInsets.only(top: size.height * 0.12,
                    left: 20,
                    right: 20),
                    height: 500,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      )
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          ColorAndSize(),
                          SizedBox(height: 20 / 2,),
                          Description(),
                          SizedBox(height: 20 / 2,),
                          CartCounter(),
                          SizedBox(height: 20 / 2,),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 20),
                                  height: 50,
                                    width: 58,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(color: Colors.red)
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.shopping_cart),
                                    onPressed: (){},
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(height: 50,
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                      color: Colors.redAccent,
                                      onPressed: (){},
                                      child: Text("BUY NOW".toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                      ),)),),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            "My hand bag",
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                        ),
                        Text(
                          "my product",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(text: "Price\n"),
                                    TextSpan(
                                      text: "\$200",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18
                                      )
                                    )
                                  ]
                                )),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(child: Image.asset("",
                            height: 120,
                            width: 120,
                            fit: BoxFit.fill,))
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CartCounter extends StatefulWidget {
  @override
  _CartCounterState createState() => _CartCounterState();
}

class _CartCounterState extends State<CartCounter> {
  int numOfItems = 1;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BuildSizedBox(icon: Icons.remove,
        press: (){
          if(numOfItems > 1){
            setState(() {
              numOfItems--;
            });
          }
        }),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20 / 2),
          child: Text(numOfItems.toString().padLeft(2, "0"), style: TextStyle(
            color: Colors.black54
          ),),
        ),
        BuildSizedBox(icon: Icons.add,
            press: (){
          setState(() {
            numOfItems++;
          });
            }),
      ],
    );
  }

  SizedBox BuildSizedBox({IconData icon, Function press}) {
    return SizedBox(
        width: 40,
        height: 32,
        child: OutlineButton(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13)
          ),
          onPressed: press,
          child: Icon(icon),
        ),
      );
  }
}


class Description extends StatelessWidget {
  const Description({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20
      ),
      child: Text(
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        style: TextStyle(height: 1.5),
      ),
    );
  }
}

class ColorAndSize extends StatelessWidget {
  const ColorAndSize({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Color"),
              Row(
                children: [
                  dotColor(color: Color(0xFF356C95),
                  isSelected: true,),
                  dotColor(color: Color(0xFFF8C078)),
                  dotColor(color: Color(0xFFA29B9b)),
                ],
              )
            ],
          ),
        ),
        Expanded(
          child: RichText(text: TextSpan(
            style: TextStyle(color: Colors.black45),
            children: [
              TextSpan(
                text: "Size\n"
              ),
              TextSpan(text: "\$200",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ))
            ]
          )),
        )
      ],
    );
  }
}

class dotColor extends StatelessWidget {
  final Color color;
  final bool isSelected;
  const dotColor({
    Key key,
    this.color,
    this.isSelected = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 20 / 4,
        right: 20 / 2
      ),
      padding: EdgeInsets.all(2.5),
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? color : Colors.transparent
        )
      ),
      child: DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle
          )),
    );
  }
}

