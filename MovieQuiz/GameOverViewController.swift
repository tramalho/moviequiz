//
//  GameOverViewController.swift
//  MovieQuiz
//
//  Created by Thiago Antonio Ramalho on 23/10/20.
//  Copyright © 2020 Tramalho. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {

    @IBOutlet weak var score: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func playAgain(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
