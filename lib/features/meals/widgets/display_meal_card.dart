import 'package:diploma_prj/features/meals/services/FireStore/delete_user_specific_meal_from_firestore.dart';
import 'package:diploma_prj/shared/widgets/alert_dialog_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:quickalert/quickalert.dart';
import '../models/meal_model.dart';
import '../services/FireStore/download_meal_from_firestore.dart';
import 'meal_info_drawer.dart';

const Color thirdColor = Color(0xFFF27507);
const Color secondaryColor = Color(0xFF3C4C59);
const Color backGroundColor = Color(0xFFFAFAF9);
const Color darkColor = Color(0xFF2B2B2B);
const Color mainColor = Color(0xFFF2A20C);

class DisplayMealCard extends ConsumerWidget {
  final Meal meal;

  const DisplayMealCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              onPressed: (BuildContext context) {
                showDialog(
                    context: context,
                    builder: (context) => TemplateDialogBox(
                        title: "Download meal",
                        content: meal.title,
                        textButtonColorCancel: backGroundColor,
                        textButtonColorConfirm: backGroundColor,
                        backgroundColor: backGroundColor,
                        buttonCancel: secondaryColor,
                        buttonConfirm: mainColor,
                        onConfirm: () async {
                          final downloadService = ref.read(downloadMealToDeviceProvider);
                          try {
                            await downloadService.generatePdf(meal);
                          } catch (e) {
                            if (!context.mounted) return;
                            QuickAlert.show(context: context,
                              type: QuickAlertType.error,
                              text: 'Username is about to be updated',
                              autoCloseDuration:
                              const Duration(milliseconds: 2),
                              confirmBtnColor: const Color(0xFFF27507),
                              confirmBtnText: 'OK',
                            );
                          }
                        },
                    ),
                );
              },
              icon: Icons.save,
              backgroundColor: const Color(0xFF3C4C59),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(48),
                bottomRight: Radius.zero,
                // Leave other corners square
                topRight: Radius.zero,
                bottomLeft: Radius.circular(48),
              ),
            ),
            SlidableAction(
              onPressed: (BuildContext context) {
                showDialog(
                  context: context,
                  builder: (context) => TemplateDialogBox(
                    title: 'You are about to delete',
                    content: meal.title,
                    textButtonColorCancel: backGroundColor,
                    textButtonColorConfirm: backGroundColor,
                    backgroundColor: backGroundColor,
                    buttonCancel: secondaryColor,
                    buttonConfirm: mainColor,
                    onConfirm: () async {
                      try {
                        final userId = FirebaseAuth.instance.currentUser?.uid;
                        final mealId = meal.mealId;

                        if (mealId == null) {
                          if (kDebugMode) {
                            print('Meal ID is null — cannot delete');
                          }
                          return;
                        }

                        if (userId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("User not logged in."),
                              backgroundColor: Color(0xFF8B1E3F),
                            ),
                          );
                          return;
                        }

                        final deleteUserMealFromFireStore =
                            ref.read(deleteUserSpecificMealProvider);

                        await deleteUserMealFromFireStore
                            .deleteUserSpecificMealFromFireStore(
                                mealId: mealId, userId: userId);
                      } catch (e) {
                        if (!context.mounted) return;
                        QuickAlert.show(context: context,
                          type: QuickAlertType.error,
                          text: 'Error in deleting meal',
                          autoCloseDuration:
                          const Duration(milliseconds: 2),
                          confirmBtnColor: const Color(0xFFF27507),
                          confirmBtnText: 'OK',
                        );
                      }
                    },
                  ),
                );
              },
              icon: Icons.delete_sweep,
              backgroundColor: const Color(0xFF8B1E3F),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(48),
                bottomRight: Radius.circular(48),
              ),
            ),
          ],
        ),
        child: GestureDetector(
          onDoubleTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => MealDetailDrawer(meal: meal),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(48.0),
            ),
            elevation: 0,
            color: mainColor,
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(48),
                        color: backGroundColor,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(48),
                        child: Image.network(
                          meal.image,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey.shade300,
                              alignment: Alignment.center,
                              child: const Icon(Icons.fastfood,
                                  color: Colors.white70, size: 40),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        // vertically center text
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(6, 4, 6, 6),
                            child: Text(
                              meal.title.isNotEmpty ? meal.title : 'No Title',
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
                              style: const TextStyle(
                                fontSize: 14,
                                color: backGroundColor,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                if (meal.readyInMinutes != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: backGroundColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Ready in ${meal.readyInMinutes ?? 0} min',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
