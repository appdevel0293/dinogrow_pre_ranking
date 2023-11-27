import 'package:dinogrow/Models/connectDataClass.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart' as web3;
import 'package:solana/solana.dart';

Future<String> balanceSolana(ConnectData connectData) async {
  String wsUrl = connectData.rpc!.replaceFirst('https', 'wss');
  final client = SolanaClient(
    rpcUrl: Uri.parse(connectData!.rpc!),
    websocketUrl: Uri.parse(wsUrl),
  );
  final getBalance = await client.rpcClient.getBalance(
      connectData.credSolana!.address,
      commitment: Commitment.confirmed);
  final balanceInSol = (getBalance.value) / lamportsPerSol;
  return balanceInSol.toString();
}

Future<String> balanceEvm(ConnectData connectData) async {
  final address = connectData.credEvm!.address;
  var httpClient = Client();
  var ethClient = web3.Web3Client(connectData.rpc!, httpClient);

  web3.EtherAmount balance = await ethClient.getBalance(address);
  final balanceInEther =
      balance.getValueInUnit(web3.EtherUnit.ether).toString();
  return balanceInEther;
}
