//
//  MapViewController.swift
//  FlightInfoWithAi
//
//  Created by ㅇㅇ ㅇ on 6/15/24.
//
/*
import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var cityNames : [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        addAnnotationsBetweenCities()
    }
    
    func addAnnotationsBetweenCities() {
        guard cityNames.count >= 2 else {
            print("두 개 이상의 도시가 필요합니다.")
            return
        }
        
        let originCityName = cityNames[0]
        let destinationCityName = cityNames[1]
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(originCityName) { (originPlacemarks, error) in
            if let originPlacemark = originPlacemarks?.first, let originLocation = originPlacemark.location {
                geocoder.geocodeAddressString(destinationCityName) { (destinationPlacemarks, error) in
                    if let destinationPlacemark = destinationPlacemarks?.first, let destinationLocation = destinationPlacemark.location {
                        self.addAnnotation(from: originLocation.coordinate, to: destinationLocation.coordinate)
                        
                        // 거리를 계산하여 주석으로 추가
                        let distance = originLocation.distance(from: destinationLocation) // 미터 단위로 거리를 계산합니다.
                        let distanceInKm = distance / 1000 // 미터를 킬로미터로 변환합니다.
                        let distanceAnnotation = MKPointAnnotation()
                        let orilat = (originLocation.coordinate.latitude + destinationLocation.coordinate.latitude) / 2
                        let orilong = (originLocation.coordinate.longitude + destinationLocation.coordinate.longitude) / 2
                        distanceAnnotation.coordinate = CLLocationCoordinate2DMake(orilat,orilong )
                        distanceAnnotation.title = "거리"
                        distanceAnnotation.subtitle = String(format: "%.2f km", distanceInKm)
                        self.mapView.addAnnotation(distanceAnnotation)
                        self.cameraConstraining(orilat, orilong,distance: distance)
                        
                        if self.cityNames.count > 2 {
                            let concurrentQueue = DispatchQueue(label: "com.example.concurrentQueue", attributes: .concurrent)
                            
                            for i in 2..<self.cityNames.count {
                                concurrentQueue.async {
                                    let geocoder = CLGeocoder()
                                    geocoder.geocodeAddressString(self.cityNames[i]) { placemarks, error in
                                        guard let placemark = placemarks?.first, let location = placemark.location else {
                                            print("Failed to geocode address for city:", self.cityNames[i])
                                            return
                                        }
                                        let Annotation = MKPointAnnotation()
                                        Annotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
                                        Annotation.title = self.cityNames[i]
                                        
                                        self.mapView.addAnnotation(Annotation)
                                        // Handle the location data here
                                    }
                                }
                            }
                        }

                    }
                }
            }
        }
    }
    
    func addAnnotation(from originCoordinate: CLLocationCoordinate2D, to destinationCoordinate: CLLocationCoordinate2D) {
        let originAnnotation = MKPointAnnotation()
        originAnnotation.coordinate = originCoordinate
        originAnnotation.title = "출발지"
        mapView.addAnnotation(originAnnotation)
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.coordinate = destinationCoordinate
        destinationAnnotation.title = "도착지"
        mapView.addAnnotation(destinationAnnotation)
        
        let polyline = MKPolyline(coordinates: [originCoordinate, destinationCoordinate], count: 2)
        mapView.addOverlay(polyline)
        
        mapView.showAnnotations([originAnnotation, destinationAnnotation], animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 2
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    private func cameraConstraining(_ la:CLLocationDegrees, _ lo : CLLocationDegrees,distance: CLLocationDistance) {
        let initialLocation = CLLocation(latitude: la, longitude: lo)
        let region = MKCoordinateRegion(
            center: initialLocation.coordinate,
            latitudinalMeters: distance,
            longitudinalMeters: distance
        )
        mapView.setCameraBoundary(
            MKMapView.CameraBoundary(coordinateRegion: region),
            animated: true
        )
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: distance*10)
        mapView.setCameraZoomRange(zoomRange, animated: true)
    }
}
*/
