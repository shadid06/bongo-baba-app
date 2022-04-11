import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/change_language.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:active_ecommerce_flutter/screens/profile.dart';
import 'package:active_ecommerce_flutter/screens/order_list.dart';
import 'package:active_ecommerce_flutter/screens/wishlist.dart';

import 'package:active_ecommerce_flutter/screens/login.dart';
import 'package:active_ecommerce_flutter/screens/messenger_list.dart';
import 'package:active_ecommerce_flutter/screens/wallet.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/helpers/auth_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({
    Key key,
  }) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  onTapLogout(context) async {
    AuthHelper().clearUserData();

    // var logoutResponse = await AuthRepository().getLogoutResponse();
    //
    // if (logoutResponse.result == true) {
    //   ToastComponent.showDialog(logoutResponse.message, context,
    //       gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    //
    //   Navigator.push(context, MaterialPageRoute(builder: (context) {
    //     return Login();
    //   }));
    // }
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Login();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.red[50].withOpacity(1),
          Colors.green[50].withOpacity(1),
        ], begin: Alignment.topCenter)),
        child: Directionality(
          textDirection:
              app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
          child: Container(
            padding: EdgeInsets.only(top: 50),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  is_logged_in.$ == true
                      ?
                      //  Card(
                      //   child: ListTile(
                      //       leading: CircleAvatar(
                      //         backgroundImage: NetworkImage(
                      //           AppConfig.BASE_PATH + "${avatar_original.$}",
                      //         ),radius: 60,
                      //       ),
                      //       title: Text("${user_name.$}"),
                      //       subtitle:                 Text(
                      //         //if user email is not available then check user phone if user phone is not available use empty string
                      //         "${user_email.$ != "" && user_email.$ != null?
                      //         user_email.$:user_phone.$ != "" && user_phone.$ != null?user_phone.$:''}",
                      //       )

                      //                   ),
                      // )
                      // : Text(
                      //     AppLocalizations.of(context).main_drawer_not_logged_in,
                      //     style: TextStyle(
                      //         color: Color.fromRGBO(153, 153, 153, 1),
                      //         fontSize: 14)
                      // ),
                      Card(
                          elevation: 10,
                          shadowColor: Colors.black,
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.red[50], width: .5)),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16.0, bottom: 8.0, left: 20),
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                        color:
                                            Color.fromRGBO(112, 112, 112, .3),
                                        width: 2),
                                    //shape: BoxShape.rectangle,
                                  ),
                                  child: ClipRRect(
                                      clipBehavior: Clip.hardEdge,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100.0)),
                                      child: FadeInImage.assetNetwork(
                                        placeholder: 'assets/placeholder.png',
                                        image: AppConfig.BASE_PATH +
                                            "${avatar_original.$}",
                                        fit: BoxFit.fill,
                                      )),
                                ),
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 10),
                                    child: Text(
                                      "${user_name.$}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: MyTheme.font_grey,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          top: 4.0, left: 10),
                                      child: Text(
                                        //if user email is not available then check user phone if user phone is not available use empty string
                                        "${user_email.$ != "" && user_email.$ != null ? user_email.$ : user_phone.$ != "" && user_phone.$ != null ? user_phone.$ : ''}",
                                        style: TextStyle(
                                          color: MyTheme.medium_grey,
                                        ),
                                      )),
                                ],
                              )
                            ],
                          ),
                        )
                      : Container(),
                  Divider(),
                  ListTile(
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      leading: Image.asset(
                        "assets/language.png",
                        height: 18,

                        // color: Color.fromRGBO(153, 153, 153, 1),
                        color: Colors.indigo,
                      ),
                      title: Text(
                          AppLocalizations.of(context)
                              .main_drawer_change_language,
                          style: TextStyle(
                              color: Colors.black,

                              // color: Color.fromRGBO(153, 153, 153, 1),
                              fontSize: 17,
                              fontWeight: FontWeight.w600)),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ChangeLanguage();
                        }));
                      }),
                  ListTile(
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      leading: Image.asset(
                        "assets/home.png",
                        height: 18,
                        //  color: Color.fromRGBO(153, 153, 153, 1),
                        color: Colors.red,
                      ),
                      title: Text(AppLocalizations.of(context).main_drawer_home,
                          style: TextStyle(
                              color: Colors.black,
                              //color: Color.fromRGBO(153, 153, 153, 1),
                              fontSize: 17,
                              fontWeight: FontWeight.w600)),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Main();
                        }));
                      }),
                  is_logged_in.$ == true
                      ? ListTile(
                          visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4),
                          leading: Image.asset(
                            "assets/profile.png",
                            height: 20,

                            //color: Color.fromRGBO(153, 153, 153, 1),
                            color: Colors.green,
                          ),
                          title: Text(
                              AppLocalizations.of(context).main_drawer_profile,
                              style: TextStyle(
                                  color: Colors.black,
                                  //color: Color.fromRGBO(153, 153, 153, 1),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600)),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Profile(show_back_button: true);
                            }));
                          })
                      : Container(),
                  is_logged_in.$ == true
                      ? ListTile(
                          visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4),
                          leading: Image.asset(
                            "assets/order.png",
                            height: 18,
                            //color: Color.fromRGBO(153, 153, 153, 1),
                            color: Colors.pink,
                          ),
                          title: Text(
                              AppLocalizations.of(context).main_drawer_orders,
                              style: TextStyle(
                                  color: Colors.black,
                                  //color: Color.fromRGBO(153, 153, 153, 1),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600)),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return OrderList(from_checkout: false);
                            }));
                          })
                      : Container(),
                  is_logged_in.$ == true
                      ? ListTile(
                          visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4),
                          leading: Image.asset(
                            "assets/heart.png",
                            height: 18,
                            // color: Color.fromRGBO(153, 153, 153, 1),
                            color: Colors.purple,
                          ),
                          title: Text(
                              AppLocalizations.of(context)
                                  .main_drawer_my_wishlist,
                              style: TextStyle(
                                  color: Colors.black,
                                  // color: Color.fromRGBO(153, 153, 153, 1),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600)),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Wishlist();
                            }));
                          })
                      : Container(),
                  (is_logged_in.$ == true)
                      ? ListTile(
                          visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4),
                          leading: Image.asset(
                            "assets/chat.png",
                            height: 18,
                            // color: Color.fromRGBO(153, 153, 153, 1),
                            color: Colors.blue,
                          ),
                          title: Text(
                              AppLocalizations.of(context).main_drawer_messages,
                              style: TextStyle(
                                  color: Colors.black,
                                  //color: Color.fromRGBO(153, 153, 153, 1),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600)),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return MessengerList();
                            }));
                          })
                      : Container(),
                  is_logged_in.$ == true
                      ? ListTile(
                          visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4),
                          leading: Image.asset(
                            "assets/wallet.png",
                            height: 18,
                            //  color: Color.fromRGBO(153, 153, 153, 1),
                            color: Colors.brown,
                          ),
                          title: Text(
                              AppLocalizations.of(context).main_drawer_wallet,
                              style: TextStyle(
                                  color: Colors.black,
                                  //color: Color.fromRGBO(153, 153, 153, 1),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600)),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Wallet();
                            }));
                          })
                      : Container(),
                  Divider(height: 24),
                  is_logged_in.$ == false
                      ? ListTile(
                          visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4),
                          leading: Image.asset(
                            "assets/login.png",
                            height: 18,
                            //color: Color.fromRGBO(153, 153, 153, 1),
                            color: Colors.cyan,
                          ),
                          title: Text(
                              AppLocalizations.of(context).main_drawer_login,
                              style: TextStyle(
                                  // color: Color.fromRGBO(153, 153, 153, 1),
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600)),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Login();
                            }));
                          })
                      : Container(),
                  is_logged_in.$ == true
                      ? ListTile(
                          visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4),
                          leading: Image.asset(
                            "assets/logout.png",
                            height: 16,
                            // color: Color.fromRGBO(153, 153, 153, 1),
                            color: Colors.red,
                          ),
                          title: Text(
                              AppLocalizations.of(context).main_drawer_logout,
                              style: TextStyle(
//color: Color.fromRGBO(153, 153, 153, 1),
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600)),
                          onTap: () {
                            onTapLogout(context);
                          })
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
