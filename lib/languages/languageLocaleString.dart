import 'package:get/get.dart';
import 'package:wowfit/languages/en_US.dart';
import 'package:wowfit/languages/rus.dart';

class LocaleString extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en_US,
        'ru_RU': ru_RU,
      };
}
