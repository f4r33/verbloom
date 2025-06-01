import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:verbloom/firebase_options.dart';
import 'seed_all_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  try {
    final seeder = GameDataSeeder();
    await seeder.seedAllData();
    print('Successfully seeded all game data!');
  } catch (e) {
    print('Error seeding game data: $e');
  }
  
  // Exit the app
  exit(0);
} 