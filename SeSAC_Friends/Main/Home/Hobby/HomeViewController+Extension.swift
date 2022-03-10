//
//  HomeViewController + Extension.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/13.
//

import UIKit
import CoreLocation
import MapKit

extension HomeViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    // MARK: - MKMapViewDelegate
    // 맵 위치이동
    func moveLocation(latitudeValue: CLLocationDegrees, longtudeValue: CLLocationDegrees, delta span: Double) {
        
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longtudeValue)
        let pSpanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: pSpanValue)
        
        mapView.mapView.setRegion(pRegion, animated: true)
    }
    
    func setPin() {
        viewModel.data
            .subscribe(onNext: { [self] data in
                mapView.mapView.removeAnnotations(mapView.mapView.annotations)
                mapView.mapView.markFriendsAnnotation(data.fromQueueDB, filter: gender)
            })
            .disposed(by: disposeBag)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = CustomAnnotationView()
        var annotationimageView = UIImageView()
        var image = UIImage()
        
        if annotation.title == "my" {
            annotationimageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
            image = UIImage(named: "nowLocation")!
        } else {
            annotationimageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 84, height: 84))
            image = (SesacImage(index: Int(annotation.subtitle! ?? "0")!)?.pageIconImage())!
        }
        
        annotationimageView.image = image
        
        annotationView.addSubview(annotationimageView)
        annotationView.annotation = annotation
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        viewModel.lat.accept(mapView.centerCoordinate.latitude)
        viewModel.long.accept(mapView.centerCoordinate.longitude)
        
        getQueueData()
        
        findAddress(lat: mapView.centerCoordinate.latitude, long: mapView.centerCoordinate.longitude, completion: { [self] address in
            bindQueueData()
            mapView.markAnnotation(mapView.centerCoordinate, region: false)
        })
    }
    
    
    //MARK: - LocationManagerDelegate
    // iOS 버전에 따른 분기 처리와 iOS 위치 서비스 여부 확인
    func checkUserLocationServicesAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus // iOS14 이상
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus() // iOS14 미만
        }
        
        //iOS 위치 서비스 확인
        if CLLocationManager.locationServicesEnabled() {
            // 권한 상태 확인 및 권한 요청 가능(8번 메서드 실행)
            checkCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("location off")
        }
    }
    
    // 사용자의 위치권한 여부 확인 (단, iOS 위치 서비스가 가능한 지 확인)
    func checkCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization() // 앱을 사용하는 동안에 대한 위치 권한 요청
            locationManager.startUpdatingLocation() // 위치 접근 시작
            print("notDetermined")
        case .restricted, .denied:
            print("DENIED")
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            print("Always")
        case .authorizedAlways:
            locationManager.startUpdatingLocation() // 위치 접근 시작
            print("authorizedAlways")
        @unknown default:
            print("Default")
        }
        
        if #available(iOS 14.0, *) {
            // 정확도 체크: 정확도 감소가 되어 있을경우, 배터리 up
            let accurancyState = locationManager.accuracyAuthorization
            
            switch accurancyState {
            case .fullAccuracy:
                print("FULL")
            case .reducedAccuracy:
                print("REDUCE")
            @unknown default:
                print("DEFAULT")
            }
        }
    }
    
    // 사용자가 위치 허용을 한 경우 (실시간)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        viewModel.lat.accept(mapView.mapView.centerCoordinate.latitude)
        viewModel.long.accept(mapView.mapView.centerCoordinate.longitude)
        
        currentLocation = manager.location
        
        findAddress(lat: mapView.mapView.centerCoordinate.latitude, long: mapView.mapView.centerCoordinate.longitude, completion: { [self] address in
            mapView.mapView.markAnnotation(mapView.mapView.centerCoordinate, region: false)
        })
    }
    
    // 위치 접근이 실패했을 경우 (실시간)
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("fail")
    }
    
    // IOS14 미만: 앱이 위치 관리자를 생성하고, 승인 상태가 변경이 될 떄 대리자에게 승인 상태를 알려줌.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkUserLocationServicesAuthorization()
    }
    
    // IOS14 이상: 앱이 위치 관리자를 생성하고, 승인 상태가 변경이 될 때 대리자에게 승인 상태를 알려줌
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserLocationServicesAuthorization()
    }
    
    // 주소 찾기
    func findAddress(lat: CLLocationDegrees, long: CLLocationDegrees, completion: @escaping (String) -> ()) {
        let findLocation = CLLocation(latitude: lat, longitude: long)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr") //원하는 언어의 나라 코드를 넣어주시면 됩니다.
        
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: {(placemarks, error) in
            if let address: [CLPlacemark] = placemarks {
                if let name: String = address.last?.name {
                    completion(name)
                } //전체 주소
            }
        })
    }
}
