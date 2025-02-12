//
//  LeaderBoardViewController.swift
//  Fortune Slots
//
//  Created by Moin Janjua on 29/01/2025.
//

import UIKit

class LeaderBoardViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var namelb: UILabel!
    @IBOutlet weak var scorelab: UILabel!
    @IBOutlet weak var nodatalab: UILabel!
    @IBOutlet weak var tv: UITableView!
    
    
    private var scores: [(name: String, score: Int, date: String)] = []
    private var sorted_Scores: [(name: String, score: Int, date: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tv.dataSource = self
        tv.delegate = self
        nodatalab.isHidden = true
        loadScores()
        sortScoresAndUpdateUI()
        // Do any additional setup after loading the view.
    }
    
    private func loadScores() {
        if let savedScores = UserDefaults.standard.array(forKey: "SlotGameScores") as? [[String: Any]] {
            scores = savedScores.compactMap {
                guard let name = $0["name"] as? String,
                      let score = $0["score"] as? Int,
                      let date = $0["date"] as? String else { return nil }
                return (name: name, score: score, date: date)
            }
        }
        
        if scores.isEmpty
        {
            nodatalab.isHidden = false
        }
    }

    private func sortScoresAndUpdateUI() {
        // Sort scores by highest score
        sorted_Scores = scores.sorted { $0.score > $1.score }
        
        // Update highest score and username labels
        if let topScore = sorted_Scores.first {
            namelb.text = "Top Player: \(topScore.name)"
            scorelab.text = "\(topScore.score)"
        }
        
        // Reload table view
        tv.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sorted_Scores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? leaderboardTableViewCell else {
            return UITableViewCell()
        }
        
        let score = sorted_Scores[indexPath.row]
        let rank = indexPath.row + 1
        
        // Configure cell
        cell.usernameLb.text = score.name
        cell.scorelb.text = "Scores :\(score.score)"
        cell.rankLb.text = "\(rank)"
        
        // Update rank label color
        switch rank {
        case 1:
            cell.rankLb.textColor = .green
            cell.trophyImg.image = UIImage(named: "trophy")
        case 2:
            cell.rankLb.textColor = .yellow
            cell.trophyImg.image = UIImage(named: "2")
        case 3:
            cell.rankLb.textColor = .red
            cell.trophyImg.image = UIImage(named: "3")
        default:
            cell.rankLb.textColor = .white
            cell.trophyImg.image = UIImage(named: "4")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104
    }
    
    @IBAction func backbuttonPressed(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }

   
}


class leaderboardTableViewCell: UITableViewCell {

    @IBOutlet weak var rankLb:UILabel!
    @IBOutlet weak var usernameLb:UILabel!
    @IBOutlet weak var scorelb:UILabel!
    @IBOutlet weak var trophyImg:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


