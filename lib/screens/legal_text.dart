import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class LegalText extends StatefulWidget {
  final String assetPath;
  LegalText(this.assetPath);
  @override
  _LegalTextState createState() => _LegalTextState();
}

class _LegalTextState extends State<LegalText> {
  String assetPath;
  bool _isLoading;
  PDFDocument document;
  @override
  void initState() {
    super.initState();
    assetPath = widget.assetPath;
    loadDocument();
    assetPath = widget.assetPath;
  }

  loadDocument() async {
    setState(() => _isLoading = true);
    document = await PDFDocument.fromAsset(assetPath);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Center(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                            Color(0xFFFEC72E),
                          ),
                        ),
                      )
                    : PDFViewer(document: document)),
            showPopContainer()
          ],
        ),
      ),
    );
  }

  Widget showPopContainer() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.height / 50,
            top: MediaQuery.of(context).size.height / 50),
        child: Center(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        height: MediaQuery.of(context).size.height / 15,
        width: MediaQuery.of(context).size.height / 15,
      ),
    );
  }
}
