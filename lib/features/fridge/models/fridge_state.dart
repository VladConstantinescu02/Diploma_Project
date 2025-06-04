import '../../../shared/models/warning.dart';
import 'get_fridge.dart';

class FridgeState {
  final GetFridge? fridge;
  final List<Warning>? warnings;

  FridgeState(this.fridge, this.warnings);

  static FridgeState defaultState() {
    return FridgeState(null, null);
  }
}