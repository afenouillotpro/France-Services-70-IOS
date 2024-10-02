//
//  Horaire+CoreDataProperties.swift
//  FS 70
//
//  Created by antoine fenouillot on 01/10/2024.
//
//

import Foundation
import CoreData


extension Horaire {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Horaire> {
        return NSFetchRequest<Horaire>(entityName: "Horaire")
    }

    @NSManaged public var horaires_id: String?
    @NSManaged public var ouvertureM: String?
    @NSManaged public var fermetureM: String?
    @NSManaged public var ouvertureA: String?
    @NSManaged public var fermetureA: String?
    @NSManaged public var jourid: Int16
    @NSManaged public var rdvM: Bool
    @NSManaged public var rdvA: Bool
    @NSManaged public var semaine: Int16

}

extension Horaire : Identifiable {

}
