import 'package:flashme/providers/profile_server_comm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../screens/friends_detail_page.dart';
import 'package:provider/provider.dart';

class FriendsTab extends StatefulWidget {
  @override
  _FriendsTabState createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab>
    with AutomaticKeepAliveClientMixin<FriendsTab> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  List<dynamic> friendsList = [];
  List<UserModel> allFriendsProfile = [];
  bool absorbPointer;

  @override
  void initState() {
    absorbPointer = false;
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void setState(fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    friendsList = Provider.of<ProfileServerComm>(context).friendsList;
    allFriendsProfile =
        Provider.of<ProfileServerComm>(context).allFriendsProfile;
    return AbsorbPointer(
      absorbing: absorbPointer,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.transparent,
        body: RefreshIndicator(
          backgroundColor: Colors.yellow.shade300,
          color: Colors.black,
          onRefresh: () async {
            setState(() => absorbPointer = true);
            await Provider.of<ProfileServerComm>(context, listen: false)
                .fetchProfileAndFriends();
            setState(() => absorbPointer = false);
          },
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.07,
                    vertical: MediaQuery.of(context).size.height * 0.005),
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                            Colors.black, //(0xFFFEC72E),
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: allFriendsProfile.length,
                        separatorBuilder: (ctx, index) {
                          return SizedBox(
                            height: 10,
                          );
                        },
                        itemBuilder: (ctx, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1, color: Colors.white),
                              color: Colors.white38,
                            ),
                            padding: EdgeInsets.only(
                                right:
                                    MediaQuery.of(context).size.width * 0.04),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => FriendsDetailPage(
                                        allFriendsProfile[index]),
                                  ),
                                );
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.transparent,
                                  maxRadius:
                                      MediaQuery.of(context).size.width * 0.1,
                                  child: FadeInImage(
                                    placeholder:
                                        AssetImage('images/placeholder.png'),
                                    image: NetworkImage(
                                      allFriendsProfile[index].picture,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  allFriendsProfile[index].name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                trailing: IconButton(
                                  onPressed: () async {
                                    var _sureDelete = await showDialog(
                                        context: context,
                                        builder: (ctx) => SimpleDialog(
                                              backgroundColor:
                                                  Colors.yellow.shade300,
                                              title: Text(
                                                'Are you sure you want to delete?',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: <Widget>[
                                                    FlatButton(
                                                      onPressed: () {
                                                        Navigator.of(ctx)
                                                            .pop(true);
                                                      },
                                                      color: Colors.white38,
                                                      child: Text('Yes',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                    FlatButton(
                                                      onPressed: () {
                                                        Navigator.of(ctx)
                                                            .pop(false);
                                                      },
                                                      color: Colors.white38,
                                                      child: Text('No',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ));

                                    if (!_sureDelete) return;

                                    friendsList.removeAt(index);
                                    Provider.of<ProfileServerComm>(context,
                                            listen: false)
                                        .removeFriend(friendsList, index);
                                  },
                                  icon: Icon(Icons.delete),
                                  color: Colors.black,
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
