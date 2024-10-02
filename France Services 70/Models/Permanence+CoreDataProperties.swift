//
//  Permanence+CoreDataProperties.swift
//  FS 70
//
//  Created by antoine fenouillot on 01/10/2024.
//
//

import Foundation
import CoreData

extension Permanence {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Permanence> {
        return NSFetchRequest<Permanence>(entityName: "Permanence")
    }

    @NSManaged public var permanence_id: String?
    @NSManaged public var ouvertureM: String?
    @NSManaged public var fermetureM: String?
    @NSManaged public var ouvertureA: String?
    @NSManaged public var fermetureA: String?
    @NSManaged public var horaire_com: String?
    @NSManaged public var com: String?
    @NSManaged public var jourid: Int16
    @NSManaged public var partenaire_id: Int16
    @NSManaged public var recurrence_mens: Int16
    @NSManaged public var rdv: Bool
    @NSManaged public var visio: Bool
    @NSManaged public var permanent: Bool
    @NSManaged public var partenaire: String?
    @NSManaged public var local: Bool
    @NSManaged public var mots_id: Int16
    @NSManaged public var mots_nom: String?
    @NSManaged public var mots_libelle: String?

}


extension Permanence : Identifiable {

}
