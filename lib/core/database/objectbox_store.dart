// import 'package:path/path.dart' as p;
// import 'package:path_provider/path_provider.dart';
// import 'package:objectbox/objectbox.dart';
// import 'objectbox.g.dart'; // This will be generated
//
// class ObjectBox {
//   late final Store store;
//
//   ObjectBox._create(this.store);
//
//   static Future<ObjectBox> create() async {
//     final docsDir = await getApplicationDocumentsDirectory();
//     final store = await openStore(directory: p.join(docsDir.path, "category-cache"));
//     return ObjectBox._create(store);
//   }
// }