//
//  WelcomeViewController.swift
//  RemindMeApp
//
//  Created by Tais Rocha Nogueira on 09/02/24.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func startButtonPressed(_ sender: UIButton) {
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        let controller = HomeFactory.createViewController()
        let navigationController = UINavigationController(rootViewController: controller)
        
        window.rootViewController? = navigationController
        window.makeKeyAndVisible()
        UserDefaults.standard.hasOnboarded = true
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
        
    }
    
   
}
