import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:verbloom/features/rewards/data/seeders/achievements_seeder.dart';

Future<void> seedAchievements() async {
  final seeder = AchievementsSeeder();
  
  try {
    // Seed global achievements
    await seeder.seedAchievements();
    print('Successfully seeded global achievements');

    // Get all users and seed their achievements
    final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
    
    for (var userDoc in usersSnapshot.docs) {
      await seeder.seedUserAchievements(userDoc.id);
      print('Successfully seeded achievements for user: ${userDoc.id}');
    }

    print('Successfully completed seeding all achievements');
  } catch (e) {
    print('Error seeding achievements: $e');
    rethrow;
  }
} 