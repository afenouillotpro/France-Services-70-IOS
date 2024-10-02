//
//  Antenne+CoreDataClass.swift
//  FS 70
//
//  Created by antoine fenouillot on 01/10/2024.
//
//

import Foundation
import CoreData

@objc(Antenne)
public class Antenne: NSManagedObject, Codable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeysFS.self)
        do {
            //try container.encode(fs_id?.doubleValue ?? 0, forKey: .fs_id)
            //try container.encode(fs_id?.stringValue ?? "0", forKey: .fs_id)
            //try container.encode(nom ?? "", forKey: .nom)
            try container.encode(fs_id ?? "blank", forKey: .fs_id)
        } catch {
            print("error encode antenne")
        }
    }
    
    //MARK: - DECODE
    
    required convenience public init(from decoder: Decoder) throws {
        // return the context from the decoder userinfo dictionary
        
        guard let contextUserInfoKey = CodingUserInfoKey.context,
              let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "Antenne", in: managedObjectContext)
        else {
            fatalError("decode failure antenne")
        }
        
        // Super init of the NSManagedObject
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeysFS.self)
        do {
            
            /*if let fsIdStr = try? values.decode(Double.self, forKey: .fs_id){
             fs_id = NSNumber(value:fsIdStr)
             }*/
            /*if let fsIdStr = try? values.decode(String.self, forKey: .fs_id),
             let fsId = Double(fsIdStr){
             
             fs_id = NSNumber(value:fsId)
             
             }*/
            
            if let fsIdStr = try? values.decode(UInt16.self, forKey: .fs_id){
                fs_id = String(fsIdStr)
            }
            
                c_name = try values.decode(String.self, forKey: .c_name)
                
                //aidant_connect = try values.decode(Bool.self, forKey: .aidant_connect)
                
                c_acronyme = try values.decode(String.self, forKey: .c_acronyme)
                
                if let latStr = try? values.decode(Double.self, forKey: .lat){
                    lat = NSNumber(value:latStr)
                }
                if let lonStr = try? values.decode(Double.self, forKey: .lon){
                    lon = NSNumber(value:lonStr)
                }
                
                c_adresse = try values.decode(String.self, forKey: .c_adresse)
                c_cl = try values.decode(String.self, forKey: .c_cl)
                
                if let cLatStr = try? values.decode(Double.self, forKey: .c_lat_cl){
                    c_lat_cl = NSNumber(value:cLatStr)
                }
                if let cLonStr = try? values.decode(Double.self, forKey: .c_lon_cl){
                    c_lon_cl = NSNumber(value:cLonStr)
                }
                
                c_logo = try values.decode(String.self, forKey: .c_logo)
                c_web = try values.decode(String.self, forKey: .c_web)
                
            
                conseiller = try values.decode(Bool.self, forKey: .conseiller)
                aidant_connect = try values.decode(Bool.self, forKey: .aidant_connect)
                
                cp = try values.decode(String.self, forKey: .cp)
                date_mise_service = try values.decode(String.self, forKey: .date_mise_service)
                email = try values.decode(String.self, forKey: .email)
                
                nom = try values.decode(String.self, forKey: .nom)
                tel = try values.decode(String.self, forKey: .tel)
                tel2 = try values.decode(String.self, forKey: .tel2)
                ville = try values.decode(String.self, forKey: .ville)
                adresse = try values.decode(String.self, forKey: .adresse)
            
            
                site = try values.decode(String.self, forKey: .site)
                site_social = try values.decode(String.self, forKey: .site_social)
                ferm_annuelle = try values.decode(String.self, forKey: .ferm_annuelle)
            
            
                comcom_id = try Int16(values.decode(Int.self, forKey: .comcom_id))
            
                horaires = NSSet(array: try values.decode([Horaire].self, forKey: .horaires))
                permanences = NSSet(array: try values.decode([Permanence].self, forKey: .permanence))
                outils = NSSet(array: try values.decode([Outil].self, forKey: .outils))
                    
            } catch {
                print ("error antenne init")
            }
        
    }
    
    enum CodingKeysFS: String, CodingKey {
        case adresse = "adresse"
        case c_acronyme = "c_acronyme"
        case lat = "lat"
        case lon = "lon"
        case c_adresse = "c_adresse"
        case c_cl = "c_cl"
        case c_lat_cl = "c_lat_cl"
        case c_lon_cl = "c_lon_cl"
        case c_logo = "c_logo"
        case c_name = "c_name"
        case c_web = "c_web"
        case conseiller = "conseiller"
        case cp = "cp"
        case date_mise_service = "date_mise_service"
        case email = "email"
        case nom = "nom"
        case tel = "tel"
        case tel2 = "tel2"
        case ville = "ville"
        case fs_id = "fs_id"
        case aidant_connect = "aidant_connect"
        case site = "site"
        case site_social = "site_social"
        case ferm_annuelle = "ferm_annuelle"
        case horaires = "horaires"
        case permanence = "permanence"
        case outils = "outils"
        case comcom_id = "comcom_id"
    }
}
