import 'package:dinogrow/Models/connectDataClass.dart';
import 'package:dinogrow/anchor_types/save_score_anchor.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:solana/anchor.dart';
import 'package:solana/dto.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';
import 'package:solana_buffer/buffer.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart' as web3;
import 'package:http/http.dart';

Future<String> saveScore(ConnectData connectData, BigInt score) async {
  String result = "";
  await dotenv.load(fileName: ".env");
  if (connectData.selectedChain == Chain.polygon) {
    final address = dotenv.env['POLYGON_CONTRACT_ADDRESSS'].toString();

    final contractAddress = web3.EthereumAddress.fromHex(address);
    result = await _saveScoreEvm(
        connectData.rpc!, contractAddress, score, connectData.credEvm!);
    return result;
  } else if (connectData.selectedChain == Chain.bsc) {
    final address = dotenv.env['BSC_CONTRACT_ADDRESS'].toString();
    final contractAddress = web3.EthereumAddress.fromHex(address);
    result = await _saveScoreEvm(
        connectData.rpc!, contractAddress, score, connectData.credEvm!);
    return result;
  } else if (connectData.selectedChain == Chain.solana) {
    result = await _saveScoreSolana(
        connectData.rpc!, score, connectData.credSolana!);
    return result;
  }
  return result;
}

Future<String> _saveScoreEvm(String rpc, EthereumAddress contractAddress,
    BigInt score, web3.Credentials credentials) async {
  final abi = await rootBundle.loadString('assets/abi.json');
  final contract = web3.DeployedContract(
      web3.ContractAbi.fromJson(abi, 'userScores'), contractAddress);
  final function = contract.function("saveScore");
  final httpClient = Client();
  final ethClient = web3.Web3Client(rpc, httpClient);
  final gasPrice = await ethClient.getGasPrice();
  final chainId = await ethClient.getChainId();
  final result = await ethClient.sendTransaction(
    credentials,
    web3.Transaction.callContract(
      contract: contract,
      function: function,
      parameters: [score, credentials.address],
      from: credentials.address,
      gasPrice: web3.EtherAmount.inWei(gasPrice.getInWei),
    ),
    chainId: chainId.toInt(),
  );

  return result;
}

Future<String> _saveScoreSolana(
    String rpc, BigInt score, Ed25519HDKeyPair credentials) async {
  String method = "updatescore";
  String wsUrl = rpc.replaceFirst('https', 'wss');
  final client = SolanaClient(
    rpcUrl: Uri.parse(rpc),
    websocketUrl: Uri.parse(wsUrl),
  );
  await dotenv.load(fileName: ".env");
  final address = dotenv.env['SOLANA_PROGRAM_ADDRESS'].toString();
  final programIdPublicKey = Ed25519HDPublicKey.fromBase58(address);

  final profilePda = await Ed25519HDPublicKey.findProgramAddress(
    seeds: [
      Buffer.fromString("dinoscore"),
      credentials.publicKey.bytes,
    ],
    programId: programIdPublicKey,
  );
  final systemProgramId =
      Ed25519HDPublicKey.fromBase58(SystemProgram.programId);

  final result = await client.rpcClient
      .getAccountInfo(
        profilePda.toBase58(),
        commitment: Commitment.confirmed,
        encoding: Encoding.jsonParsed,
      )
      .value;
  if (result == null) {
    method = "savescore";
  }
  final saveScore = SaveScoreAnchor(score: score, user: credentials.publicKey);
  final instruction = await AnchorInstruction.forMethod(
    programId: programIdPublicKey,
    method: method,
    arguments: ByteArray(saveScore.toBorsh().toList()),
    accounts: <AccountMeta>[
      AccountMeta.writeable(pubKey: profilePda, isSigner: false),
      AccountMeta.writeable(pubKey: credentials.publicKey, isSigner: true),
      AccountMeta.readonly(pubKey: systemProgramId, isSigner: false),
    ],
    namespace: 'global',
  );

  final message = Message(instructions: [instruction]);
  final signature = await client.sendAndConfirmTransaction(
    message: message,
    signers: [credentials],
    commitment: Commitment.confirmed,
  );

  return signature;
}
