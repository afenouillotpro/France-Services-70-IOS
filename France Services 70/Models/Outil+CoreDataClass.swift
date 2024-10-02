//
//  Outil+CoreDataClass.swift
//  FS 70
//
//  Created by antoine fenouillot on 02/10/2024.
//
//

import Foundation
import CoreData


@objc(Outil)
public class Outil: NSManagedObject, Codable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeysOu.self)
        do {
            try container.encode(outils_id ?? "blank", forKey: .outils_id)
        } catch {
            print("error encode permanence")
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        // return the context from the decoder userinfo dictionary
        guard let contextUserInfoKey = CodingUserInfoKey.context,
        let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
        let entity = NSEntityDescription.entity(forEntityName: "Outil", in: managedObjectContext)
        else {
            fatalError("decode failure outil")
        }
        // Super init of the NSManagedObject
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeysOu.self)
        do {
            nom = try values.decode(String.self, forKey: .nom)
            
        } catch {
            print ("error outil init \(outils_id)")
        }
    }
    
    enum CodingKeysOu: String, CodingKey {
        
        case outils_id = "outils_id"
        case nom = "nom"
    }
    
}
