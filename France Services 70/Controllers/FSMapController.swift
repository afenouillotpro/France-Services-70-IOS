//
//  FSMapController.swift
//  FS 70
//
//  Created by antoine fenouillot on 06/09/2024.
//

import UIKit
import MapKit
import CoreLocation

class FSMapController: UIViewController, MKMapViewDelegate {
    
    var dataToDisplay: [Antenne] = []
    
    var customTabBarController: FSTabBarViewController?
    
    var antennesAnnotations: [PinAnnotation] = []
    
    private let fsRepository = FSRepository()

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        customTabBarController = self.tabBarController as? FSTabBarViewController
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.receiveNewData(_:)), name: NSNotification.Name(rawValue: "updatedata"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeRange(_:)), name: NSNotification.Name(rawValue: "changerange"), object: nil)
        
        
        mapView.delegate = self
        
        //Display my position
        mapView.showsUserLocation = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       /* guard let customTabBarController = customTabBarController else {
            return
        }
        customTabBarController.updateSliderValue()*/
        
    }
    
    //MARK: - NOTIFICATION DATA
    @objc func receiveNewData(_ notification: NSNotification) {
        
        changeDataRange()

    }
    
    //MARK: - NOTIFICATION CHANGE RANGE
    @objc func changeRange(_ notification: NSNotification) {
        
        changeDataRange()

    }
    
    // MARK: - WS
    
    func changeDataRange(){
        
        guard let customTabBarController = customTabBarController else {
            dataToDisplay = []
            return
        }
        /*
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
     */
        self.clearAnnotations()
        dataToDisplay = FSManager.shared.getData()
        self.addPins()
        
    
    }
    
    private func presentAlert(text: String) {
        let alertVC = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: - PIN
    
    //Function to add Pins
    func addPins() {
        
        if(dataToDisplay.isEmpty){
            return
        }
        
        antennesAnnotations = []
        for antenne in dataToDisplay {
            
            setPinUsingMKAnnotation(antenne: antenne)
        }
        //Center map on points
        mapView.showAnnotations(antennesAnnotations, animated: true)
        
    }
    
    func clearAnnotations(){
        let allAnnotations = mapView.annotations
        mapView.removeAnnotations(allAnnotations)
    }
    
    func setPinUsingMKAnnotation(antenne: Antenne) {
        
        //TODO : change
        if( (Double(antenne.lat!)) == 0.0 && (Double(antenne.lon!)) == 0.0 ){
            return
       }
        
        //Create PIN object
        let pinAnnotation = PinAnnotation()
        pinAnnotation.setCoordinate(newCoordinate: CLLocationCoordinate2D(latitude: antenne.lat!.doubleValue, longitude: antenne.lon!.doubleValue))
        pinAnnotation.title = antenne.nom?.capitalized
        print(antenne.ville)
        print(antenne.lat)
        print(antenne.lon)
        pinAnnotation.subtitle = antenne.ville?.capitalized
        pinAnnotation.antenne = antenne
        
        mapView.addAnnotation(pinAnnotation)
        antennesAnnotations.append(pinAnnotation)
        
    }
    //MARK: - DISPLAY PUPUP ON PIN
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is PinAnnotation {
           
            let pinAnnotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            
            pinAnnotationView.isDraggable = true
            pinAnnotationView.canShowCallout = true
            pinAnnotationView.animatesWhenAdded = true
            //Disable clustering
            pinAnnotationView.displayPriority = .required
            pinAnnotationView.annotation = annotation
            pinAnnotationView.markerTintColor = UIColor(named: "AccentColor")
            if let antenneAnnotation = annotation as? PinAnnotation {
                //if let naf = antenneAnnotation.antenne?.activity {
                    pinAnnotationView.glyphImage = UIImage(named: "circle-question-regular-48")
                    
                //}
                
            }
           
            let seeButton = UIButton(type: .detailDisclosure)
            seeButton.tintColor = UIColor.gray
            pinAnnotationView.rightCalloutAccessoryView = seeButton
            
            //Clustering
            pinAnnotationView.clusteringIdentifier = "itemClustered"
                    
            
            return pinAnnotationView
            
        } else if annotation is MKClusterAnnotation {
            //Clustering
            
            let clusterAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "muyCluster")
            clusterAnnotationView.annotation = annotation
            //clusterAnnotationView.image = UIImage(named: "mapcluster")
            
            let cluster = annotation as? MKClusterAnnotation
            
            let count = cluster!.memberAnnotations.count
            
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: 36, height: 36))
            let image = renderer.image { _ in
                // Fill full circle with tricycle color
                UIColor.gray.setFill()
                UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 36, height: 36)).fill()
                
                // Fill inner circle with white color
                UIColor(named: "AccentColor")?.setFill()
                UIBezierPath(ovalIn: CGRect(x: 1, y: 1, width: 34, height: 34)).fill()
                
                // Finally draw count text vertically and horizontally centered
                let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.white,
                                   NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
                let text = "\(count)"
                let size = text.size(withAttributes: attributes)
                let rect = CGRect(x: 18 - size.width / 2, y: 18 - size.height / 2, width: size.width, height: size.height)
                text.draw(in: rect, withAttributes: attributes)
            }
            
            clusterAnnotationView.image = image
            
            return clusterAnnotationView
            
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? PinAnnotation, let antenne = annotation.antenne {
            prepareToAntenneDetail(antenne)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        
        if let clustered = view.annotation as? MKClusterAnnotation {
            mapView.showAnnotations(clustered.memberAnnotations, animated: true)
        }
    }
    
    
    // MARK: - Navigation
    
    private func prepareToAntenneDetail(_ antenne: Antenne) {
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


