//
//  AnnotationPin.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/12.
//

import MapKit

class AnnotationPin: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var image: SesacImage?
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.image = .level1
    }
}

class CustomAnnotationView: MKAnnotationView {
    static let identifier = "CustomAnnotationViewID"
    
    private let annotationFrame = CGRect(x: 0, y: 0, width: 40, height: 40)

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.frame = annotationFrame
        self.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented!")
    }
}
