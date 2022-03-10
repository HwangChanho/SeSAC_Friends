//
//  MapView.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/11.
//

import UIKit
import SnapKit
import MapKit

final class MapView: UIView, BasicViewSetup {
    // MARK: - Properties
    let mapView = MKMapView()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    let femaleButton = UIButton()
    let maleButton = UIButton()
    let allButton = UIButton()
    
    let locationButton: UIButton = {
        let button = UIButton()
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.setImage(UIImage(named: "bt_gps"), for: .normal)
        button.backgroundColor = .slpWhite
        button.tintColor = .slpBlack
        
        return button
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 32
        button.setImage(UIImage(named: "default"), for: .normal)
        button.backgroundColor = .slpBlack
        button.tintColor = .slpWhite
        
        return button
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        print(#function)
    }
    
    deinit {
        print("Deinit : MapView")
    }
    
    // MARK: - Methods
    func setupView() {
        setButton([allButton, maleButton, femaleButton], title: ["전체", "남자", "여자"])
        
        buttonOn(allButton)
        
        mapView.mapType = .standard
        // mapView.setUserTrackingMode(.follow, animated: true)
        mapView.isZoomEnabled = true
        // mapView.showsUserLocation = true
        mapView.isRotateEnabled = false
        
        // mapView.setCameraZoomRange(, animated: <#T##Bool#>)
    }
    
    func setButton(_ button: [UIButton], title: [String]) {
        var count = 0
        
        button.forEach {
            
            switch count {
            case 0:
                $0.layer.cornerRadius = 8
                $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
            case 2:
                $0.layer.cornerRadius = 8
                $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
            default:
                print(count)
            }
            
            $0.setTitle(title[count], for: .normal)
            $0.setTitleColor(.slpBlack, for: .normal)
            $0.backgroundColor = .slpWhite
            $0.clipsToBounds = true
            $0.titleLabel?.font = UIFont(name: UIFont.NSRegular, size: 14)
            count += 1
        }
    }
    
    func buttonOn(_ button: UIButton) {
        button.backgroundColor = .slpGreen
        button.setTitleColor(.slpWhite, for: .normal)
    }
    
    func buttonOff(_ button: UIButton) {
        button.backgroundColor = .slpWhite
        button.setTitleColor(.slpBlack, for: .normal)
    }
    
    func setupConstraints() {
        [mapView, stackView, locationButton, searchButton].forEach {
            addSubview($0)
        }
        
        [allButton, maleButton, femaleButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(locationButton.snp.width)
        }
        
        locationButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(48)
            make.height.equalTo(48)
        }
        
        searchButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
            make.width.equalTo(64)
            make.height.equalTo(64)
        }

        allButton.snp.makeConstraints { make in
            make.width.equalTo(48)
            make.height.equalTo(48)
        }
        
        maleButton.snp.makeConstraints { make in
            make.width.equalTo(48)
            make.height.equalTo(48)
        }
        
        femaleButton.snp.makeConstraints { make in
            make.width.equalTo(48)
            make.height.equalTo(48)
        }
    }
}
