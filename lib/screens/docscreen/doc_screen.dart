import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ui_design/provider/crud_provider.dart';
import 'package:ui_design/reusablewidgets/multicolor_progress_indicator.dart';
import 'package:ui_design/reusablewidgets/update_delete_dialog.dart';
import 'package:ui_design/screens/mediaplayers/doc_viewer.dart';
import 'package:ui_design/screens/postscreen/add_file.dart';
import 'package:ui_design/theme/theme.dart';
import 'package:ui_design/utils/constants.dart';

class DocScreen extends StatefulWidget {
  const DocScreen({super.key});

  @override
  State<DocScreen> createState() => _DocScreenState();
}

class _DocScreenState extends State<DocScreen> {
  final fireStore =
      FirebaseFirestore.instance.collection('documents').snapshots();

  CollectionReference urlRef =
      FirebaseFirestore.instance.collection('documents');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Documents',
          style: GoogleFonts.ubuntu(),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fireStore,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    Constants.errorLogo,
                    height: 100,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('Some error occured',
                      style: GoogleFonts.ubuntu(
                          textStyle: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600))),
                ],
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: MulticolorProgressIndicator());
          } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    Constants.emptyLogo,
                    height: 100,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('No data available',
                      style: GoogleFonts.ubuntu(
                          textStyle: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600))),
                ],
              ),
            );
          }

          return SizedBox(
            child: Expanded(
              child: ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PdfViewer(
                              url: data['url'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 20, right: 5, left: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppTheme.accentColor),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 7),
                                  child: SizedBox(
                                      height: 22,
                                      child: Image.asset(
                                          Constants.documentLeadingIcon)),
                                ),
                                Text(
                                  data['title'],
                                  style: GoogleFonts.ubuntu(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            Consumer<CrudProvider>(
                              builder: (context, value, child) {
                                return GestureDetector(
                                    onTap: () {
                                      updateDeleteDialog(
                                        context: context,
                                        title: data['title'],
                                        appBarTitle: 'Update Document',
                                        collection: 'documents',
                                        fileType: FileType.custom,
                                        docId: document.id,
                                        fileName: data['fileName'],
                                        url: data['url'],
                                      );
                                    },
                                    child: const Icon(Icons.more_vert_rounded));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.accentColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddFile(
                  appBartitle: 'Add Document',
                  collection: 'documents',
                  fileType: FileType.custom),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
