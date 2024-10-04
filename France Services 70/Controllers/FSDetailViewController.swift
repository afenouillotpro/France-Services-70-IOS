//
//  FSDetailViewController.swift
//  FS 70
//
//  Created by antoine fenouillot on 17/09/2024.
//

import UIKit

class FSDetailViewController: UIViewController {
    
    var antenne: Antenne?
    
   /* @IBOutlet weak var search: UIButton!
    @IBAction func searchClick(_ sender: Any) {
        openWeb()
    }
    
    @IBOutlet weak var call: UIButton!
    @IBAction func callClick(_ sender: Any) {
        callNumber()
    }
    
    @IBOutlet weak var navigate: UIButton!
    @IBAction func navigateClick(_ sender: Any) {
        openNavigate()
    }
    
   
    @IBOutlet weak var tel: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var certificateur: UILabel!
    @IBOutlet weak var bioImage: UIImageView!
  */
    @IBOutlet weak var carouselBtn: UIButton!
    @IBAction func carouselClick(_ sender: Any) {
        openCarousel()
    }

    @IBOutlet weak var nameTextF: UITextField!
    @IBOutlet weak var mailTextF: UITextField!
    @IBOutlet weak var comcomWebsiteTextF: UITextField!
    @IBOutlet weak var comcomTextF: UITextField!
    @IBOutlet weak var eventTextF: UITextField!
    @IBOutlet weak var fermAnnuelTextF: UITextField!
    @IBOutlet weak var siteSocialTextF: UITextField!
    @IBOutlet weak var siteTextF: UITextField!
    @IBOutlet weak var conseillerTextF: UITextField!
    @IBOutlet weak var aidanConnectTextF: UITextField!
    @IBOutlet weak var tel2TextF: UITextField!
    @IBOutlet weak var telTextF: UITextField!
    @IBOutlet weak var adressTextF: UITextField!
    @IBOutlet weak var cityTextF: UITextField!
    @IBOutlet weak var cpTextF: UITextField!
    
    
    @IBOutlet weak var servicesTextF: UITextView!
    
    @IBOutlet weak var outilsTextF: UITextView!
    
    @IBOutlet weak var horairesTextF: UITextView!
    
    
    var horaires: [Horaire] = []
    var permanences: [Permanence] = []
    var outils: [Outil] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        let image = UIImage(named: "circle-question-regular48")
        let scaledImage = image?.resizeImage(size: CGSize(width: 20, height: 20))
        let button1 = UIBarButtonItem(image: scaledImage, style: .plain, target: self, action: #selector(self.openInfos(_:)))
        
        let attributes = [NSAttributedString.Key.baselineOffset: NSNumber(value: 5)]
        button1.setTitleTextAttributes(attributes, for: .normal)
        self.navigationItem.rightBarButtonItem  = button1
        
        setDetail()
        
    }
    
    //MARK: - NOTIFICATION LOCATION
    @objc func openInfos(_ sender: Any) {

        performSegue(withIdentifier: "segueToCarousel", sender: nil)
        

    }
    // MARK: - Display
    
