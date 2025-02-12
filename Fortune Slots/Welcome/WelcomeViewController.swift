//
//  WelcomeViewController.swift
//  Fortune Slots
//
//  Created by Moin Janjua on 28/01/2025.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var startbtn:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        roundCorner(button: startbtn)
       
        let balance = UserDefaults.standard.integer(forKey: "Coin_Balance")
           
           if balance <= 0
           {
               UserDefaults.standard.set(100, forKey: "Coin_Balance")
               UserDefaults.standard.set(0, forKey: "Bet_Amount")
           }
        // Do any additional setup after loading the view.
    }

    
    @IBAction func startbtnPressed(_ sender:UIButton)
    {
         let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
         let newViewController = storyBoard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
         newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
         newViewController.modalTransitionStyle = .crossDissolve
         self.present(newViewController, animated: true, completion: nil)
    }
    
}
