import 'package:isar/isar.dart';
import 'package:isar_test/isar_test.dart';
import 'package:test/test.dart';

part 'id_test.g.dart';

@collection
class ImplicitNullableIdModel {
  Id? id;
}

@collection
class ImplicitFinalIdModel {
  final Id id = Isar.autoIncrement;
}

@collection
class ExplicitIdModel {
  Id? id;
}

void main() {
  group('Id', () {
    late Isar isar;

    setUp(() async {
      isar = await openTempIsar([
        ImplicitNullableIdModelSchema,
        ImplicitFinalIdModelSchema,
        ExplicitIdModelSchema,
      ]);
    });

    group('Implicit nullable id', () {
      isarTest('Id should auto increment', () async {
        final id1 = await isar.tWriteTxn(
          () => isar.implicitNullableIdModels.tPut(ImplicitNullableIdModel()),
        );
        expect(id1, 1);

        final model = ImplicitNullableIdModel()..id = 2;
        final id2 = await isar.tWriteTxn(
          () => isar.implicitNullableIdModels.tPut(model),
        );
        expect(id2, 2);

        final id3 = await isar.tWriteTxn(
          () => isar.implicitNullableIdModels.tPut(ImplicitNullableIdModel()),
        );
        expect(id3, 3);

        final ids = await isar.tWriteTxn(
          () => isar.implicitNullableIdModels.tPutAll(
            List.generate(6, (_) => ImplicitNullableIdModel()),
          ),
        );
        expect(ids, [4, 5, 6, 7, 8, 9]);

        await qEqual(
          isar.implicitNullableIdModels.where().idProperty(),
          [1, 2, 3, 4, 5, 6, 7, 8, 9],
        );
      });

      isarTest('Auto increment should reset', () async {
        final ids1 = await isar.tWriteTxn(() {
          return isar.implicitNullableIdModels.tPutAll(
            List.generate(10, (_) => ImplicitNullableIdModel()),
          );
        });
        expect(ids1, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);

        final id11 = await isar.tWriteTxn(
          () => isar.implicitNullableIdModels.tPut(ImplicitNullableIdModel()),
        );
        expect(id11, 11);

        await isar.tWriteTxn(
          () => isar.implicitNullableIdModels.tClear(),
        );

        final id1 = await isar.tWriteTxn(
          () => isar.implicitNullableIdModels.tPut(ImplicitNullableIdModel()),
        );
        expect(id1, 1);

        final newIds = await isar.tWriteTxn(
          () => isar.implicitNullableIdModels.tPutAll(
            List.generate(5, (index) => ImplicitNullableIdModel()),
          ),
        );
        expect(newIds, [2, 3, 4, 5, 6]);

        await qEqual(
          isar.implicitNullableIdModels.where().idProperty(),
          [1, 2, 3, 4, 5, 6],
        );
      });

      isarTest('Negative id', () async {
        final model = ImplicitNullableIdModel()..id = -10;
        final id = await isar.tWriteTxn(
          () => isar.implicitNullableIdModels.tPut(model),
        );
        expect(id, -10);

        final newModel = await isar.implicitNullableIdModels.tGet(id);
        expect(newModel?.id, id);

        final ids = await isar.tWriteTxn(
          () => isar.implicitNullableIdModels.tPutAll(
            List.generate(16, (_) => ImplicitNullableIdModel()),
          ),
        );
        // Auto increment ids are always positive (minimum 1)
        expect(ids, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]);
      });

      isarTest(
        'Auto increment counter should always be the next biggest id',
        () async {
          final id1 = await isar.tWriteTxn(
            () => isar.implicitNullableIdModels.tPut(
              ImplicitNullableIdModel()..id = 1024,
            ),
          );
          expect(id1, 1024);

          final autoGeneratedId1 = await isar.tWriteTxn(
            () => isar.implicitNullableIdModels.tPut(ImplicitNullableIdModel()),
          );
          expect(autoGeneratedId1, 1025);

          final id2 = await isar.tWriteTxn(
            () => isar.implicitNullableIdModels.tPut(
              ImplicitNullableIdModel()..id = 4096,
            ),
          );
          expect(id2, 4096);

          final autoGeneratedId2 = await isar.tWriteTxn(
            () => isar.implicitNullableIdModels.tPut(ImplicitNullableIdModel()),
          );
          expect(autoGeneratedId2, 4097);

          final deleted = await isar.tWriteTxn(
            () => isar.implicitNullableIdModels.tDelete(4097),
          );
          expect(deleted, true);

          final autoGeneratedId3 = await isar.tWriteTxn(
            () => isar.implicitNullableIdModels.tPut(ImplicitNullableIdModel()),
          );
          expect(autoGeneratedId3, 4098);
        },
      );
    });

    group('Implicit final id', () {
      isarTest('Id should auto increment', () async {
        final id1 = await isar.tWriteTxn(
          () => isar.implicitFinalIdModels.tPut(ImplicitFinalIdModel()),
        );
        expect(id1, 1);

        final id2 = await isar.tWriteTxn(
          () => isar.implicitFinalIdModels.tPut(ImplicitFinalIdModel()),
        );
        expect(id2, 2);

        final ids = await isar.tWriteTxn(
          () => isar.implicitFinalIdModels.tPutAll(
            List.generate(6, (_) => ImplicitFinalIdModel()),
          ),
        );
        expect(ids, [3, 4, 5, 6, 7, 8]);

        await qEqual(
          isar.implicitFinalIdModels.where().idProperty(),
          [1, 2, 3, 4, 5, 6, 7, 8],
        );
      });
    });

    group('Explicit id', () {
      isarTest('Id should auto increment', () async {
        final id1 = await isar.tWriteTxn(
          () => isar.explicitIdModels.tPut(ExplicitIdModel()),
        );
        expect(id1, 1);

        final model = ExplicitIdModel()..id = 2;
        final id2 = await isar.tWriteTxn(
          () => isar.explicitIdModels.tPut(model),
        );
        expect(id2, 2);

        final id3 = await isar.tWriteTxn(
          () => isar.explicitIdModels.tPut(ExplicitIdModel()),
        );
        expect(id3, 3);

        final ids = await isar.tWriteTxn(
          () => isar.explicitIdModels.tPutAll(
            List.generate(6, (_) => ExplicitIdModel()),
          ),
        );
        expect(ids, [4, 5, 6, 7, 8, 9]);

        await qEqual(
          isar.explicitIdModels.where().idProperty(),
          [1, 2, 3, 4, 5, 6, 7, 8, 9],
        );
      });
    });
  });
}
