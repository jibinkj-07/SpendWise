import 'dart:math';
import 'dart:ui';

sealed class GoalHelper {
  /// Function to generate a random but consistent color for a given letter
  static Color getColorForLetter(String letter) {
    final int hashCode =
        letter.codeUnitAt(0); // Get the character code of the letter
    Random random =
        Random(hashCode); // Seed the random generator with the hashCode

    // Generate RGB values based on the random number
    int red = random.nextInt(256);
    int green = random.nextInt(256);
    int blue = random.nextInt(256);

    return Color.fromARGB(255, red, green, blue); // Return the color
  }

  /// Function to determine if text should be dark or light based on background color
  static bool isDarkColor(Color color) {
    // Calculate the luminance of the color
    double luminance =
        (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    return luminance <
        0.5; // Return true if luminance is less than 0.5 (dark background)
  }
}
