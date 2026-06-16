/// Fallback coordinates for manual city selection when geolocation is off.
abstract final class CityCoordinates {
  static const defaultCoords = (43.238949, 76.889709); // Almaty

  static const cities = {
    'алматы': (43.238949, 76.889709),
    'almaty': (43.238949, 76.889709),
    'астана': (51.169392, 71.449074),
    'astana': (51.169392, 71.449074),
    'шымкент': (42.341737, 69.590103),
    'shymkent': (42.341737, 69.590103),
    'караганда': (49.804683, 73.109172),
    'aktobe': (50.283936, 57.166978),
    'актобе': (50.283936, 57.166978),
    'атырау': (47.116667, 51.883333),
    'istanbul': (41.008240, 28.978359),
    'стамбул': (41.008240, 28.978359),
  };

  static (double lat, double lng) forCity(String city) {
    final key = city.trim().toLowerCase();
    return cities[key] ?? defaultCoords;
  }
}
