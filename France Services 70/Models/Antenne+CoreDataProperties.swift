//
//  Antenne+CoreDataProperties.swift
//  FS 70
//
//  Created by antoine fenouillot on 11/09/2024.
//
//

import Foundation
import CoreData


extension Antenne {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Antenne> {
        return NSFetchRequest<Antenne>(entityName: "Antenne")
    }

    @NSManaged public var adresse: String?
    @NSManaged public var c_acronyme: String?
    @NSManaged public var c_adresse: String?
    @NSManaged public var c_cl: String?
    @NSManaged public var c_lat_cl: NSNumber?
    @NSManaged public var c_logo: String?
    @NSManaged public var c_lon_cl: NSNumber?
    @NSManaged public var c_name: String?
    @NSManaged public var c_web: String?
    @NSManaged public var cp: String?
    @NSManaged public var date_mise_service: String?
    @NSManaged public var email: String?
    @NSManaged public var fs_id: String?
    @NSManaged public var nom: String?
    @NSManaged public var tel: String?
    @NSManaged public var tel2: String?
    @NSManaged public var site: String?
    @NSManaged public var site_social: String?
    @NSManaged public var ville: String?
    @NSManaged public var ferm_annuelle: String?
    @NSManaged public var event: String?
    @NSManaged public var lat: NSNumber?
    @NSManaged public var lon: NSNumber?
    @NSManaged public var aidant_connect: Bool
    @NSManaged public var conseiller: Bool
    @NSManaged public var horaires: NSSet?
    @NSManaged public var permanences: NSSet?
    @NSManaged public var outils: NSSet?
    @NSManaged public var comcom_id: Int16
    
    

}

// MARK: Generated accessors for users
extension Antenne {

    @objc(addHorairesObject:)
    @NSManaged public func addToHoraires(_ value: Horaire)

    @objc(removeHorairesObject:)
    @NSManaged public func removeFromHoraires(_ value: Horaire)

    @objc(addHoraires:)
    @NSManaged public func addToHoraires(_ values: NSSet)

    @objc(removeHoraires:)
    @NSManaged public func removeFromHoraires(_ values: NSSet)
    
    @objc(addPermanencesObject:)
    @NSManaged public func addToPermanences(_ value: Permanence)

    @objc(removePermanencesObject:)
    @NSManaged public func removeFromPermanences(_ value: Permanence)

    @objc(addPermanences:)
    @NSManaged public func addToPermanences(_ values: NSSet)

    @objc(removePermanences:)
    @NSManaged public func removeFromPermanences(_ values: NSSet)
    
    @objc(addOutilsObject:)
    @NSManaged public func addToOutils(_ value: Outil)

    @objc(removeOutilsObject:)
    @NSManaged public func removeFromOutils(_ value: Outil)

    @objc(addOutils:)
    @NSManaged public func addToOutils(_ values: NSSet)

    @objc(removeOutils:)
    @NSManaged public func removeFromOutils(_ values: NSSet)

}


extension Antenne : Identifiable {

}

