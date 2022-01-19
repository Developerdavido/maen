import 'package:flutter/material.dart';
import 'package:maen/providers/app_provider.dart';
import 'package:maen/providers/product_provider.dart';
import 'package:maen/providers/user_provider.dart';
import 'package:maen/screens/details.dart';
import 'package:maen/utils/common.dart';
import 'package:maen/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final app = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.red),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Your favorites",
          style: TextStyle(
            color: Colors.red
          ),
        ),
        leading: IconButton(icon: Icon(Icons.arrow_back,
        color: Colors.white,),
            onPressed: (){
          Navigator.pop(context);
            }),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20
              ),
              itemCount: user.userModel.favorite.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: (){
                  changeScreen(
                    context,
                  Details(
                    product: user.userModel.favorite[index],
                  ));
                },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(width: 0.2, color: Colors.grey)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 116,
                          width: double.infinity,
                          decoration:
                          BoxDecoration(color: Colors.transparent),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Loading(),
                                  )),
                              Center(
                                child: ClipRRect(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                                    child: FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      image: user.userModel.favorite[index]["image"],
                                      fit: BoxFit.cover,
                                    ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 8, bottom: 0, left: 20, right: 10),
                            child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.userModel.favorite[index]["name"],
                                      style: TextStyle(
                                          color: Colors.black26, fontSize: 10),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "\C${user.userModel.favorite[index]["price"]}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete_outline,
                                          size: 16,
                                          color: Colors.red,),
                                          onPressed: ()async{
                                            app.changeLoading();
                                            bool value = await user.removeFromFavorite(favoriteItem: user.userModel.favorite[index]);
                                            if(value){
                                              user.reloadUserModel();
                                              print("product has been removed from your favorites");
                                              _key.currentState.showSnackBar(SnackBar(content:
                                              Text("The product has been removed from your favorites")));
                                              app.changeLoading();
                                              return;
                                            }else {
                                              print("Product has not been removed from your favorites....please check your internet connection");
                                            }
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ))),
                      ],
                    ),
                  ),
              )
          ),
        )
        ),
    );
  }
}
