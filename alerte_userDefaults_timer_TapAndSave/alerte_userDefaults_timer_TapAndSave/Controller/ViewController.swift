//
//  ViewController.swift
//  alerte_userDefaults_timer_TapAndSave
//
//  Created by Caroline Zaini on 08/06/2020.
//  Copyright © 2020 Caroline Zaini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bestScoreLabel: UILabel!
    @IBOutlet weak var numberTapsLabel: UILabel!
    @IBOutlet weak var timeRestLabel: UILabel!
    @IBOutlet weak var tapButton: TapButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var changeTimeButton: UIButton!
    
    var timeRemaining: Int = 5
    var timer = Timer()
    var isRunning = false
    var currentScore = 0
    var userD = UserDefaults.standard
    let ud_key = "Score"

    override func viewDidLoad() {
        super.viewDidLoad()
        /// - 80 car on a mis 40 de chaque côtés en contraintes du bouton
        tapButton.setup((view.frame.width - 80 ) / 2)
        enableButtons()
        updateScoreLabel()
        
    }
    
    // MARK: - userDefaults
    
    func setScore(int: Int) {
        userD.set(int, forKey: ud_key)
    }
    
    func getScore() -> Int {
        /// comme je veux un entier :
        return userD.integer(forKey: ud_key)
    }
    
    func updateBestScore() {
        bestScoreLabel.text = "Meilleur score : \(getScore())"
    }
    
    func updateScoreLabel() {
        numberTapsLabel.text = "Nombre de Taps : \(currentScore)"
    }
    
    // MARK: - timer
    
    func updateTimeLabel() {
        timeRestLabel.text = "Temps restant : \(timeRemaining) secondes"
        /// playButton actif si le TimeRemaining > 0
        playButton.isEnabled = timeRemaining > 0
    }

    func setTime(int: Int) {
        timeRemaining = int
        updateTimeLabel()
    }
    
    func enableButtons() {
        tapButton.isEnabled = isRunning
        changeTimeButton.isEnabled = !isRunning
       
    }
    
    func stopTimer() {
        timer.invalidate()
        isRunning = !isRunning
        enableButtons()
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
 
        /// checkBest Score :
        let best = getScore()
        let myScore = currentScore
        
        /// Montrer le score :
        let title = (myScore > best) ? "Félicitation" : "Bien joué"
        let msg = "Votre score : \(myScore). Le meilleur score était de \(best)"
        let controller = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(controller, animated: true, completion: nil)

        /// enregistrer le meilleur score :
        if myScore > best {
            setScore(int: myScore)
        }
        
        currentScore = 0
        updateScoreLabel()
        updateBestScore()
    }

    @IBAction func tapPressed(_ sender: TapButton) {
        currentScore += 1
        updateScoreLabel()
    }
    
    @IBAction func playPressed(_ sender: UIButton) {
        
        if isRunning {
            stopTimer()
        } else {
            isRunning = !isRunning
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            enableButtons()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (time) in
                if self.timeRemaining > 0 {
                     self.timeRemaining -= 1
                    /// mettre à jour les labels
                    self.updateTimeLabel()
                } else {
                    self.stopTimer()
                 
                }
               
            })
        }
    }
    
    
    @IBAction func changePressed(_ sender: UIButton) {
        
        let controller = UIAlertController(title: "Changer de durée", message: "Quelle est la durée que vous voulez", preferredStyle: .actionSheet)
        
        let five = UIAlertAction(title: "5 secondes", style: .default) { (action) in
            self.setTime(int: 5)
        }
        
        let ten = UIAlertAction(title: "10 secondes", style: .default) { (action) in
        self.setTime(int: 10)
        }
        
        let fifteen = UIAlertAction(title: "15 secondes", style: .default) { (action) in
        self.setTime(int: 15)
        }
        
        let cancel = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
            
        controller.addAction(five)
        controller.addAction(ten)
        controller.addAction(fifteen)
        controller.addAction(cancel)
        
         // vérification pour l'iPad :
               /// si je suis sur un iPad. A quel endroit il va être montré, ici dans ma view principale
        if UIDevice.current.userInterfaceIdiom == .pad {
            controller.popoverPresentationController?.sourceView = self.view
            controller.popoverPresentationController?.sourceRect = sender.frame
        }
        present(controller, animated: true, completion: nil)
    }
    
}

