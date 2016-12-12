//
//  ViewController.swift
//  KingBirdTest
//
//  Created by Andrey Ildyakov on 12.12.16.
//
//

import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    let lat = 55.778914190059794
    let lon = 37.59541869163513
    var locationLat = 55.778914190059794
    var locationLon = 37.59541869163513
    var markerList = [GMSMarker]()
    let label = UILabel()
    let yandexButton = UIButton()
  //MARK: - Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initMap()
        configUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Location Manager delegates -
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error" + error.description)
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let zoom : Float = 17
        locationLat = (location?.coordinate.latitude)!
        locationLon = (location?.coordinate.longitude)!
        
        let camera = GMSCameraPosition.cameraWithLatitude(locationLat, longitude: locationLon, zoom: zoom)
        
        self.mapView?.animateToCameraPosition(camera)
        
        addMarker()
        fitAllMarkers()
        showDistance(locationLat, toLon: locationLon)
        setButton()
    }
    
    //MARK: - Init Funcs -
    func initMap() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        mapView = GMSMapView(frame: self.view.bounds)
        self.view = mapView
        mapView.myLocationEnabled = false
        
        
    }
    func configUI(){
        self.view.insertSubview(label, aboveSubview: mapView)
        self.view.insertSubview(yandexButton, aboveSubview: mapView)
    }
    func addMarker() {
        
        let markerTo = GMSMarker()
        let markerToPosition = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        markerTo.position = markerToPosition
        
        var image = UIImage.init(SVGNamed: "Info", targetSize: CGSizeMake(40, 40), fillColor: UIColor.blackColor())
        markerTo.icon = image.cropImage()
        
        
        markerTo.map = mapView
        markerList.append(markerTo)
        
        let markerFrom = GMSMarker()
        let markerFromPosition = CLLocationCoordinate2D(latitude: locationLat, longitude: locationLon)
        
        markerFrom.position = markerFromPosition
        
        image = UIImage.init(SVGNamed: "Pin", targetSize: CGSizeMake(40, 40), fillColor: UIColor.blackColor())
        markerFrom.icon = image.cropImage()
        
        
        markerFrom.map = mapView
        markerList.append(markerFrom)
        
    }
    
    
    func fitAllMarkers() {
        var bounds = GMSCoordinateBounds()
        
        for marker in markerList {
            bounds = bounds.includingCoordinate(marker.position)
        }
        
        mapView.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(bounds))
    }
    
    func showDistance(toLat:CLLocationDegrees, toLon:CLLocationDegrees) {
        let fromPoint = CLLocation.init(latitude: lat, longitude: lon)
        let toPoint = CLLocation.init(latitude: toLat, longitude: toLon)
        let distance = toPoint.distanceFromLocation(fromPoint)
        setLabel(String(format:"%.0f km", distance/1000))
        
    }
    
    func setLabel(text:String) {
        self.label.text = text
        self.label.translatesAutoresizingMaskIntoConstraints = false
        
        let rightConstraint = NSLayoutConstraint(item: self.label, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.TrailingMargin, multiplier: 1, constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(item: self.label, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.BottomMargin, multiplier: 1, constant: -5)
        NSLayoutConstraint.activateConstraints([rightConstraint,bottomConstraint])
        
    }
    func setButton() {
        self.yandexButton.setTitle("To Yandex.Maps", forState: .Normal)
        self.yandexButton.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
        self.yandexButton.translatesAutoresizingMaskIntoConstraints = false
        self.yandexButton.layer.borderWidth = 2
        self.yandexButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.yandexButton.layer.cornerRadius = 2
        
        let rightConstraint = NSLayoutConstraint(item: self.yandexButton, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.label, attribute: NSLayoutAttribute.LeadingMargin, multiplier: 1, constant: -10)
        
        let bottomConstraint = NSLayoutConstraint(item: self.yandexButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.BottomMargin, multiplier: 1, constant: -5)
        
        let widthConstraint = NSLayoutConstraint(item: self.yandexButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 150)
        
        let heightConstraint = NSLayoutConstraint(item: self.yandexButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 20)
        
        NSLayoutConstraint.activateConstraints([rightConstraint,bottomConstraint, widthConstraint, heightConstraint])
        
    }
    
    func buttonAction(sender: UIButton!) {
        UIApplication.sharedApplication().openURL(NSURL.init(string: "yandexmaps://maps.yandex.ru/?rtext=\(lat),\(lon)~\(locationLat),\(locationLon)&rtt=mt")!)
        
    }

}



