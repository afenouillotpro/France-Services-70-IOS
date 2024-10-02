//
//  Horaires+CoreDataClass.swift
//  FS 70
//
//  Created by antoine fenouillot on 01/10/2024.
//
//

import Foundation
import CoreData

@objc(Horaire)
public class Horaire: NSManagedObject, Codable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeysHo.self)
        do {
            try container.encode(horaires_id ?? "blank", forKey: .horaires_id)
        } catch {
            print("error encode horaire")
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        // return the context from the decoder userinfo dictionary
        guard let contextUserInfoKey = CodingUserInfoKey.context,
        let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
        let entity = NSEntityDescription.entity(forEntityName: "Horaire", in: managedObjectContext)
        else {
            fatalError("decode failure horaire")
        }
        // Super init of the NSManagedObject
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeysHo.self)
        do {
            ouvertureA = try values.decode(String.self, forKey: .ouvertureA)
            fermetureA = try values.decode(String.self, forKey: .fermetureA)
            ouvertureM = try values.decode(String.self, forKey: .ouvertureM)
            fermetureM = try values.decode(String.self, forKey: .fermetureM)
            
            
            jourid = try Int16(values.decode(Int.self, forKey: .jourid))
            semaine = try Int16(values.decode(Int.self, forKey: .semaine))
            rdvA = try values.decode(Bool.self, forKey: .rdvA)
            rdvM = try values.decode(Bool.self, forKey: .rdvM)
            /*lastname = try values.decode(String.self, forKey: .lastname)
            userid = try values.decode(String.self, forKey: .userid)
            latitude = try values.decode(String.self, forKey: .latitude)
            longitude = try values.decode(String.self, forKey: .longitude)*/
            
            //uniqueid = try values.decode(GitCommit.self, forKey: .uniqueid)
        } catch {
            print ("error horaire init \(horaires_id)")
        }
    }
    
    enum CodingKeysHo: String, CodingKey {
        
        case horaires_id = "horaires_id"
        case ouvertureA = "ouvertureA"
        case fermetureA = "fermetureA"
        case ouvertureM = "ouvertureM"
        case fermetureM = "fermetureM"
        case jourid = "jourid"
        case rdvA = "rdvA"
        case rdvM = "rdvM"
        case semaine = "semaine"
    }
}
