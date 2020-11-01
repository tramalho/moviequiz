//
//  ViewController.swift
//  MovieQuiz
//
//  Created by Thiago Antonio Ramalho on 23/10/20.
//  Copyright © 2020 Tramalho. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var soundBar: UIView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet var btOptions: [UIButton]!
    @IBOutlet weak var ivQuiz: UIImageView!
    @IBOutlet weak var timer: UIImageView!
    
    private var quizManager:QuizManager!
    private var avAudioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        quizManager = QuizManager()
        getNewQuiz()
        startTimer()
    }
    
    private func getNewQuiz() {
        let random = quizManager.generate()
        for (index, element) in random.options.enumerated() {
            btOptions[index].setTitle(element.name, for: .normal)
        }
        
        play()
    }
    
    private func startTimer() {
        timer.frame = view.frame
        UIView.animate(withDuration: 60.0, delay: 0.0, options: .curveLinear, animations: {
            self.timer.frame.size.width = 0
            self.timer.frame.origin.x = self.view.center.x
        }) { (success) in
            self.gameOver()
        }
    }
    
    private func gameOver() {
        performSegue(withIdentifier: "gameOverSegue", sender: nil)
        avAudioPlayer.stop()
    }
    
    private func play() {
        guard let round = quizManager.actualQuiz else { return }
        
        ivQuiz.image = UIImage(named: "movieSound")
        
        if let url = Bundle.main.url(forResource: "quote\(round.quiz.number)", withExtension: "mp3") {
            
            do {
                avAudioPlayer = try AVAudioPlayer(contentsOf: url)
                avAudioPlayer.volume = 1
                avAudioPlayer.delegate = self
                avAudioPlayer.play()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func playQuiz(_ sender: UIButton) {
        play()
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        
        if let answer = sender.title(for: .normal) {
            quizManager.check(name: answer)
            getNewQuiz()
        }
    }
    
    @IBAction func showSoundBar(_ sender: UIButton) {
        sender.isHidden = !sender.isHidden
    }
    
    @IBAction func changeMusicStatus(_ sender: Any) {
    }
    
    @IBAction func changeMusicTime(_ sender: Any) {
    }
}

extension ViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        ivQuiz.image = UIImage(named: "movieSoundPause")
    }
}

