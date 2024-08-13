import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:ui_design/screens/audioscreen/audio_screen.dart';
import 'package:ui_design/screens/docscreen/doc_screen.dart';
import 'package:ui_design/screens/quotescreen/quote_screen.dart';
import 'package:ui_design/screens/videoscreen/video_screen.dart';
import 'package:ui_design/theme/theme.dart';
import 'package:ui_design/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    List<VoidCallback> navigatorList = [
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DocScreen(),
          ),
        );
      },
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const VideoScreen(),
          ),
        );
      },
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AudioScreen(),
          ),
        );
      },
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const QuoteScreen(),
          ),
        );
      },
    ];
    return PopScope(
       onPopInvoked: (value) {
        SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: AppTheme.primaryColor,
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: GridView.builder(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, bottom: 10, top: 50),
                itemCount: 4,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 90,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: navigatorList[index],
                    child: Card(
                      elevation: 10,
                      child: SizedBox(
                        height: 80,
                        child: Image(
                          image: AssetImage(
                            Constants.iconList[index],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Expanded(
            //   flex: 5,
            //   child: Container(
            //     color: AppTheme.whiteColor,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
