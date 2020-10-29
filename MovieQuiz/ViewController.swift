//
//  ViewController.swift
//  MovieQuiz
//
//  Created by Thiago Antonio Ramalho on 23/10/20.
//  Copyright © 2020 Tramalho. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var soundBar: UIView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet var btOptions: [UIButton]!
    @IBOutlet weak var ivQuiz: UIImageView!
    @IBOutlet weak var timer: UIImageView!
    
    private var quizManager:QuizManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        quizManager = QuizManager()
        getNewQuiz()
    }
    
    private func getNewQuiz() {
        let random = quizManager.generate()
        for (index, element) in random.options.enumerated() {
            btOptions[index].setTitle(element.name, for: .normal)
        }
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

