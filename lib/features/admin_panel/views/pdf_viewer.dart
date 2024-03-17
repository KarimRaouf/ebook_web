// import 'dart:html';
// import 'package:flutter/material.dart';
// import 'package:universal_html/html.dart' as html; // For web-specific HTML manipulation
// import 'dart:ui' as ui;
//
// class PdfViewerPage extends StatefulWidget {
//   final String url; // URL of the PDF file
//   PdfViewerPage({required this.url});
//
//   @override
//   _PdfViewerPageState createState() => _PdfViewerPageState();
// }
//
// class _PdfViewerPageState extends State<PdfViewerPage> {
//   late html.IFrameElement _iframeElement;
//
//   @override
//   void initState() {
//     super.initState();
//     // Create an IFrameElement
//     _iframeElement = html.IFrameElement()
//       ..src = widget.url
//       ..style.border = 'none'; // Remove iframe border
//
//     // Ensure the iframe is rendered
//     ui.platformViewRegistry.registerViewFactory(
//       'pdf-viewer',
//           (int viewId) => _iframeElement,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("PDF Viewer"),
//       ),
//       body: Container(
//         child: HtmlElementView(
//           viewType: 'pdf-viewer',
//         ),
//       ),
//     );
//   }
// }
