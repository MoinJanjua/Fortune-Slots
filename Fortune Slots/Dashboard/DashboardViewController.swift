//
//  DashboardViewController.swift
//  Fortune Slots
//
//  Created by Moin Janjua on 28/01/2025.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var bannerImg:UIImageView!
    @IBOutlet weak var btn1:UIButton!
    @IBOutlet weak var btn2:UIButton!
    @IBOutlet weak var btn3:UIButton!
    @IBOutlet weak var btn4:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        roundCorner(button: btn1)
        roundCorner(button: btn2)
        roundCorner(button: btn3)
        roundCorner(button: btn4)
        // Do any additional setup after loading the view.
        let jeremyGif = UIImage.gifImageWithName("vd")
        bannerImg.image = jeremyGif
    }
    

    @IBAction func startbtnPressed(_ sender:UIButton)
    {
         let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
         let newViewController = storyBoard.instantiateViewController(withIdentifier: "SpinSlotViewController") as! SpinSlotViewController
         newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
         newViewController.modalTransitionStyle = .crossDissolve
         self.present(newViewController, animated: true, completion: nil)
    }
 
    
    @IBAction func leaderboardbtnPressed(_ sender:UIButton)
    {
         let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
         let newViewController = storyBoard.instantiateViewController(withIdentifier: "LeaderBoardViewController") as! LeaderBoardViewController
         newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
         newViewController.modalTransitionStyle = .crossDissolve
         self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func historybtnPressed(_ sender:UIButton)
    {
         let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
         let newViewController = storyBoard.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
         newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
         newViewController.modalTransitionStyle = .crossDissolve
         self.present(newViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func settingsbtnPressed(_ sender:UIButton)
    {
         let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
         let newViewController = storyBoard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
         newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
         newViewController.modalTransitionStyle = .crossDissolve
         self.present(newViewController, animated: true, completion: nil)
    }
    
}
