//
//  MapViewController.swift
//  FlightInfoWithAi
//
//  Created by ㅇㅇ ㅇ on 6/15/24.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var cityNames : [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        // 주석을 설정하는 함수입니다.
        addAnnotationsBetweenCities()
    }
    
    

    func addAnnotationsBetweenCities() {
        print(cityNames)
        guard cityNames.count >= 2 else {
            print("only one city")
            return
        }
        //
        let originCityName = cityNames[0]
        let destinationCityName = cityNames[1]
        print("도시 집합 주석  \(self.cityNames)")

        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(originCityName) { (originPlacemarks, error) in
            if let originPlacemark = originPlacemarks?.first, let originLocation = originPlacemark.location {
                geocoder.geocodeAddressString(destinationCityName) { (destinationPlacemarks, error) in
                    if let destinationPlacemark = destinationPlacemarks?.first, let destinationLocation = destinationPlacemark.location {
                        // 첫번째는 출발지 주석입니다.
                        self.addAnnotation(from: originLocation.coordinate, to: destinationLocation.coordinate)
                        
                        // 거리를 계산하여 주석으로 추가합니다.
                        // 거리 주석은 목적지와 출발지의 중앙에 위치합니다.
                        let distance = originLocation.distance(from: destinationLocation) // 미터 단위로 거리를 계산
                        let distanceInKm = distance / 1000 // 미터를 킬로미터로 변환
                        let distanceAnnotation = MKPointAnnotation()
                        let orilat = (originLocation.coordinate.latitude + destinationLocation.coordinate.latitude) / 2
                        let orilong = (originLocation.coordinate.longitude + destinationLocation.coordinate.longitude) / 2
                        distanceAnnotation.coordinate = CLLocationCoordinate2DMake(orilat,orilong )
                        distanceAnnotation.title = "거리"
                        distanceAnnotation.subtitle = String(format: "%.2f km", distanceInKm)
                        // 두번째 목적지 주석을 설정합니다.
                        self.mapView.addAnnotation(distanceAnnotation)
                        
                        // 카메라 범위를 설정합니다. 사용자가 이동할 수 있는 지도의 범위를 설정하는 것입니다.
                       self.cameraConstraining(orilat, orilong,distance: distance)
                        
                        // 목적지와 출발지 이외에 경유지나 왕복인 경우입니다.
                        if self.cityNames.count > 2 {
                            // 이 경우 아까 도시 이름 api 요청처럼 병렬 쓰레드 큐를 사용했습니다.
                            let concurrentQueue = DispatchQueue(label: "forMap", attributes: .concurrent)
                      
                            // 도시의 수 만큼 배열을 돌면서 주석을 추가합니다.
                            for i in 2..<self.cityNames.count {
                                print("도시 주석  \(i) 번째 \(self.cityNames[i])")
                                concurrentQueue.async {
                                    let geocoder = CLGeocoder()
                                    geocoder.geocodeAddressString(self.cityNames[i]) { placemarks, error in
                                        guard let placemark = placemarks?.first, let location = placemark.location else {
                                            print("도시 지오코더 실패 \(self.cityNames[i])")
                                            return
                                        }
                                        let Annotation = MKPointAnnotation()
                                        Annotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
                                        Annotation.title = self.cityNames[i]
                                        
                                        self.mapView.addAnnotation(Annotation)
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
    
    // 먼저 범위의 중앙을 설정합니다. 목적지와 출발지 중간으로 했습니다.
    
    
    private func cameraConstraining(_ la:CLLocationDegrees, _ lo : CLLocationDegrees,distance: CLLocationDistance) {
        let initialLocation = CLLocation(latitude: la, longitude: lo)
        let region = MKCoordinateRegion(
            center: initialLocation.coordinate,
            latitudinalMeters: pow(distance, 2),
            longitudinalMeters: pow(distance, 2)
        )
        // 범위는 목적지 출발지 간 거리의 2제곱으로 하고
        mapView.setCameraBoundary(
            MKMapView.CameraBoundary(coordinateRegion: region),
            animated: true
        )
        // 지도를 움직일 수 있는 최대 범위는 거리의 4제곱으로 했습니다.
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance:pow(distance, 4))
        mapView.setCameraZoomRange(zoomRange, animated: true)
    }
}
