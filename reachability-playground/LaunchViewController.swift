//
//  ViewController.swift
//  reachability-playground
//
//  Created by Neo Ighodaro on 25/10/2017.
//  Copyright © 2017 CreativityKills Co. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    let network: NetworkManager = NetworkManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.isUnreachable { _ in
            self.showOfflinePage()
        }
        
        NetworkManager.isReachable { _ in
            self.showMainPage()
        }
    }
    
    private func showOfflinePage() -> Void {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "NetworkUnavailable", sender: self)
        }
    }
    
    private func showMainPage() -> Void {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "MainController", sender: self)
        }
    }
}

