import 'dart:async';
import 'dart:io';

import 'package:share_plus/share_plus.dart';

// String getApplicationURL() {
//   if (kIsWeb) {
//     return '';
//   }
//   return Platform.isAndroid
//       ? 'https://play.google.com/store/apps/details?id=com.blkfry.cocktails'
//       : 'https://itunes.apple.com/us/app/myapp/id1526041706?ls=1&mt=8';
// }

void shareText({
  required final String text,
}) {
  // Share.text(title, text, "text/plain");
  unawaited(Share.share(text));
}

void shareFile({required final File file}) {
  // ignore: deprecated_member_use
  unawaited(Share.shareFiles([file.path]));
}

// void shareImage({
//   required String text,
//   required File file,
//   String? title = 'Cocktail Hobbyist',
// }) {
//   unawaited(Share.shareFiles([file.path], text: text));
// }
