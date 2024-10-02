//
//  InfoViewController.swift
//  FS 70
//
//  Created by antoine fenouillot on 17/09/2024.
//

import UIKit

class InfosViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setDetail()
    }
    
   /* @IBAction func clikSite(_ sender: Any) {
        openWebSite()
    }
    @IBAction func sendForm(_ sender: Any) {
        openForm()
    }*/
    
    // MARK: - Display
    
    private func setDetail(){
    }
    
    /*private func openWebSite(){
        
        var components = URLComponents()
            components.scheme = "http"
            components.host = "3adigit.fr"
            
            let url = components.url
        
        guard let myUrl = url, UIApplication.shared.canOpenURL(myUrl) else{
            return
            
        }
        UIApplication.shared.open(myUrl)

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

    }*/

}

