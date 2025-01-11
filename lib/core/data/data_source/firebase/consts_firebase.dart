class ConstFirebase {
  // קולקציות ראשיות
  static const trainersCollections = 'trainers';
  static const traineesCollections = 'trainees';

  // קולקציות מקוננות
  static const trainerTraineesCollection = 'trainees'; // בתוך קולקציית המאמנים
  static const traineeWorkoutsCollection =
      'workouts'; // לדוגמה: חזרות של המתאמנים
  static const trainerLessonsCollection =
      'lessons'; // לדוגמה: שיעורים של המאמנים

  // לדוגמה: כדי להשיג מסמך מתאמן בתוך מאמן
  static String traineeDocumentPath(String trainerId) {
    return '$trainersCollections/$trainerId/$traineesCollections';
  }

  // לדוגמה: כדי להשיג את כל השיעורים של מאמן
  static String trainerLessonsPath(String trainerId) {
    return '$trainersCollections/$trainerId/$trainerLessonsCollection';
  }

  // לדוגמה: כדי להשיג את כל החזרות של מתאמן
  static String traineeWorkoutsPath(String trainerId, String traineeId) {
    return '$trainersCollections/$trainerId/$traineesCollections/$traineeId/$traineeWorkoutsCollection';
  }
}
