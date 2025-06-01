import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseSeeder {
  final FirebaseFirestore _firestore;

  DatabaseSeeder({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> seedLanguages() async {
    final languages = [
      {
        'name': 'English',
        'code': 'en',
        'flag': '🇬🇧',
        'isActive': true,
      },
      {
        'name': 'Spanish',
        'code': 'es',
        'flag': '🇪🇸',
        'isActive': true,
      },
      {
        'name': 'French',
        'code': 'fr',
        'flag': '🇫🇷',
        'isActive': true,
      },
      {
        'name': 'German',
        'code': 'de',
        'flag': '🇩🇪',
        'isActive': true,
      },
      {
        'name': 'Italian',
        'code': 'it',
        'flag': '🇮🇹',
        'isActive': true,
      },
    ];

    final batch = _firestore.batch();
    
    for (final language in languages) {
      final docRef = _firestore.collection('languages').doc(language['code'] as String);
      batch.set(docRef, language);
    }

    await batch.commit();
    print('Languages seeded successfully');
  }

  Future<void> seedWords() async {
    final words = [
      {
        'word': 'hello',
        'definition': 'used as a greeting',
        'example': 'Hello, how are you?',
        'pronunciation': 'həˈləʊ',
        'synonyms': ['hi', 'hey', 'greetings'],
        'antonyms': ['goodbye', 'farewell'],
        'difficulty': 'easy',
        'translations': {
          'es': 'hola',
          'fr': 'bonjour',
          'de': 'hallo',
          'it': 'ciao',
        },
        'tags': ['greeting', 'basic', 'conversation'],
      },
      {
        'word': 'beautiful',
        'definition': 'pleasing the senses or mind aesthetically',
        'example': 'What a beautiful sunset!',
        'pronunciation': 'ˈbjuːtɪfʊl',
        'synonyms': ['attractive', 'lovely', 'gorgeous'],
        'antonyms': ['ugly', 'unattractive'],
        'difficulty': 'easy',
        'translations': {
          'es': 'hermoso',
          'fr': 'beau',
          'de': 'schön',
          'it': 'bello',
        },
        'tags': ['adjective', 'appearance', 'positive'],
      },
      {
        'word': 'perseverance',
        'definition': 'persistence in doing something despite difficulty',
        'example': 'Success comes through perseverance.',
        'pronunciation': 'ˌpɜːsɪˈvɪərəns',
        'synonyms': ['persistence', 'determination', 'tenacity'],
        'antonyms': ['giving up', 'quitting'],
        'difficulty': 'medium',
        'translations': {
          'es': 'perseverancia',
          'fr': 'persévérance',
          'de': 'Ausdauer',
          'it': 'perseveranza',
        },
        'tags': ['noun', 'character', 'positive'],
      },
      {
        'word': 'ephemeral',
        'definition': 'lasting for a very short time',
        'example': 'Social media fame is often ephemeral.',
        'pronunciation': 'ɪˈfem(ə)rəl',
        'synonyms': ['transient', 'fleeting', 'momentary'],
        'antonyms': ['permanent', 'eternal'],
        'difficulty': 'hard',
        'translations': {
          'es': 'efímero',
          'fr': 'éphémère',
          'de': 'vergänglich',
          'it': 'effimero',
        },
        'tags': ['adjective', 'time', 'literary'],
      },
      {
        'word': 'serendipity',
        'definition': 'the occurrence of events by chance in a happy or beneficial way',
        'example': 'Finding this book was pure serendipity.',
        'pronunciation': 'ˌserənˈdɪpɪti',
        'synonyms': ['chance', 'fortune', 'luck'],
        'antonyms': ['misfortune', 'bad luck'],
        'difficulty': 'hard',
        'translations': {
          'es': 'serendipia',
          'fr': 'sérendipité',
          'de': 'Serendipität',
          'it': 'serendipità',
        },
        'tags': ['noun', 'chance', 'positive'],
      },
    ];

    final batch = _firestore.batch();
    
    for (final word in words) {
      // Add word to English collection
      final enWordRef = _firestore
          .collection('languages')
          .doc('en')
          .collection('words')
          .doc();
      batch.set(enWordRef, word);

      // Add word to daily words for today
      final dailyWordRef = _firestore
          .collection('languages')
          .doc('en')
          .collection('daily_words')
          .doc();
      batch.set(dailyWordRef, {
        ...word,
        'date': Timestamp.fromDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)),
      });
    }

    await batch.commit();
    print('Words seeded successfully');
  }

  Future<void> seedAll() async {
    await seedLanguages();
    await seedWords();
    print('Database seeding completed');
  }
} 