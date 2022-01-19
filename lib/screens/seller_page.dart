import 'package:flutter/material.dart';
import 'package:maen/Seller/seller_screen.dart';
import 'package:maen/providers/product_provider.dart';
import 'package:maen/providers/user_provider.dart';
import 'package:maen/screens/seller_products_page.dart';
import 'package:maen/theme/theme.dart';
import 'package:maen/utils/common.dart';
import 'package:provider/provider.dart';

class SellerPage extends StatefulWidget {
  const SellerPage({Key key}) : super(key: key);

  @override
  _SellerPageState createState() => _SellerPageState();
}


class _SellerPageState extends State<SellerPage> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   UserProvider.initialize();
  // }
  @override
  Widget build(BuildContext context) {
    UserProvider  user = Provider.of<UserProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    Color ash = Color(0xFFECF1F7);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text("Sellers",
         style: MaenTheme.lightTextTheme.headline3,),
      ),
      body: Container(
        child: ListView.builder(
            itemCount: user.sellers.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: ()async{
                  await productProvider.loadProductsBySeller(sellerId: user.sellers[index].id);
                  changeScreen(context, SellerProductPage(userModel: user.sellers[index]));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    decoration: BoxDecoration(
                      color: ash,
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.only(top: 3,),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Image.network(
                          user.sellers[index].image,
                          height: 90.0,
                          width: 90.0,
                        ),
                      ),
                      title: Text(user.sellers[index].name,
                      style: MaenTheme.lightTextTheme.bodyText1,),
                      subtitle: Text(user.getTotalSales().toString(),
                      style: MaenTheme.lightTextTheme.bodyText2,),
                    ),
                  ),
                ),
              );
            })
      ),
    );
  }
}
