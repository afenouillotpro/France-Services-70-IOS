//
//  FSTabBarController.swift
//  France Services 70
//
//  Created by antoine fenouillot on 09/08/2024.
//

import UIKit

class FSTabBarViewController: UITabBarController {

    private let bioRepository = BioRepository()
    
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
        navigationController?.navigationBar.scrollEdgeAppearance!.shadowColor = .clear
        navigationController?.navigationBar.scrollEdgeAppearance!.backgroundColor = UIColor(red: 2.35, green: 2.35, blue: 2.35, alpha: 1)
        
        UITabBar.appearance().clipsToBounds = true
        UITabBar.appearance().shadowImage = nil
        UITabBar.appearance().layer.borderWidth = 0
        
        //Force load all tab
        self.viewControllers!.forEach { $0.view }
        
        //Load city if needee
        loadCities()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.receiveLocationName(_:)), name: NSNotification.Name(rawValue: "retrievelocationname"), object: nil)
       
        //Call updateData
        BioManager.shared.reloadData()
    }
    
    //MARK: - NOTIFICATION LOCATION NAME
    @objc func receiveLocationName(_ notification: NSNotification) {
        
        updatePositionLabel()

    }
    
    
    //MARK : LOAD
    func loadCities(){
        let cities = bioRepository.loadAllSavedCities()
        if( !cities.isEmpty ){
            print("getCityList already loaded")
        } else {
            //Load cities
            BioService.shared.getCityList(){(success, cities) in
                if success {
                    //Success display result
                    if( !cities.isEmpty ){
                        print("Call getCityList success \(cities.count) values")
                    }
                } else {
                    //Error display alert
                    print("Call getCityList download failed.")
                }
                
            }
        }
        
    }
    
    //MARK: - NOTIFICATION LOCATION
    @objc func openInfos(_ sender: Any) {

        performSegue(withIdentifier: "segueToInfos", sender: nil)
        

    }
    
    func updateSliderValue(){
        (self.viewControllers?[0] as! BioMapController).slider.value = BioManager.shared.getSliderValue()
        (self.viewControllers?[1] as! ListViewController).slider?.value = BioManager.shared.getSliderValue()
        updatePositionLabel()
    }
    
    /*func setSliderValue(newValue: Float){
        sliderValue = newValue
        
        (self.viewControllers?[0] as! BioMapController).slider.value = sliderValue
        (self.viewControllers?[1] as! ListViewController).slider?.value = sliderValue
        updatePositionLabel()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changerange"), object: nil)
        
    }*/
    
    private func updatePositionLabel(){
        
        let sliderTxt = "\(String(format: "%.0f",  BioManager.shared.getSliderValue())) km autour de \(BioManager.shared.getMyPositionText())"
        (self.viewControllers?[0] as! BioMapController).positionLabel.text = sliderTxt
        (self.viewControllers?[1] as! ListViewController).positionLabel?.text = sliderTxt
        
        //updateMyPositionLabel()
       
    }
    
    //Update all slider for tab on tabview
    /*func updateAllSlider(){
        setSliderValue(newValue: BioManager.shared.getSliderValue())
    }*/
    
}

