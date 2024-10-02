//
//  FSService.swift
//  France Services 70
//
//  Created by antoine fenouillot on 09/08/2024.
//

import Foundation
import CoreData
import CryptoKit
class FSService{
    
    static var shared = FSService()
    
    private let fsRepository = FSRepository()
    
    private let FSListUrl = "http://192.168.10.104:2224/raw"
    //"http://192.168.10.104:2224/raw"
    //"http://data.3adigit.com/android/testbase.php"
    //"http://212.114.25.47:2222/antennes-json"
   
    //private let cityListUrl = "https://www.data.3adigit.com/bio/getcitylist.php"
    
    private var task: URLSessionDataTask?
    private var taskCity: URLSessionDataTask?
    
    private init() {}
    
    func getAntenneList(callback: @escaping (Bool, [Antenne]) -> Void) {
        
        var url = URLComponents(string: FSListUrl)!
        
        let actualTime = Date().millisecondsSince1970
        
        let string = String(format: "%.0f", actualTime)
        
        //MAP
        let secretString = "7Ajd8fKIfjfd4nnn"
        let key = SymmetricKey(data: Data(secretString.utf8))
        
        //let b64 = Data(string.utf8).base64EncodedString()
        let signature = HMAC<SHA256>.authenticationCode(for: Data(string.utf8).base64EncodedData(), using: key)
        
        let dat = Data(signature)
        let final = dat.base64EncodedString(options:   Data.Base64EncodingOptions(rawValue: 0))
        
        /*var allowedQueryParamAndKey = NSCharacterSet.urlQueryAllowed
        allowedQueryParamAndKey.remove(charactersIn: ";/?:@&=+$, ")
        final.addingPercentEncoding(withAllowedCharacters: allowedQueryParamAndKey)
     */
        
        url.queryItems = [
            URLQueryItem(name: "st", value: "\"" + String(format: "%.0f", actualTime) + "\""),
            URLQueryItem(name: "ss", value: "\"" + final + "\"")
            //URLQueryItem(name: "latitude", value: "\"47.9333\""),
            //URLQueryItem(name: "longitude", value: "\"5.9167\""),
            //URLQueryItem(name: "distance", value: "10)
        ]
        
        print(url.url)
        //task?.cancel()
        
        task = URLSession.shared.dataTask(with: url.url!) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                
                
                //Check error
                guard let data = data, error == nil else {
                    callback(false, [])
                    print("data error")
                    return
                }
                
                //Checkl response
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, [])
                    print("error not 200")
                    return
                }
                
                do {
                    print("start decode")
                    let decoder = JSONDecoder()
                    
                    print("start decode")
                    // Assign the NSManagedObject Context to the decoder
                    decoder.userInfo[CodingUserInfoKey.context!] = CoreDataStack.sharedInstance.viewContext
                    
                    //Display data
                    //let str = String(data: data, encoding: .utf8)
                    //print(str)
                    
                    let _ = try decoder.decode([Antenne].self, from: data)
                    //let _ = try decoder.decode([Antenne].self, from: data)
                    
                    // Move back on the main thread, as we call tableview.reload
                    //[weak self] in
                    //guard let self = self else {return}
                    self.fsRepository.saveContext()
                    let result = self.fsRepository.loadSavedData()
                    //Return value must be update
                    callback(true, result)
                    //self.loadSavedData()
                } catch let err {
                    print("Error fetch data", err)
                }
            }
        }
            task?.resume()
        
    }
    
    /*func getAntenneList(callback: @escaping (Bool, [Antenne]) -> Void) {
        
        var url = URLComponents(string: FSListUrl)!
        
        print(url.url)
        //task?.cancel()
        task = URLSession.shared.dataTask(with: url.url!) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                //Check error
                guard let data = data, error == nil else {
                    callback(false, [])
                    return
                }
                
                //Checkl response
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, [])
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    
                    // Assign the NSManagedObject Context to the decoder
                    decoder.userInfo[CodingUserInfoKey.context!] = CoreDataStack.sharedInstance.viewContext
                    
                    //Display data
                    let str = String(data: data, encoding: .utf8)
                    print(str)
                    
                    do {
                        try decoder.decode([Antenne].self, from: data)
                    } catch {
                        fatalError("Could not decode in the project! Error: \(error)")
                    }
                    //let _ = try decoder.decode([Antenne].self, from: data)
                    
                    // Move back on the main thread, as we call tableview.reload
                    //[weak self] in
                    //guard let self = self else {return}
                    self.fsRepository.saveContext()
                    let result = self.fsRepository.loadSavedData()
                    //Return value must be update
                    callback(true, result)
                    //self.loadSavedData()
                } catch let err {
                    print("Error fetch data", err)
                }
            }
            self.task?.resume()
        }
    }*/
     
    /*
    //MARK: Search by Distance from Coredata or from WS
    func getBioListAround(latitude: Double, longitude: Double, distance: Float, localityName: String, callback: @escaping (Bool, [Establishment]) -> Void) {
        
        if( latitude != 0.0 && longitude != 0.0 ){
            
        //Check if data exist into Download BDD
        let downloads = bioRepository.getAllDownload()
        
        let actualTime = Date().millisecondsSince1970
        
        //If exist avec bonne distance et date getdata from BDD
        for download in downloads {
         //check if distance is into range for cache
            let dist = BioHelpers.shared.getDistanceBetweenPoint(p1Lat: latitude, p1Lon: longitude, p2Lat: Double(download.latitude!.doubleValue), p2Lon: Double(download.longitude!.doubleValue))
            
            if( dist < BioManager.shared.maxCacheKilometer && (actualTime - Double(download.timestamp!)!) < BioManager.shared.maxCacheTime ) {
                //We retrieve cache data
                self.bioRepository.getEstablishmentsFilterByDistance(latitude: latitude, longitude: longitude, distance: distance, callback: callback)
                return
            }
        }
        
        //If not exist download from WS and set new data into BDD
        getBioListByDistance(latitude: latitude, longitude: longitude, distance: distance, localityName: localityName, callback: callback)
        
        } else {
            callback(false, [])
        }
       
        //Empty download bdd ?
        //self.bioRepository.clearContextLocal()
        
        
        
    }
    
    
    private func getBioListByDistance(latitude: Double, longitude: Double, distance: Float, localityName: String, callback: @escaping (Bool, [Establishment]) -> Void) {
        var url = URLComponents(string: bioListByDistanceUrl)!

        let actualTime = Date().millisecondsSince1970
        
        let string = String(format: "%.6f", latitude) + String(format: "%.6f", longitude) + String(format: "%.0f", distance) + String(format: "%.0f", actualTime)
        
        //MAP
        let secretString = "hjsdghk6698hihklo33"
        let key = SymmetricKey(data: Data(secretString.utf8))
        
        let b64 = Data(string.utf8).base64EncodedString()
        let signature = HMAC<SHA256>.authenticationCode(for: Data(string.utf8).base64EncodedData(), using: key)
        
        let dat = Data(signature)
        let final = dat.base64EncodedString(options:   Data.Base64EncodingOptions(rawValue: 0))
        
        //var allowedQueryParamAndKey = NSCharacterSet.urlQueryAllowed
        //allowedQueryParamAndKey.remove(charactersIn: ";/?:@&=+$, ")
        //final.addingPercentEncoding(withAllowedCharacters: allowedQueryParamAndKey)
        
        url.queryItems = [
            URLQueryItem(name: "latitude", value: "\"" + String(format: "%.6f", latitude) + "\""),
            URLQueryItem(name: "longitude", value: "\"" + String(format: "%.6f", longitude) + "\""),
            URLQueryItem(name: "distance", value: "\"" + String(format: "%.0f", distance) + "\""),
            URLQueryItem(name: "st", value: "\"" + String(format: "%.0f", actualTime) + "\""),
            URLQueryItem(name: "ss", value: "\"" + final + "\"")
            //URLQueryItem(name: "latitude", value: "\"47.9333\""),
            //URLQueryItem(name: "longitude", value: "\"5.9167\""),
            //URLQueryItem(name: "distance", value: "10)
        ]
        
        //print(url.url)
        
        //task?.cancel()
        task = URLSession.shared.dataTask(with: url.url!) { (data, response, error) in
            
            
            DispatchQueue.main.async {
                
                //Check error
                guard let data = data, error == nil else {
                    callback(false, [])
                    return
                }
                
                //Checkl response
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, [])
                    return
                }
                
                do {
                    //self.bioRepository.clearContextLocal()
                    let decoder = JSONDecoder()
                    
                    // Assign the NSManagedObject Context to the decoder
                    decoder.userInfo[CodingUserInfoKey.context!] = CoreDataStack.sharedInstance.viewContextLocal
                    
                    //Use to display data
                    //let str = String(decoding: data, as: UTF8.self)
                    //print (str)
                    
                    let _ = try decoder.decode([Establishment].self, from: data)
                    //save download data
                    
                    self.bioRepository.saveContextLocal()
                    //var result = self.bioRepository.loadSavedDataLocal()
                    
                    //Load only data aroud lat lon
                    var result = self.bioRepository.getEstablishmentsFilterByDistance(latitude: latitude, longitude: longitude, distance: distance)
                    
                    if(result.count > 0){
                        //Not save if count eta = 0
                        let download = Download(context: CoreDataStack.sharedInstance.viewContextLocal)
                        download.timestamp = String(Date().millisecondsSince1970)
                        download.latitude = NSNumber(value: latitude)
                        download.longitude = NSNumber(value: longitude)
                        download.distance = String(distance)
                        download.localityName = String(localityName)
                        self.bioRepository.saveContextLocal()
                    }
                    /*i
                    for eta in result{
                            eta.distance = NSNumber(value: BioHelpers.shared.getDistanceBetweenPointInKm(p1Lat: latitude, p1Lon: longitude, p2Lat: Double(exactly: eta.latitude!)!, p2Lon: Double(exactly: eta.longitude!)!))
                    }
                    result.sort(by: self.sorterForDistanceASC)*/
                    
                    //Return value must be update
                    callback(true, result)
                    //self.loadSavedData()
                } catch let err {
                print("Error fetch data", err)
                }
            }
                }
        task?.resume()
        }
    
    
    func sorterForDistanceASC(this: Establishment, that: Establishment) -> Bool {
        return this.distance!.doubleValue < that.distance!.doubleValue
    }
    
    
    func getBioDetail(id: String, callback: @escaping (Bool, Establishment?) -> Void) {
        
        var url = URLComponents(string: bioDetailUrl)!

        url.queryItems = [
            URLQueryItem(name: "id", value: "\"" + id + "\"")
        ]
        
        task?.cancel()
        task = URLSession.shared.dataTask(with: url.url!) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                //Check error
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                
                //Checkl response
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    
                    // Assign the NSManagedObject Context to the decoder
                    decoder.userInfo[CodingUserInfoKey.context!] = CoreDataStack.sharedInstance.viewContext
                    
                    let _ = try decoder.decode(Establishment.self, from: data)
                    
                    self.bioRepository.saveContext()
                    let result = self.bioRepository.getEstablishment(id: id)
                    //Return value must be update
                    callback(true, result)
                    //self.loadSavedData()
                } catch let err {
                print("Error fetch data", err)
                }
            }
                }
        task?.resume()
        }
        
        
    //MARK: City list
    func getCityList(callback: @escaping (Bool, [City]) -> Void) {
        var url = URLComponents(string: cityListUrl)!
        
        let actualTime = Date().millisecondsSince1970
        
        let string = String(format: "%.0f", actualTime)
        
        //MAP
        let secretString = "hjsdghk6698hihklo33"
        let key = SymmetricKey(data: Data(secretString.utf8))
        
        let b64 = Data(string.utf8).base64EncodedString()
        let signature = HMAC<SHA256>.authenticationCode(for: Data(string.utf8).base64EncodedData(), using: key)
        
        let dat = Data(signature)
        let final = dat.base64EncodedString(options:   Data.Base64EncodingOptions(rawValue: 0))
        
        //var allowedQueryParamAndKey = NSCharacterSet.urlQueryAllowed
        //allowedQueryParamAndKey.remove(charactersIn: ";/?:@&=+$, ")
        //final.addingPercentEncoding(withAllowedCharacters: allowedQueryParamAndKey)
        
        url.queryItems = [
            URLQueryItem(name: "st", value: "\"" + String(format: "%.0f", actualTime) + "\""),
            URLQueryItem(name: "ss", value: "\"" + final + "\"")
            //URLQueryItem(name: "latitude", value: "\"47.9333\""),
            //URLQueryItem(name: "longitude", value: "\"5.9167\""),
            //URLQueryItem(name: "distance", value: "10)
        ]
        
        taskCity?.cancel()
        taskCity = URLSession.shared.dataTask(with: url.url!) { (data, response, error) in
            
            
            DispatchQueue.main.async {
                
                //Check error
                guard let data = data, error == nil else {
                    callback(false, [])
                    return
                }
                
                //Checkl response
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, [])
                    return
                }
                
                do {
                    //self.bioRepository.clearContextLocal()
                    let decoder = JSONDecoder()
                    
                    // Assign the NSManagedObject Context to the decoder
                    decoder.userInfo[CodingUserInfoKey.context!] = CoreDataStack.sharedInstance.viewContext
                    
                    let _ = try decoder.decode([City].self, from: data)
                    
                    self.bioRepository.saveContext()
                    //let result = self.bioRepository.loadSavedCities()
                    //Return value must be update
                    callback(true, [])
                    //self.loadSavedData()
                } catch let err {
                print("Error fetch data", err)
                }
            }
                }
        taskCity?.resume()
        }
    
    
    //MARK: Download list history
    func getHistoryList(callback: @escaping (Bool, [Download]) -> Void) {
            
        //Check if data exist into Download BDD
        let downloads = bioRepository.getAllDownload()
        
        let actualTime = Date().millisecondsSince1970
        
        callback(true, downloads)
        
    }
    /*
    func getCityListByFilter(searchStr: String, callback: @escaping (Bool, [City]) -> Void) {
        var url = URLComponents(string: cityListByFilterUrl)!

        url.queryItems = [
            URLQueryItem(name: "searchStr", value: "\"" + searchStr + "\"")
        ]
        
        taskCity?.cancel()
        taskCity = URLSession.shared.dataTask(with: url.url!) { (data, response, error) in
            
            
            DispatchQueue.main.async {
                
                //Check error
                guard let data = data, error == nil else {
                    callback(false, [])
                    return
                }
                
                //Checkl response
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, [])
                    return
                }
                
                do {
                    //self.bioRepository.clearContextLocal()
                    let decoder = JSONDecoder()
                    
                    // Assign the NSManagedObject Context to the decoder
                    decoder.userInfo[CodingUserInfoKey.context!] = CoreDataStack.sharedInstance.viewContext
                    
                    let _ = try decoder.decode([City].self, from: data)
                    
                    self.bioRepository.saveContext()
                    let result = self.bioRepository.loadAllSavedCities()
                    //Return value must be update
                    callback(true, result)
                    //self.loadSavedData()
                } catch let err {
                print("Error fetch data", err)
                }
            }
                }
        taskCity?.resume()
        }*/
   */
}


