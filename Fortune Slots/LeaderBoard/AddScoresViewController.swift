//
//  AddScoresViewController.swift
//  Fortune Slots
//
//  Created by Moin Janjua on 30/01/2025.
//

import UIKit

class AddScoresViewController: UIViewController {

    @IBOutlet weak var date:UILabel!
    @IBOutlet weak var usernametf:UITextField!
    @IBOutlet weak var scoretf:UITextField!
    @IBOutlet weak var addbtn:UIButton!
    
    var score = String()
    var scores: [(name: String, score: Int, date: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundCorner(button: addbtn)
        setUpUI()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setUpUI()
    {
        date.text = getCurrentDate()
        scoretf.text = score
    }
    

    private func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }
    
    @IBAction func SavebtnPressed(_ sender: UIButton) {
        guard let pName = usernametf.text, !pName.isEmpty,
              let scoreText = scoretf.text, !scoreText.isEmpty,
              let scoreValue = Int(scoreText) // Safely convert to Int
        else {
            showAlert(title: "Error!", message: "Please ensure all fields are completed and the score is a valid number.")
            return
        }
        
        let date = getCurrentDate()
        
        var savedScores = UserDefaults.standard.array(forKey: "SlotGameScores") as? [[String: Any]] ?? []
        
        let newRecord: [String: Any] = ["name": pName, "score": scoreValue, "date": date]
        savedScores.append(newRecord)
    
        UserDefaults.standard.set(savedScores, forKey: "SlotGameScores")
        
        UserDefaults.standard.set(100, forKey: "Coin_Balance")
        UserDefaults.standard.set(0, forKey: "Bet_Amount")
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "LeaderBoardViewController") as! LeaderBoardViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }


    @IBAction func backbuttonPressed(_ sender: UIButton) {
        UserDefaults.standard.set(100, forKey: "Coin_Balance")
        UserDefaults.standard.set(0, forKey: "Bet_Amount")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }

}
