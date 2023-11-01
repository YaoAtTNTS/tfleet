

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:tfleet/main.dart';
import 'package:tfleet/service/static_content_service.dart';

class StaticContentPage extends StatefulWidget {
  const StaticContentPage({Key? key, required this.text, required this.index}) : super(key: key);

  final String text;
  final int index;

  @override
  State<StaticContentPage> createState() => _StaticContentPageState();
}

class _StaticContentPageState extends State<StaticContentPage> {

  Future<String?> _getContent () async {
    return await StaticContentService.getContent(widget.index);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: width,
                  height: width * 0.28,
                  decoration: BoxDecoration(
                      color: const Color(0xffe40947),
                      borderRadius: BorderRadius.circular(18)
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 34,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.chevron_left,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  top: 48,
                  child: Container(
                    width: width,
                    alignment: Alignment.topCenter,
                    child: Text(
                      widget.text,
                      style: const TextStyle(
                          fontSize: 24,
                          fontFamily: 'Lexend Deca',
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(10),
                alignment: Alignment.center,
                child: FutureBuilder<dynamic>(
                  future: _getContent(),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return Html(data: snapshot.data,);
                      } else {
                        return const Center(child: Text('No content'));
                      }
                    } else {
                      return Container();
                    }
                  }
                )
            ),
          ],
        ),
      ),
    );
  }
}
