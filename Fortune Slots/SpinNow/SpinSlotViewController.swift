//
//  SpinSlotViewController.swift
//  Fortune Slots
//
//  Created by Moin Janjua on 29/01/2025.
//

import UIKit

class SpinSlotViewController: UIViewController {

    private var blurEffectView: UIVisualEffectView?
    private let initialCoinBalance = 100
    private let symbols = ["💎", "⚡️", "🔥", "💰", "🎲"]
    private var timer: Timer?
    private var coinBalance: Int {
        get {
            return UserDefaults.standard.integer(forKey: "Coin_Balance")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Coin_Balance")
        }
    }
    private var betAmount: Int {
        get {
            return UserDefaults.standard.integer(forKey: "Bet_Amount")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Bet_Amount")
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var reelsStView: UIStackView!
    @IBOutlet weak var spinBtn: UIButton!
    @IBOutlet weak var resultLb: UILabel!
    @IBOutlet weak var coinslb: UILabel!
    //@IBOutlet weak var viewcoinsLb: UILabel!
    @IBOutlet weak var betAmountTextField: UITextField!
    @IBOutlet weak var bettView: UIView!
    @IBOutlet weak var coinsImage: UIImageView!
    @IBOutlet weak var mainview: UIView!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupReelsSafely()
        updateCoinsLabel()
        roundCorner(button: spinBtn)
        betAmountTextField.text = "\(betAmount)"
        
           if betAmount <= 0 {
               addBlurEffect() // Show blur if no bet is placed
               bettView.isHidden = false
           } else {
               bettView.isHidden = true
           }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
       // viewcoinsLb.text = coinslb.text
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    private func setupReelsSafely() {
        guard reelsStView != nil else {
            print("reels StackView is nil!")
            return
        }
        for label in reelsStView.arrangedSubviews {
            if let reelLabel = label as? UILabel {
                reelLabel.text = symbols.randomElement() // Randomly assign symbols to each reel
            }
        }
    }
    
    private func addBlurEffect() {
        mainview.isHidden = true
        let blurEffect = UIBlurEffect(style: .dark) // You can use .light or .extraLight
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurView)
        view.bringSubviewToFront(bettView)
        blurEffectView = blurView
    }

    private func removeBlurEffect() {
        mainview.isHidden = false
        blurEffectView?.removeFromSuperview()
        blurEffectView = nil
    }
    
    private func updateCoinsLabel() {
        coinslb.text = "\(coinBalance)"
    }
    
    // MARK: - Actions
    
    @IBAction func addBetAmount(_ sender: UIButton) {
        guard let bet = Int(betAmountTextField.text ?? "0"), bet > 0, bet <= coinBalance else {
           // resultLabel.text = "Invalid Bet Amount!"
            showAlert(title: "Invalid Bet Amount", message: "Please ensure you enter a valid amount that does not exceed your current coin balance.")
            return
        }
        removeBlurEffect()
        bettView.isHidden = true
        betAmount = bet
    }
    
    @IBAction func didTapSpin(_ sender: UIButton) {
        
        
        guard let bet = Int(betAmountTextField.text ?? "0"), bet > 0, bet <= coinBalance else {
            
            bettView.isHidden = false
            resultLb.text = "Invalid Bet Amount!"
            return
        }
        
        coinBalance -= bet
        updateCoinsLabel()
        
        spinBtn.isEnabled = false
        resultLb.text = "Spinning..."
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateReels()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.timer?.invalidate()
            self?.timer = nil
            self?.checkResult()
            self?.spinBtn.isEnabled = true
        }
    }
    
    private func updateReels() {
        for label in reelsStView.arrangedSubviews {
            if let reelLabel = label as? UILabel {
                reelLabel.text = symbols.randomElement()
            }
        }
    }
    
    private func checkResult() {
        let middleSymbols = reelsStView.arrangedSubviews.compactMap { ($0 as? UILabel)?.text }
        
        // Check for a perfect match (all four symbols are the same)
        if Set(middleSymbols).count == 1 {
            let reward = betAmount * 10
            coinBalance += reward
            resultLb.text = "🎉 JACKPOT! You matched all four symbols and won \(reward) coins! 🎉"
        }
        // Check for three matching symbols
        else if middleSymbols[0] == middleSymbols[1] && middleSymbols[0] == middleSymbols[2] ||
                middleSymbols[1] == middleSymbols[2] && middleSymbols[1] == middleSymbols[3] {
            let partialReward = 15
            coinBalance += partialReward
            resultLb.text = "🎉 You matched three symbols and earned \(partialReward) coins!"
        }
        // Check for two matching symbols
        else if middleSymbols[0] == middleSymbols[1] || middleSymbols[1] == middleSymbols[2] ||
                middleSymbols[2] == middleSymbols[3] || middleSymbols[0] == middleSymbols[2] ||
                middleSymbols[1] == middleSymbols[3] {
            let partialReward = 5
            coinBalance += partialReward
            resultLb.text = "🎉 You matched two symbols and earned \(partialReward) coins!"
        }
        // No match
        else {
            let loss = betAmount / 2
            coinBalance -= loss
            resultLb.text = "No match. You lost \(loss) coins. Try again!"
        }
        
        // Update coins label
        updateCoinsLabel()
        
        // **Check if the user has won or lost**
        if coinBalance >= initialCoinBalance {
            resultLb.text = "🎉 Congratulations! You've won the game! 🎉"
            SuccessAlertAndRestart()
        } else if coinBalance < betAmount {
            resultLb.text = "You've lost all coins! Game Over."
            coinBalance = 0
            coinslb.text = "0"
            showAlertAndRestart()
        }
    }
    private func showAlertAndRestart()
    {
        let alert = UIAlertController(
            title: "Game Over",
            message: "You have run out of coins. Please save your score and restart the game.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Add Score", style: .default, handler: { _ in
            // Navigate back to the previous screen
            self.navigateToScoreScreen()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func SuccessAlertAndRestart()
    {
        let alert = UIAlertController(
            title: "Success!",
            message: "🎉 Congratulations! You've won the game! 🎉",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Add Score", style: .default, handler: { _ in
            // Navigate back to the previous screen
            self.navigateToScoreScreen()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func navigateToScoreScreen() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddScoresViewController") as! AddScoresViewController
        newViewController.modalPresentationStyle = .fullScreen
        newViewController.score = "\(self.coinBalance)"
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }

    
    private func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }
    
    @IBAction func backbuttonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }


}