    private func setDetail(){
        
        guard let antenne = antenne else {
            return
        }
        
        /*if let naf = establishment.activity {
            bioImage.image = BioHelpers.shared.getPictoFromNafCode(codeNaf: naf)?.resizeImage(size: CGSize(width: 96, height: 96))
        }*/
        
        //self.navigationController?.navigationBar.backItem?.title = "Retour"
        //self.title = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
        
        if let nameTxt = antenne.nom.nilIfEmpty{
            nameTextF.text = nameTxt.capitalized
        } else {
            nameTextF.isHidden = true
        }
        
        if let address = antenne.adresse.nilIfEmpty{
            adressTextF.text = address.capitalized
        } else {
            adressTextF.isHidden = true
        }
        
        if let cp = antenne.cp.nilIfEmpty{
            cpTextF.text = cp
        } else {
            cpTextF.isHidden = true
        }
        
        if let city = antenne.ville.nilIfEmpty{
            cityTextF.text = city.capitalized
        } else {
            cityTextF.isHidden = true
        }
        
        if let tel = antenne.tel.nilIfEmpty{
            telTextF.text = tel
        } else {
            telTextF.isHidden = true
        }
        
        if let tel2 = antenne.tel2.nilIfEmpty{
            tel2TextF.text = tel2
        } else {
            tel2TextF.isHidden = true
        }
        
        if let website = antenne.site.nilIfEmpty{
            siteTextF.text = website
        } else {
            siteTextF.isHidden = true
        }
        
        if let socialWebsite = antenne.site_social.nilIfEmpty{
            siteSocialTextF.text = socialWebsite
        } else {
            siteSocialTextF.isHidden = true
        }
        
        if let comcomWebsite = antenne.c_web.nilIfEmpty{
            comcomWebsiteTextF.text = comcomWebsite
        } else {
            comcomWebsiteTextF.isHidden = true
        }
        
        if let comcomName = antenne.c_name.nilIfEmpty{
            comcomTextF.text = comcomName.capitalized
        } else {
            comcomTextF.isHidden = true
        }
        
        if let event = antenne.event.nilIfEmpty{
            eventTextF.text = event.capitalized
        } else {
            eventTextF.isHidden = true
        }
        
        if let mail = antenne.email.nilIfEmpty{
            mailTextF.text = mail.capitalized
        } else {
            mailTextF.isHidden = true
        }
        
        if let annuelCLose = antenne.ferm_annuelle.nilIfEmpty{
            fermAnnuelTextF.text = annuelCLose.capitalized
        } else {
            fermAnnuelTextF.isHidden = true
        }
        
        horaires = antenne.horaires?.allObjects as! [Horaire]
        permanences = antenne.permanences?.allObjects as! [Permanence]
        outils = antenne.outils?.allObjects as! [Outil]
        
        if( permanences.count > 0 ){
            var text = "Services proposés : \n"
            for perm in permanences{
                text += "\n\(perm.partenaire ?? ""), le \(FSHelpers.shared.getDayFromIndew(dayIndex: perm.jourid)) \(FSHelpers.shared.getRdvText(rdv: perm.rdv))"
            }
            
            servicesTextF.text = text
        } else {
            servicesTextF.removeFromSuperview()
        }
        
        if( outils.count > 0 ){
            var text = "Outils disponibles : \n"
            for out in outils{
                text += "\n\(out.nom ?? "")"
            }
            
            outilsTextF.text = text
        } else {
            outilsTextF.removeFromSuperview()
        }
        
        if( horaires.count > 0 ){
            var text = "Horaires d'ouverture : \n"
            for hor in horaires{
                text += "\n\(FSHelpers.shared.getStringFromHoraire(horaire: hor)) "
            }
            
            horairesTextF.text = text
        } else {
            horairesTextF.removeFromSuperview()
        }
        
        /*if antenne.isConseiller{
            conseillerTextF.text = "Conseiller true"
        } else {
            conseillerTextF.text = "Conseiller false"
        }
        
        if antenne.isAidantConnect{
            aidanConnectTextF.text = "Aidant connect true"
        } else {
            aidanConnectTextF.text = "Aidant connect false"
        }
        */
        
      
    
        /*if let addressTxt = establishment.address.nilIfEmpty{
            address.text = addressTxt.capitalized
        } else {
            address.isHidden = true
        }
        
        if let typeTxt = establishment.activitylabel.nilIfEmpty{
            type.text = String("Activité (code NAF) : \(typeTxt.capitalized)")
        } else {
            type.isHidden = true
        }
        
        if let certifTxt = establishment.certificateur.nilIfEmpty{
            certificateur.text = String("Cet établissement est certifié bio par : \(certifTxt.capitalized)")
        } else {
            certificateur.isHidden = true
        }
        
        if let telTxt = establishment.tel.nilIfEmpty{
            tel.text = String("Téléphone : \(telTxt)")
        } else {
            tel.isHidden = true
            call.isHidden = true
        }*/
        
    }
    
    private func openCarousel() {
        performSegue(withIdentifier: "segueToCarousel", sender: nil)
      }
    
    //MARK: - ACTIONS
    /*
    private func callNumber() {
        let tel = "tel://\(establishment?.tel ?? "")"
        let telStr = String(tel.filter { !" \n\t\r".contains($0) })
        guard let url = URL(string: telStr),
                    UIApplication.shared.canOpenURL(url) else{
            return
            
        }
        UIApplication.shared.open(url)
      }
    
    private func openWeb(){
        
        var components = URLComponents()
            components.scheme = "https"
            components.host = "google.com"
            components.path = "/search"
            components.queryItems = [
                URLQueryItem(name: "q", value: "\(establishment?.name ?? "") \(establishment?.cp ?? "")"),
            ]
            let url = components.url
        
        guard let myUrl = url, UIApplication.shared.canOpenURL(myUrl) else{
            return
            
        }
        UIApplication.shared.open(myUrl)

    }
    
    func openNavigate(){
        
        if( (establishment?.latitude!.doubleValue)! != 0.0 && (establishment?.longitude!.doubleValue)! != 0.0 ){
            let coordinate = CLLocationCoordinate2D(latitude: (establishment?.latitude!.doubleValue)!, longitude: (establishment?.longitude!.doubleValue)!)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
            mapItem.name = establishment?.name
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        }
        
    }
    
    private func openForm(){
        
        var components = URLComponents()
            components.scheme = "http"
            components.host = "3adigit.fr"
            components.path = "/bio"
            /*components.queryItems = [
                URLQueryItem(name: "idbio", value: "\(idBio)"),
            ]*/
            let url = components.url
        
        guard let myUrl = url, UIApplication.shared.canOpenURL(myUrl) else{
            return
            
        }
        UIApplication.shared.open(myUrl)

    }
    */

}

