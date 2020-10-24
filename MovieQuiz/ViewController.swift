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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func checkAnswer(_ sender: Any) {
    }
    
    @IBAction func showSoundBar(_ sender: Any) {
    }
    
    @IBAction func changeMusicStatus(_ sender: Any) {
    }
    
    @IBAction func changeMusicTime(_ sender: Any) {
    }
}

