import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maen/providers/category_provider.dart';
import 'package:maen/screens/navigation.dart';
import 'package:maen/utils/common.dart';
import 'package:maen/widgets/loadingWidget.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import 'navigation_controller.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Categories",
        ),
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
          color: Colors.black,),
          onPressed: (){
            changeScreenReplacement(context, NavigationController());
          },
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.92,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
            ),
            itemCount: categoryProvider.categories.length,
            itemBuilder: (_ , index) {
              if (!categoryProvider.categories.isNotEmpty) {
                return Center(
                child: circularProgress(),
              );
              } else {
                return GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(width: 4, color: Colors.white)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        !categoryProvider.categories.isNotEmpty ?
                        Center(
                          child: circularProgress(),
                        )
                        : Container(
                          height: 70.0,
                          width: double.infinity,
                          decoration: BoxDecoration(color: Colors.deepOrange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16)),
                            child: Center(
                              child: ClipRRect(
                                borderRadius:
                                BorderRadius.all(Radius.circular(16)),
                                  child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: categoryProvider.categories[index].image,
                                    fit: BoxFit.cover,
                                  ),
                              ),
                            ),
                        ),
                        Expanded(child:
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            categoryProvider.categories[index].name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
              );
              }
            },
             ),
      ),
    );
  }
}


