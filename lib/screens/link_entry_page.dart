import 'package:flutter/material.dart';
import '../res/constants.dart';

class LinkEntryPage extends StatefulWidget {
  final int index;
  final bool containsData;
  final String socialLink;
  LinkEntryPage({
    this.index,
    this.containsData,
    this.socialLink,
  });
  @override
  _LinkEntryPageState createState() => _LinkEntryPageState();
}

class _LinkEntryPageState extends State<LinkEntryPage>
    with AutomaticKeepAliveClientMixin<LinkEntryPage> {
  String link = '';
  final _form = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(const Duration(milliseconds: 16), () {
      // Anything that use your key will go here.
    });
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/background.png'), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "images/logo.png",
                      height: MediaQuery.of(context).size.height * 0.09,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Image.asset(
                      "images/flashme.png",
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                Image.asset(
                  Constants.imgPaths[widget.index],
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.width * 0.3,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 120),
                  child: widget.containsData
                      ? showTextField(widget.socialLink, 4, 0)
                      : showTextField(
                          Constants.socialInformation[widget.index], 4, 0),
                ),
                showRaisedButton('SAVE'),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop(widget.socialLink);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height / 70,
                    ),
                    child: Text('< BACK',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  showRaisedButton(String a) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 20,
          vertical: MediaQuery.of(context).size.height / 57),
      child: ButtonTheme(
        height: 60,
        minWidth: MediaQuery.of(context).size.width,
        child: RaisedButton(
          child: Text(
            a,
            style: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.width / 30),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
          onPressed: () {
            _form.currentState.save();
            Navigator.of(context).pop(link);
          },
        ),
      ),
    );
  }

  Widget showTextField(String a, int b, int c) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 20,
      ),
      child: Form(
        key: _form,
        child: TextFormField(
          initialValue: widget.socialLink,
          onSaved: (value) {
            link = value.contains('www')
                ? value
                : Constants.socialLinks[widget.index].contains('tiktok')
                    ? Constants.socialLinks[widget.index] +
                        '@' +
                        value +
                        '?lang=en'
                    : Constants.socialLinks[widget.index] + value;
          },
          maxLines: 1,
          decoration: InputDecoration(
            hintText: a,
            hintMaxLines: 3,
            errorStyle: TextStyle(color: Colors.red),
            hintStyle:
                TextStyle(fontSize: MediaQuery.of(context).size.width / 33),
            filled: true,
            fillColor: Colors.white38,
            errorBorder: outlineInputBorder(false),
            focusedBorder: outlineInputBorder(true),
            enabledBorder: outlineInputBorder(true),
            focusedErrorBorder: outlineInputBorder(true),
          ),
        ),
      ),
    );
  }
}

OutlineInputBorder outlineInputBorder(bool a) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(
      color: a == true ? Colors.white : Colors.red,
    ),
  );
}
