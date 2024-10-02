//
//  Outil+CoreDataProperties.swift
//  FS 70
//
//  Created by antoine fenouillot on 02/10/2024.
//
//

import Foundation
import CoreData


extension Outil {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Outil> {
        return NSFetchRequest<Outil>(entityName: "Outil")
    }

    @NSManaged public var outils_id: String?
    @NSManaged public var nom: String?

}

extension Outil : Identifiable {

}
