import '../../../shared/models/warning.dart';
import 'get_fridge.dart';

class GetFridgeResponse {
  final String message;
  final GetFridge fridge;
  final List<Warning> warnings;

  GetFridgeResponse(this.message, this.fridge, this.warnings);
}
