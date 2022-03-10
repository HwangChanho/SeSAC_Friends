//
//  HomeViewController.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/03.
//

import UIKit
import CoreLocation
import MapKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
    // MARK: - Properties
    var didSendEventClosure: ((HomeViewController.Event) -> Void)?
    
    let mapView = MapView()
    let viewModel = HomeViewModel.shared
    
    var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        return manager
    }()
    
    let sesacMainLocation = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    var currentLocation: CLLocation?
    
    var image: SesacImage?
    var disposeBag = DisposeBag()
    var alert = AlertView()
    
    var gender: GenderFilter = .all
    
    // MARK: - View
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        locationManager.stopUpdatingLocation()
        
        disposeBag = DisposeBag()
    }
    
    override func loadView() {
        super.loadView()
        view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.mapView.delegate = self
        locationManager.delegate = self
        
        moveLocation(latitudeValue: viewModel.lat.value, longtudeValue: viewModel.long.value, delta: 0.005)
        
        checkUserLocationServicesAuthorization()

        bindButton()
        bindQueueData()
    }
    
    deinit {
        print("Deinit : HomeViewController")
    }
    
    // MARK: - Methods
    func bindButton() {
        mapView.locationButton.rx.tap
            .subscribe(onNext: { [self] _ in
                if viewModel.region.value != 0 {
                    let status = locationManager.authorizationStatus
                    switch status {
                    case .denied:
                        showAlertController()
                    case .authorizedAlways, .authorizedWhenInUse, .authorized:
                        moveLocation(latitudeValue: currentLocation?.coordinate.latitude ?? sesacMainLocation.center.latitude, longtudeValue: currentLocation?.coordinate.longitude ?? sesacMainLocation.center.longitude, delta: 0.005)
                    default:
                        print(status)
                    }
                } else {
                    showEdgeToast(message: "동기화 중입니다.")
                }
            })
            .disposed(by: disposeBag)
        
        mapView.searchButton.rx.tap
            .subscribe(onNext: { [self] _ in
                getQueueData()
                didSendEventClosure?(.moveToHobby)
            })
            .disposed(by: disposeBag)
        
        mapView.allButton.rx.tap
            .subscribe(onNext: { [self] _ in
                gender = .all
                getQueueData()
                mapView.buttonOn(mapView.allButton)
                mapView.buttonOff(mapView.femaleButton)
                mapView.buttonOff(mapView.maleButton)
            })
            .disposed(by: disposeBag)
        
        mapView.femaleButton.rx.tap
            .subscribe(onNext: { [self] _ in
                gender = .woman
                getQueueData()
                mapView.buttonOn(mapView.femaleButton)
                mapView.buttonOff(mapView.allButton)
                mapView.buttonOff(mapView.maleButton)
            })
            .disposed(by: disposeBag)
        
        mapView.maleButton.rx.tap
            .subscribe(onNext: { [self] _ in
                gender = .man
                getQueueData()
                mapView.buttonOn(mapView.maleButton)
                mapView.buttonOff(mapView.femaleButton)
                mapView.buttonOff(mapView.allButton)
            })
            .disposed(by: disposeBag)
    }
    
    func bindQueueData() {
        viewModel.data
            .subscribe(onNext: { [self] data in
                mapView.mapView.removeAnnotations(mapView.mapView.annotations)
                mapView.mapView.markFriendsAnnotation(data.fromQueueDB, filter: gender)
            })
            .disposed(by: disposeBag)
    }
    
    func showAlertController() {
        alert.activeAlert(title: "세싹 프렌즈를 이용하시려면 위치권한이 필요합니다.", SubTitle: "위치권한에 동의 하시겠습니까?", button: [.cancel, .done])
        
        //메시지 창 컨트롤러를 표시
        alert.modalPresentationStyle = .overCurrentContext
        alert.handler = {
            // 확인 버튼
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            else {
                return
            }
        }
        self.present(alert, animated: false)
    }
    
    func getQueueData() {
        viewModel.caculateRegion()
        viewModel.onQueue { [self] message, code in
            switch code {
            case .noUser:
                didSendEventClosure?(.moveToOnboarding)
            default:
                showEdgeToast(message: message)
            }
        }
    }
}

// MARK: - Extension
extension HomeViewController {
    enum Event {
        case moveToOnboarding
        case moveToHobby
    }
}


