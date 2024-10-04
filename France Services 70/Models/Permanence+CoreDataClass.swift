//
//  Permanence+CoreDataClass.swift
//  FS 70
//
//  Created by antoine fenouillot on 01/10/2024.
//
//

import Foundation
import CoreData

@objc(Permanence)
public class Permanence: NSManagedObject, Codable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeysPe.self)
        do {
            try container.encode(permanence_id ?? "blank", forKey: .permanence_id)
        } catch {
            print("error encode permanence")
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        // return the context from the decoder userinfo dictionary
        guard let contextUserInfoKey = CodingUserInfoKey.context,
        let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
        let entity = NSEntityDescription.entity(forEntityName: "Permanence", in: managedObjectContext)
        else {
            fatalError("decode failure permanence")
        }
        // Super init of the NSManagedObject
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeysPe.self)
        do {
            if let permIdStr = try? values.decode(Int.self, forKey: .permanence_id){
                permanence_id = String(permIdStr)
            }
            
            ouvertureA = try values.decode(String.self, forKey: .ouvertureA)
            fermetureA = try values.decode(String.self, forKey: .fermetureA)
            ouvertureM = try values.decode(String.self, forKey: .ouvertureM)
            fermetureM = try values.decode(String.self, forKey: .fermetureM)
            
            horaire_com = try values.decode(String.self, forKey: .horaire_com)
            com = try values.decode(String.self, forKey: .com)
            partenaire = try values.decode(String.self, forKey: .partenaire)
            mots_nom = try values.decode(String.self, forKey: .mots_nom)
            mots_libelle = try values.decode(String.self, forKey: .mots_libelle)
            
            jourid = try Int16(values.decode(Int.self, forKey: .jourid))
            partenaire_id = try Int16(values.decode(Int.self, forKey: .partenaire_id))
            recurrence_mens = try Int16(values.decode(Int.self, forKey: .recurrence_mens))
            mots_id = try Int16(values.decode(Int.self, forKey: .mots_id))

            rdv = try values.decode(Bool.self, forKey: .rdv)
            visio = try values.decode(Bool.self, forKey: .visio)
            permanent = try values.decode(Bool.self, forKey: .permanent)
            local = try values.decode(Bool.self, forKey: .local)
            
        } catch {
            print ("error permanence init \(permanence_id)")
        }
    }
    
    enum CodingKeysPe: String, CodingKey {
        
        case permanence_id = "permanence_id"
        case ouvertureA = "ouvertureA"
        case fermetureA = "fermetureA"
        case ouvertureM = "ouvertureM"
        case fermetureM = "fermetureM"
        case jourid = "jourid"
        case horaire_com = "horaire_com"
        case com = "com"
        case partenaire_id = "partenaire_id"
        case recurrence_mens = "recurrence_mens"
        case rdv = "rdv"
        case visio = "visio"
        case permanent = "permanent"
        case partenaire = "partenaire"
        case local = "local"
        case mots_id = "mots_id"
        case mots_nom = "mots_nom"
        case mots_libelle = "mots_libelle"
    }
    
}
