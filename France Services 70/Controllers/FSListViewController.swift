//
//  FSListViewController.swift
//  FS 70
//
//  Created by antoine fenouillot on 06/09/2024.
//

import UIKit
import CoreData

class FSListViewController: UIViewController {
    
    var dataToDisplay: [Antenne] = []
    
    private let fsRepository = FSRepository()
    
    @IBOutlet weak var tableView: UITableView!
    var customTabBarController: FSTabBarViewController?
    
        /* @IBAction func filterButton(_ sender: Any) {
        performSegue(withIdentifier: "segueToFilterEdit", sender: nil)
    }
    
    @IBAction func sliderValueChange(_ sender: UISlider) {
        
        guard let customTabBarController = customTabBarController else {
            return
        }
        
        let value = BioManager.shared.getKilometers(value: sender.value)
        
        if(BioManager.shared.getSliderValue() != value){
            sender.value = value
            BioManager.shared.setSliderValue(value: value)
            //changeDataRange()
        } else{
            sender.value = value
        }
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customTabBarController = self.tabBarController as? FSTabBarViewController
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.receiveNewData(_:)), name: NSNotification.Name(rawValue: "updatedata"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeRange(_:)), name: NSNotification.Name(rawValue: "changefilter"), object: nil)
        
    }
    
    /*override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: break;
                // It's an iPhone
        case .pad:
                // It's an iPad (or macOS Catalyst)
            do {
                var sizeHeight = 250;
                var sizeMargin = 140;
                let height = self.view.bounds.height - CGFloat(sizeHeight)
                    let width = self.view.bounds.width

                let widthConstraint = NSLayoutConstraint(item: mapView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: width)
                    self.view.addConstraint(widthConstraint)

                let heightConstraint = NSLayoutConstraint(item: mapView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: height)
                mapView.translatesAutoresizingMaskIntoConstraints = false
                
                let xContraints = NSLayoutConstraint(item: mapView, attribute: NSLayoutConstraint.Attribute.topMargin, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.topMargin, multiplier: 1, constant: CGFloat(sizeMargin))
                    
                NSLayoutConstraint.activate([heightConstraint,widthConstraint,xContraints])
                
                self.mapView.addConstraint(heightConstraint)}
        case .unspecified:break;
        case .tv:break;
        case .carPlay:break;
        case .mac:break;
        case .vision: break;
        @unknown default:break;
        }
        
    
    }*/
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /*guard let customTabBarController = customTabBarController else {
            return
        }
        customTabBarController.updateSliderValue()*/
        
        //updateData()
        
    }
    
    //MARK: - NOTIFICATION DATA
    @objc func receiveNewData(_ notification: NSNotification) {
       /* guard let customTabBarController = customTabBarController else {
            return
        }
        customTabBarController.updateSliderValue()
        changeDataRange()
*/
        
        self.updateTableView()
    }
    
    //MARK: - NOTIFICATION CHANGE RANGE
    @objc func changeRange(_ notification: NSNotification) {
        
        //changeDataRange()

    }
    
    /*func updateDisplay(){
        guard let customTabBarController = customTabBarController else {
            return
        }
        customTabBarController.updatePositionLabel()
    }*/
    
    //MARK: - Get data from BioManager
    
    func changeDataRange(){
        
        /*  guard let customTabBarController = customTabBarController else {
            dataToDisplay = []
            return
        }
        
        customTabBarController.updateSliderValue()
        slider.minimumValue = 0.0
        //update range
        if( BioManager.shared.rangeCity ){
            //set slider to city range
            slider.maximumValue = BioManager.shared.maxRangeKilometerCity
            slider.value = BioManager.shared.getSliderValue()
        } else {
            //set slider to max range
            slider.maximumValue = BioManager.shared.maxRangeKilometer
            slider.value = BioManager.shared.getSliderValue()
        }
        
        dataToDisplay = BioManager.shared.getData()
        self.updateTableView()
      */
        
    
    }
    
    private func presentAlert(text: String) {
        let alertVC = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    // MARK: Display data
    private func updateTableView(){
        dataToDisplay = FSManager.shared.data
        print("Reload \(dataToDisplay.count) table view antennes")
        print(dataToDisplay[0].nom)
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    private func prepareToFSDetail(_ antenne: Antenne) {
        performSegue(withIdentifier: "segueToDetail", sender: antenne)
        
        
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "segueToDetail" {
                let detailVC = segue.destination as? FSDetailViewController
                let antenne = sender as? Antenne
                detailVC?.antenne = antenne
        }
    }
    
}
//MARK: - Extension
extension FSListViewController: UITableViewDataSource, UITableViewDelegate {
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dataToDisplay.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FSCell", for: indexPath) as! CustomFSTableViewCell
            cell.updateViewCell(antenne: dataToDisplay[indexPath.row])
            
            return cell
            
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = dataToDisplay[indexPath.row]
        
        prepareToFSDetail(selectedItem)
    }

}

