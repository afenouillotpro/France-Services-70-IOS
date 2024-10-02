//
//  FSManager.swift
//  France Services 70
//CENTRALIZE DATA FOR APPLICATION
//  - user loacation
//  - user preferences
//  Created by antoine fenouillot on 09/08/2024.
//


import Foundation
import CoreLocation

class FSManager: NSObject, CLLocationManagerDelegate{
    
    static var shared = FSManager()
    
    private let locationManager:CLLocationManager = CLLocationManager()
    
    private var lastKnowLocation: CLLocation?
    
    private var selectedCityName: String?
    private var selectedCityPosition: String?
    
    private var useLocalisation = true
    
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    //var locationCity = ""
    
    //MARK: DATA
    var data: [Antenne] = []
    
    //var filteredData: [Establishment] = []
    
    
    
    override init() {
        super.init()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        //Init with system last know location
        lastKnowLocation = locationManager.location
        
        //Update location
        //locationManager.startUpdatingLocation()
        // Request a user’s location once
        locationManager.requestLocation()
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:  // Location services are available.
            locationManager.requestLocation()
            //enableLocationFeatures()
            break
            
        case .restricted, .denied:  // Location services currently unavailable.
            //disableLocationFeatures()
            break
            
        case .notDetermined:        // Authorization not determined yet.
           //manager.requestWhenInUseAuthorization()
            break
            
        default:
            break
        }
    }
    
    func reloadData(){
        loadDataFromWS()
    }
    
    //MARK: LOAD DATA
    private func loadDataFromWS(){
        
        print("Call getAntenne")
        FSService.shared.getAntenneList(){(success, antennes) in
            
            if success {
                //Success display result
                if( !antennes.isEmpty ){
                    print("Call getAntenneList success \(antennes.count) values")
                    self.data = antennes
                    
                   
                    self.alertViews()
                }
            } else {
                //Error display alert
                print("The antennes list download failed.")
            }
            
        }
    }
    
    /*//MARK: Get history
    func loadHistory(callback: @escaping (Bool, [Download]) -> Void) {
        
        print("Call loadHistory")
        BioService.shared.getHistoryList(callback: callback)
        
    }*/
    
    func alertViews(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatedata"), object: nil)
    }
    
    //MARK: Call by Views to retrieve data
    func getData()->[Antenne] {
        
        return data
    }
    
    //MARK: LOCALISATION
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.first {
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            if( latitude != 0.0 && longitude != 0.0 ){
                //Location retrieve
                print("Location update lat \(latitude) lon \(longitude)")
                
                if lastKnowLocation == nil {
                    //Notification retrieve localisation
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "retrievelocation"), object: location)
                    //Retirve new Data
                    // TODO : don't load each time geoloc change - load from coredata
                    //loadDataFromWS()
                }
                
                //Stop updating location
                //locationManager.stopUpdatingLocation()
                if let lastKnow = lastKnowLocation{
                    //CheckDistance
                    let distance = location.distance(from: lastKnow)
                    print("Location update distance \(distance)")
                        
                    if( distance > 0 ){
                        let distanceInKilometers = distance / 1000
                        if( distanceInKilometers > 2 ){
                            //TODO: if needed reload data
                            // TODO : don't load each time geoloc change - load from coredata
                            //loadDataFromWS()
                        }
                    }
                    
                }
                
                //Store last knowLocation
                lastKnowLocation = location
                
                // Here is the place you want to start reverseGeocoding
                geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                                // always good to check if no error
                                // also we have to unwrap the placemark because it's optional
                                // I have done all in a single if but you check them separately
                                if error == nil, let placemark = placemarks, !placemark.isEmpty {
                                    self.placemark = placemark.last
                                }
                                // a new function where you start to parse placemarks to get the information you need
                                self.parsePlacemarks()

                           })
                
                
            } else{
                print("Location update error lat \(latitude) lon \(longitude)")
            }
            // Handle location update
        }
    }
    
    func parsePlacemarks() {
       // here we check if location manager is not nil using a _ wild card
       if let _ = locationManager.location {
            // unwrap the placemark
            if let placemark = placemark {
                // wow now you can get the city name. remember that apple refers to city name as locality not city
                // again we have to unwrap the locality remember optionalllls also some times there is no text so we check that it should not be empty
                if let city = placemark.locality, !city.isEmpty {
                    // here you have the city name
                    // assign city name to our iVar
                    /*self.locationCity = city
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "retrievelocationname"), object: nil)*/
                    
                }

            }


        } else {
           // add some more check's if for some reason location manager is nil
        }

    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        // Handle failure to get a user’s location
        
        print("Location update error \(error)")
    }
    /*
    func setSelectedCity(cityName: String, cityPosition: String){
        selectedCityName = cityName
        selectedCityPosition = cityPosition
        useLocalisation = false
        //Update NAme
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "retrievelocationname"), object: nil)
        loadDataFromWS(localityName: (selectedCityName)!)
    }*/
    
    func setUseMyLocalisation(){
        useLocalisation = true
        //locationManager.requestLocation()
        reloadData()
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "retrievelocationname"), object: nil)
    }
    /*
    func getSelectedCityLabel()-> String{
        if let cityName = selectedCityName{
            return cityName
        } else {
            return ""
        }
    }
    */
    func getLatitude()->Double{
        if(useLocalisation){
            return locationManager.location?.coordinate.latitude ?? 0.0
        } else {
            let array = selectedCityPosition?.components(separatedBy: ",")
            guard let lat = array?[0] else { return Double(0.0) }
            return Double(lat)!
        }
    }
    
    func getLongitude()->Double{
        if(useLocalisation){
            return locationManager.location?.coordinate.longitude ?? 0.0
        } else {
            let array = selectedCityPosition?.components(separatedBy: ",")
            guard let lon = array?[1] else { return Double(0.0) }
            return Double(lon)!
        }
    }
    
    func getMyPositionText()->String{
        /*if( useLocalisation ){
            
            return "ma position"
        }
           } else {
                return locationCity.capitalized
            }
        } else {
            return getSelectedCityLabel().capitalized
        }*/
        return "ma position"
    }
    
    //MARK: SLIDER
    /*
    func getKilometers(value: Float) -> Float{
        var initValue = minRangeKilometer
        if( rangeCity ){
            initValue = minRangeKilometerCity
        }
        if( value < initValue){
            return initValue
        }
        
        let step: Float = initValue
        let roundedValue = round(value / step) * step
        return roundedValue
    }
    
    func getSliderValue()-> Float{
        return sliderValue
    }
    
    func setSliderValue(value: Float){
        sliderValue = value
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changerange"), object: nil)
    }
    
    func changeToCity(isCity: Bool){
        
        if( isCity ){
            self.rangeCity = true
            setSliderValue(value: minRangeKilometerCity)
        } else {
            self.rangeCity = false
            setSliderValue(value: minRangeKilometer)
        }
        
    }
    */
    
    
}

