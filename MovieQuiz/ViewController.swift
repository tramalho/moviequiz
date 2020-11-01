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
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var background: UIImageView!
    
    private var quizManager:QuizManager!
    private var avAudioPlayer: AVAudioPlayer!
    private var playerItem: AVPlayerItem!
    private var backgroundMusicPlayer: AVPlayer!
    
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
        playBackgroundMusic()
        play()
    }
    
    private func startTimer() {
        timer.frame = background.frame
        UIView.animate(withDuration: 35.0, delay: 0.0, options: .curveLinear, animations: {
            self.timer.frame.size.width = 0
            self.timer.frame.origin.x = self.view.center.x
        }) { (success) in
            self.gameOver()
        }
    }
    
    private func gameOver() {
        performSegue(withIdentifier: "gameOverSegue", sender: nil)
        avAudioPlayer.stop()
        backgroundMusicPlayer.pause()
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
    
    private func playBackgroundMusic() {
        soundBar.isHidden = false
        playButton.setImage(UIImage(named: "pause"), for: .normal)
        guard let url = Bundle.main.url(forResource: "countdown-30", withExtension: "mp3") else { return }
        playerItem = AVPlayerItem(url: url)
        backgroundMusicPlayer = AVPlayer(playerItem: playerItem)
        backgroundMusicPlayer.volume = 0.1
        backgroundMusicPlayer.play()
        backgroundMusicPlayer.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: nil) { (time) in
            let percent = time.seconds / self.playerItem.duration.seconds
            self.slider.setValue(Float(percent), animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GameOverViewController {
            vc.totalScore = quizManager.score
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
        soundBar.isHidden = !soundBar.isHidden
    }
    
    @IBAction func changeMusicStatus(_ sender: UIButton) {
        
        var imageName = ""
        
        if backgroundMusicPlayer.timeControlStatus == .paused {
            backgroundMusicPlayer.play()
            imageName = "pause"
        } else {
            backgroundMusicPlayer.pause()
            imageName = "play"
        }
        
        playButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    @IBAction func changeMusicTime(_ sender: UISlider) {
        backgroundMusicPlayer.seek(to: CMTime(seconds: Double(sender.value) * playerItem.duration.seconds, preferredTimescale: 1))
        
        if backgroundMusicPlayer.timeControlStatus == .paused {
            backgroundMusicPlayer.play()
        }
    }
}

extension ViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        ivQuiz.image = UIImage(named: "movieSoundPause")
    }
}

