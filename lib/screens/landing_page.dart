import '../tabs/settings_tab.dart';
import '../tabs/home_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../tabs/friends_tab.dart';
import '../providers/profile_server_comm.dart';

class LandingPage extends StatefulWidget {
  LandingPage();

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String name;
  UserModel myProfile;
  _LandingPageState();

  List<Widget> pages = [HomeTab(), FriendsTab(), SettingsTab()];
  bool isInitState;
  bool isLoading;

  @override
  void initState() {
    isInitState = true;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    if (isInitState) {
      setState(() {
        isLoading = true;
      });

      Provider.of<ProfileServerComm>(context)
          .fetchProfileAndFriends()
          .then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    isInitState = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    myProfile = Provider.of<ProfileServerComm>(context).userModel;

    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height / 4.5),
            child: appBarModified(),
          ),
          body: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                      Colors.black, //(0xFFFEC72E),
                    ),
                  ),
                )
              : Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 1,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 2,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Expanded(
                      child: TabBarView(
                        children: pages,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  showSnackBar(String a) {
    SnackBar snackBar = SnackBar(
      content: Text(a),
    );
    scaffoldKey.currentState.hideCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  TextStyle textStyle(double b, int a) {
    return TextStyle(
        color: Colors.black,
        fontSize: b,
        fontWeight: a == 1 ? FontWeight.bold : null);
  }

  Widget appBarModified() {
    return LayoutBuilder(builder: (contex, constraints) {
      return isLoading
          ? Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                  ),
                )
              ],
            )
          : Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    padding: EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth / 20),
                    child: SafeArea(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  top: constraints.maxHeight / 20,
                                  bottom: constraints.maxHeight / 20,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    myProfile.picture,
                                    fit: BoxFit.cover,
                                    height: constraints.maxHeight * 0.48,
                                    width: constraints.maxHeight * 0.48,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.03),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Welcome',
                                    style: textStyle(
                                        constraints.maxHeight / 10, 1),
                                  ),
                                  SizedBox(
                                      height: constraints.maxHeight * 0.01),
                                  Text(
                                    myProfile.name,
                                    style:
                                        textStyle(constraints.maxHeight / 7, 1),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.001,
                          ),
                          Container(
                            width: constraints.maxWidth,
                            padding: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth * 0,
                            ),
                            child: TabBar(
                              indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                                border: Border.all(width: 1, color: Colors.red),
                              ),
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                              indicatorSize: TabBarIndicatorSize.label,
                              isScrollable: false,
                              tabs: <Widget>[
                                tabContainer(constraints, 'HOME'),
                                tabContainer(constraints, 'FRIENDS'),
                                tabContainer(constraints, 'SETTINGS'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
    });
  }

  Container tabContainer(BoxConstraints constraints, String text) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      margin: EdgeInsets.all(1),
      width: constraints.maxWidth / 4,
      height: constraints.maxHeight / 5,
      child: Center(
        child: Text(
          text,
          style: textStyle(constraints.maxHeight / 15, 1),
        ),
      ),
    );
  }
}
