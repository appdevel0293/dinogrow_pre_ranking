// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_score_anchor.dart';

// **************************************************************************
// BorshSerializableGenerator
// **************************************************************************

mixin _$SaveScoreAnchor {
  BigInt get score => throw UnimplementedError();
  Ed25519HDPublicKey get user => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BU64().write(writer, score);
    const BPublicKey().write(writer, user);

    return writer.toArray();
  }
}

class _SaveScoreAnchor extends SaveScoreAnchor {
  _SaveScoreAnchor({
    required this.score,
    required this.user,
  }) : super._();

  final BigInt score;
  final Ed25519HDPublicKey user;
}

class BSaveScoreAnchor implements BType<SaveScoreAnchor> {
  const BSaveScoreAnchor();

  @override
  void write(BinaryWriter writer, SaveScoreAnchor value) {
    writer.writeStruct(value.toBorsh());
  }

  @override
  SaveScoreAnchor read(BinaryReader reader) {
    return SaveScoreAnchor(
      score: const BU64().read(reader),
      user: const BPublicKey().read(reader),
    );
  }
}

SaveScoreAnchor _$SaveScoreAnchorFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const BSaveScoreAnchor().read(reader);
}
