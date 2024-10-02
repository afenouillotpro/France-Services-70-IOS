//
//  FSTabBarController.swift
//  France Services 70
//
//  Created by antoine fenouillot on 09/08/2024.
//

import UIKit

class FSTabBarViewController: UITabBarController {

    private let fsRepository = FSRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Button
    
        let image = UIImage(named: "circle-question-regular48")
        let scaledImage = image?.resizeImage(size: CGSize(width: 20, height: 20))
        let button1 = UIBarButtonItem(image: scaledImage, style: .plain, target: self, action: #selector(self.openInfos(_:)))
        
        let attributes = [NSAttributedString.Key.baselineOffset: NSNumber(value: 10)]
        button1.setTitleTextAttributes(attributes, for: .normal)
        self.navigationItem.rightBarButtonItem  = button1
        
        navigationController?.navigationBar.standardAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance.backgroundColor = UIColor(red: 2.35, green: 2.35, blue: 2.35, alpha: 1)
        //navigationController?.navigationBar.scrollEdgeAppearance!.shadowColor = .clear
        //navigationController?.navigationBar.scrollEdgeAppearance!.backgroundColor = UIColor(red: 2.35, green: 2.35, blue: 2.35, alpha: 1)
        
        UITabBar.appearance().clipsToBounds = true
        UITabBar.appearance().shadowImage = nil
        UITabBar.appearance().layer.borderWidth = 0
        
        //Force load all tab
        self.viewControllers!.forEach { $0.view }
        
        //Load city if needee
        loadFS()
        
        
        //TODO : need observer
        //NotificationCenter.default.addObserver(self, selector: #selector(self.receiveLocationName(_:)), name: NSNotification.Name(rawValue: "retrievelocationname"), object: nil)
       
        //Call updateData
        FSManager.shared.reloadData()
    }
    
    //MARK: - NOTIFICATION LOCATION NAME
    @objc func receiveLocationName(_ notification: NSNotification) {
        
        //updatePositionLabel()

    }
    
    
    //MARK : LOAD
    func loadFS(){
        let antennes = fsRepository.loadSavedData()
        if( !antennes.isEmpty ){
            print("antennes already loaded")
        } else {
            //Load cities
            FSService.shared.getAntenneList{(success, antennes) in
                if success {
                    //Success display result
                    if( !antennes.isEmpty ){
                        print("Call antennes success \(antennes.count) values")
                    }
                } else {
                    //Error display alert
                    print("Call antennes load saved data failed.")
                }
                
            }
        }
        
    }
    
    //MARK: - NOTIFICATION LOCATION
    @objc func openInfos(_ sender: Any) {

        performSegue(withIdentifier: "segueToCarousel", sender: nil)
        

    }
    
}

