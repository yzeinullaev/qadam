import Foundation
import CoreLocation

@MainActor
final class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var cityName: String?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let manager = CLLocationManager()
    private var continuation: CheckedContinuation<CLLocationCoordinate2D?, Never>?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    var authorizationStatus: CLAuthorizationStatus {
        manager.authorizationStatus
    }

    func requestLocation() async -> (coordinate: CLLocationCoordinate2D?, city: String?) {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            try? await Task.sleep(nanoseconds: 800_000_000)
        case .denied, .restricted:
            errorMessage = "Разрешите геолокацию в Настройках iPhone"
            return (nil, nil)
        default:
            break
        }

        guard manager.authorizationStatus == .authorizedWhenInUse ||
              manager.authorizationStatus == .authorizedAlways else {
            errorMessage = "Геолокация недоступна"
            return (nil, nil)
        }

        let coordinate = await withCheckedContinuation { (cont: CheckedContinuation<CLLocationCoordinate2D?, Never>) in
            continuation = cont
            manager.requestLocation()
        }

        guard let coordinate else {
            errorMessage = "Не удалось определить местоположение"
            return (nil, nil)
        }

        let city = await reverseGeocode(coordinate)
        cityName = city
        return (coordinate, city)
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task { @MainActor in
            continuation?.resume(returning: locations.last?.coordinate)
            continuation = nil
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            continuation?.resume(returning: nil)
            continuation = nil
            errorMessage = error.localizedDescription
        }
    }

    private func reverseGeocode(_ coordinate: CLLocationCoordinate2D) async -> String? {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return await withCheckedContinuation { cont in
            geocoder.reverseGeocodeLocation(location) { placemarks, _ in
                let place = placemarks?.first
                let city = place?.locality ?? place?.subAdministrativeArea ?? place?.administrativeArea
                cont.resume(returning: city)
            }
        }
    }
}
