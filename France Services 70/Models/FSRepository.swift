//
//  FSRepository.swift
//  FS
//  COREDATA CALL MANAGER
//  Created by antoine fenouillot on 27/08/2024.
//

import Foundation
import CoreData


final class FSRepository {

    // MARK: - Properties

    private let coreDataStack: CoreDataStack

    // MARK: - Init

    init(coreDataStack: CoreDataStack = CoreDataStack.sharedInstance) {
        self.coreDataStack = coreDataStack
    }

    // MARK: - Repository

    func getAntennesList(callback: @escaping ([Antenne]) -> Void) {
        // create request
        let request: NSFetchRequest<Antenne> = Antenne.fetchRequest()
        // execute request, ie get the saved data
        guard let antennes = try? coreDataStack.viewContext.fetch(request) else {
            callback([])
            return
        }
        callback(antennes)
    }
    
    /*
    func getAntennesFilterByDistance(latitude: Double, longitude: Double, distance: Float, callback: @escaping (Bool, [Antenne]) -> Void) {
        // create request
        let request: NSFetchRequest<Antenne> = Antenne.fetchRequest()
        
        //30km = 30 000 mètres for WS load 30km dans tous les cas
        let distance = Double(distance*1000 * 1.1);
        let radiusInMeters = 6371009.0; // Earth readius in meters
        let meanLatitidue = latitude * Double.pi / 180.0;
        let deltaLatitude = distance / radiusInMeters * 180.0 / Double.pi;
        let deltaLongitude = distance / (radiusInMeters * cos(meanLatitidue)) * 180.0 / Double.pi;
        let minLatitude = latitude - deltaLatitude;
        let maxLatitude = latitude + deltaLatitude;
        let minLongitude = longitude - deltaLongitude;
        let maxLongitude = longitude + deltaLongitude;
        let requestFilter = "(\(minLongitude) <= lon) AND (lon <= \(maxLongitude)) AND (\(minLatitude) <= lat) AND (lat <= \(maxLatitude))"
        
        request.predicate = NSPredicate( format: requestFilter)
        // execute request, ie get the saved data
        guard var antennes = try? coreDataStack.viewContextLocal.fetch(request) else {
            callback(false, [])
            return
        }

        for an in antennes{
                eta.distance = NSNumber(value: BioHelpers.shared.getDistanceBetweenPointInKm(p1Lat: latitude, p1Lon: longitude, p2Lat: Double(exactly: eta.latitude!)!, p2Lon: Double(exactly: eta.longitude!)!))
        }
        establishments.sort(by: self.sorterForDistanceASC)

        callback(true, establishments)
    }
    
    func getAntennesFilterByDistance(latitude: Double, longitude: Double, distance: Float) -> [Antenne] {
        // create request
        let request: NSFetchRequest<Antenne> = Antenne.fetchRequest()
        
        //30km = 30 000 mètres for WS load 30km dans tous les cas
        let distance = Double(distance*1000 * 1.1);
        let radiusInMeters = 6371009.0; // Earth readius in meters
        let meanLatitidue = latitude * Double.pi / 180.0;
        let deltaLatitude = distance / radiusInMeters * 180.0 / Double.pi;
        let deltaLongitude = distance / (radiusInMeters * cos(meanLatitidue)) * 180.0 / Double.pi;
        let minLatitude = latitude - deltaLatitude;
        let maxLatitude = latitude + deltaLatitude;
        let minLongitude = longitude - deltaLongitude;
        let maxLongitude = longitude + deltaLongitude;
        let requestFilter = "(\(minLongitude) <= lon) AND (lon <= \(maxLongitude)) AND (\(minLatitude) <= lat) AND (lat <= \(maxLatitude))"
        
        request.predicate = NSPredicate( format: requestFilter)
        // execute request, ie get the saved data
        guard var antennes = try? coreDataStack.viewContextLocal.fetch(request) else {
            //callback(false, [])
            return []
        }

        for ant in antennes{
                eta.distance = NSNumber(value: FSHelpers.shared.getDistanceBetweenPointInKm(p1Lat: latitude, p1Lon: longitude, p2Lat: Double(exactly: eta.latitude!)!, p2Lon: Double(exactly: eta.longitude!)!))
        }
        antennes.sort(by: self.sorterForDistanceASC)

        return establishments
        //callback(true, establishments)
    }
    
    func sorterForDistanceASC(this: Antenne, that: Antenne) -> Bool {
        return this.distance!.doubleValue < that.distance!.doubleValue
    
    }
    */
    
    //MARK: - All data context
    
    func saveContext() {
            if coreDataStack.viewContext.hasChanges {
                do {
                    try CoreDataStack.sharedInstance.viewContext.save()
                } catch {
                    print("An error occurred while saving: \(error)")
                }
            }
        }
    
    func loadSavedData() -> [Antenne]{
            let request: NSFetchRequest<Antenne> = Antenne.fetchRequest()
            
            do {
                // fetch is performed on the NSManagedObjectContext
                let data = try CoreDataStack.sharedInstance.viewContext.fetch(request)
                
                for ant in data{
                    print("LOADED \(ant.nom) horaires count: \(ant.horaires?.count)")
                }
                print("Got \(data.count) antennes")
                return data
            } catch {
                print("Fetch failed")
                return []
            }
        }
    
    //MARK: - by distance data context
    

    //MARK: Search one antenne
    func getAntenne(id: String) -> Antenne?{
        let request: NSFetchRequest<Antenne> = Antenne.fetchRequest()
        request.predicate = NSPredicate(format: "fs_id = %@", id)
        //let sort = NSSortDescriptor(key: "gitcommit.committer.date", ascending: false)
        //request.sortDescriptors = [sort]
        
        do {
            // fetch is performed on the NSManagedObjectContext
            let data = try CoreDataStack.sharedInstance.viewContext.fetch(request)
            print("Got one antenne with id = " + id)
            return data.first
        } catch {
            print("Fetch failed")
            return nil
        }
    }
    /*
    //MARK: Load saved Comcom search by string
    func loadSavedComcomByFilter(searchStr: String) -> [Comcom]{
            let request: NSFetchRequest<City> = Comcom.fetchRequest()
            request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchStr)
            
            do {
                // fetch is performed on the NSManagedObjectContext
                let data = try CoreDataStack.sharedInstance.viewContext.fetch(request)
                print("Got \(data.count) Comcom")
                return data
            } catch {
                print("Fetch failed cities")
                return []
            }
        }
    
    //MARK: Load all saved Comcom
    func loadAllSavedComcom() -> [Comcom]{
            let request: NSFetchRequest<Comcom> = Comcom.fetchRequest()
            
            do {
                // fetch is performed on the NSManagedObjectContext
                let data = try CoreDataStack.sharedInstance.viewContext.fetch(request)
                print("Got \(data.count) Comcoms")
                return data
            } catch {
                print("Fetch failed cities")
                return []
            }
        }
    */

}

