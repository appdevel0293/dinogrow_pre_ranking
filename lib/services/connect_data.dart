import 'package:dinogrow/Models/connectDataClass.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:solana/solana.dart';
import 'package:bip32/bip32.dart' as bip32;
import 'package:web3dart/web3dart.dart' as web3;
import 'package:bip39/bip39.dart';
import 'package:hex/hex.dart';

ConnectData _data = ConnectData();

Future<ConnectData> getconnectdata() async {
  const storage = FlutterSecureStorage();

  final chain = await storage.read(key: 'chain');
  final mnemonic = await storage.read(key: 'mnemonic');

  await dotenv.load(fileName: ".env");

  switch (chain) {
    case 'bsc':
      _data.rpc = dotenv.env['QUICKNODE_BSC_TESTNET'].toString();
      _data.selectedChain = Chain.bsc;
      await _credentialsEvm(mnemonic);
    case 'polygon':
      _data.selectedChain = Chain.polygon;
      _data.rpc = dotenv.env['QUICKNODE_POLYGON_TESTNET'].toString();
      await _credentialsEvm(mnemonic);
    case 'solana':
      _data.selectedChain = Chain.solana;
      _data.rpc = dotenv.env['QUICKNODE_SOLANA_DEVNET'].toString();
      await _credentialsSolana(mnemonic);
  }

  return _data;
}

Future _credentialsSolana(String? mnemonic) async {
  final keypair = await Ed25519HDKeyPair.fromMnemonic(mnemonic!);
  _data.credSolana = keypair;
}

Future _credentialsEvm(String? mnemonic) async {
  final seed = mnemonicToSeed(mnemonic!);
  final rootSeed = bip32.BIP32.fromSeed(seed);
  const path = "m/44'/60'/0'/0/0";
  final privateKeyList = rootSeed.derivePath(path).privateKey;
  final privateKeyHex = HEX.encode(privateKeyList as List<int>);
  final credentials = web3.EthPrivateKey.fromHex(privateKeyHex);
  _data.credEvm = credentials;
}
