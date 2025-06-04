import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/fridges_api_client.dart'; // Make sure this imports the class you just showed

final fridgesApiClientProvider = Provider<FridgesApiClient>((ref) {
  return FridgesApiClient('', null, ''); // Dummy args, unused in mock
});