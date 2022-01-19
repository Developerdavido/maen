import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maen/models/category.dart';
import 'package:maen/providers/product_provider.dart';
import 'package:maen/screens/details.dart';
import 'package:maen/utils/common.dart';
import 'package:maen/widgets/category_product.dart';
import 'package:maen/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();

  final CategoryModel categoryModel;

  const CategoryScreen({Key key, this.categoryModel}): super(key: key);
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      body: SafeArea(child:
      Column(
        children: [
          Stack(
            children: [
              Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Loading(),
                  )),
              ClipRRect(
                child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: widget.categoryModel.image,
                height: 160,
                fit: BoxFit.fill,
                width: double.infinity,),
              ),
              Container(
                height: 160,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.4),
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.05),
                        Colors.black.withOpacity(0.025),
                      ],
                    )),
              ),
              Positioned.fill(
                  bottom: 40,
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text( widget.categoryModel.name, style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w300,
                      ),))),
              Positioned.fill(
                  top: 5,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.black.withOpacity(0.2)
                            ),
                            child: IconButton(
                              icon: Icon(Icons.arrow_back,
                              color: Colors.white,),
                            )),
                      ),
                    ),)),
            ],
          ),
          SizedBox(height: 10,),
          Expanded(
            child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                padding: EdgeInsets.only(left: 16, right: 16),
              children: productProvider.productsByCategory.map((item) => GestureDetector(
                onTap: (){
                  changeScreen(context, Details(product: item,));
                },
                child: CategoryProduct(
                  product: item,
                ),
              ))
                .toList(),
            ),

          )
        ],
      )),
    );
  }
}
