import 'package:isar/isar.dart';
part 'fav_item.g.dart';

@collection
class Favourite {
  Id id = Isar.autoIncrement;
  String? url;

  Favourite({
    required this.id,
    required this.url,
  });
}
