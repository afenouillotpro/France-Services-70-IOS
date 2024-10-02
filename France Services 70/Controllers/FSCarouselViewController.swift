//
//  FSCarouselViewController.swift
//  FS 70
//
//  Created by antoine fenouillot on 19/09/2024.
//

import UIKit
import CoreLocation

class FSCarouselViewController: UIViewController {

    // MARK: - Subvies
    
    private var carouselView: CarouselView?
    
    // MARK: - Properties
    
    private var carouselData = [CarouselView.CarouselData]()
    private let backgroundColors: [UIColor] = [#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.4826081395, green: 0.04436998069, blue: 0.2024421096, alpha: 1), #colorLiteral(red: 0.1728022993, green: 0.42700845, blue: 0.3964217603, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.4826081395, green: 0.04436998069, blue: 0.2024421096, alpha: 1), #colorLiteral(red: 0.1728022993, green: 0.42700845, blue: 0.3964217603, alpha: 1)]
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carouselView = CarouselView(pages: 6, delegate: self)
        carouselData.append(.init(image: UIImage(named: "car1.png"), text: ""))
        carouselData.append(.init(image: UIImage(named: "car2.png"), text: ""))
        carouselData.append(.init(image: UIImage(named: "car3.png"), text: ""))
        carouselData.append(.init(image: UIImage(named: "car4.png"), text: ""))
        carouselData.append(.init(image: UIImage(named: "car5.png"), text: ""))
        carouselData.append(.init(image: UIImage(named: "car6.png"), text: ""))
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        carouselView?.configureView(with: carouselData)
    }
}

// MARK: - Setups

private extension FSCarouselViewController {
    func setupUI() {
        view.backgroundColor = backgroundColors.first
        
       /* guard let carouselView = carouselView else {
            return
        }*/
        //let carouselView{
        guard let carouselView else {
            return
        }
            view.addSubview(carouselView)
            carouselView.translatesAutoresizingMaskIntoConstraints = false
            carouselView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
            carouselView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            carouselView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            carouselView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            //carouselView.startButton.addTarget(self, action: #selector(self.startButtonAction(_ :)), for: .touchUpInside)
       
    }
    
    /*@objc func startButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToHome", sender: nil)
    }*/
}




// MARK: - CarouselViewDelegate

extension FSCarouselViewController: CarouselViewDelegate {
    func currentPageDidChange(to page: Int) {
        UIView.animate(withDuration: 0.7) {
            self.view.backgroundColor = self.backgroundColors[page]
        }
    }
    
    func openHomeSegue() {
        performSegue(withIdentifier: "segueToHome", sender: nil)
        
    }
    
    func openLegalSegue() {
        performSegue(withIdentifier: "segueToInfo", sender: nil)
        
    }
}

