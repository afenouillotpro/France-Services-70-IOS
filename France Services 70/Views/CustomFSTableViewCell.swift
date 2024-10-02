//
//  CustomFSTableViewCell.swift
//  FS 70
//
//  Created by antoine fenouillot on 06/09/2024.
//

import UIKit

class CustomFSTableViewCell: UITableViewCell {

    
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateViewCell(antenne: Antenne){
        print(antenne.nom)
        name.text = antenne.nom?.capitalized
        //address.text = antenne.ville?.capitalized
        
       /* if let distance = antenne.distance?.floatValue {
        
                if( distance < 1 ){
                    km.text = String(format: "%.0f m", distance*1000)
                } else {
                    km.text = String(format: "%.0f km", distance)
                }
                
        }*/
       
    }
    
    private func addShadow() {

        cellView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor

        cellView.layer.shadowRadius = 2.0

        cellView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)

        cellView.layer.shadowOpacity = 2.0
     
    }
    
}

