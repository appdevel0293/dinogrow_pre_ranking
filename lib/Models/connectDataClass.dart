import 'package:solana/solana.dart';
import 'package:web3dart/web3dart.dart';

enum Chain { bsc, polygon, solana }

class ConnectData {
  ConnectData({this.selectedChain, this.rpc, this.credEvm});
  Chain? selectedChain;
  String? rpc;
  EthPrivateKey? credEvm;
  Ed25519HDKeyPair? credSolana;
}
