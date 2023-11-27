import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:solana/solana.dart';

part 'save_score_anchor.g.dart';

@BorshSerializable()
class SaveScoreAnchor with _$SaveScoreAnchor {
  factory SaveScoreAnchor({
    @BU64() required BigInt score,
    @BPublicKey() required Ed25519HDPublicKey user,
  }) = _SaveScoreAnchor;

  const SaveScoreAnchor._();

  factory SaveScoreAnchor.fromBorsh(Uint8List data) =>
      _$SaveScoreAnchorFromBorsh(data);
}
