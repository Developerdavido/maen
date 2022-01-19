import 'package:flutter/material.dart';
import 'package:maen/models/product.dart';
import 'package:maen/widgets/loading.dart';
import 'package:transparent_image/transparent_image.dart';

class PromotedProduct extends StatefulWidget {
  @override
  _PromotedProductState createState() => _PromotedProductState();

  final ProductModel product;
  const PromotedProduct({Key key, this.product}) : super(key: key);
}

class _PromotedProductState extends State<PromotedProduct> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[200],
                offset: Offset(-2, -1),
                blurRadius: 5),
          ]),
      child: Stack(
        children: [
          Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Loading(),
              )),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: widget.product.thumbnailUrl[0], fit: BoxFit.cover,),

            ),
          )
        ],
      ),
    );
  }
}
