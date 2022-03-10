//
//  MKMap+Extension.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/15.
//

import MapKit

extension MKMapView {
    // 내위치 annotation
    func markAnnotation(_ coordinate: CLLocationCoordinate2D, region: Bool = true) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "my"
        self.addAnnotation(annotation)
        
        if region {
            let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            self.setRegion(region, animated: true)
        }
    }
    
    // 친구 annotation
    func markFriendsAnnotation(_ friendsData: [FromQueueDB], filter: GenderFilter = .all) {
        friendsData.forEach {
            let userGender = GenderFilter(index: $0.gender)!
            
            if filter == .all || (filter == .man && userGender == .man) || (filter == .woman && userGender == .woman) {
                
                let coordinate = CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.long)
                let annotation = AnnotationPin(
                    title: userGender == .woman ? "여자" : "남자",
                    subtitle: String($0.sesac),
                    coordinate: coordinate)
                
                self.addAnnotation(annotation)
            }
        }
    }
}
