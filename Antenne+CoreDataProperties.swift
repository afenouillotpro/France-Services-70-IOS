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
    @NSManaged public var aidant_connect: Bool
    @NSManaged public var c_acronyme: String?
    @NSManaged public var c_adresse: String?
    @NSManaged public var c_cl: String?
    @NSManaged public var c_lat_cl: String?
    @NSManaged public var c_logo: String?
    @NSManaged public var c_lon_cl: String?
    @NSManaged public var c_name: String?
    @NSManaged public var c_web: String?
    @NSManaged public var conseiller: Bool
    @NSManaged public var cp: String?
    @NSManaged public var date_mise_service: String?
    @NSManaged public var email: String?
    @NSManaged public var fs_id: String?
    @NSManaged public var lat: String?
    @NSManaged public var lon: String?
    @NSManaged public var nom: String?
    @NSManaged public var tel: String?
    @NSManaged public var ville: String?

}

extension Antenne : Identifiable {

}
