//
//  QuizManager.swift
//  MovieQuiz
//
//  Created by Thiago Antonio Ramalho on 28/10/20.
//  Copyright © 2020 Tramalho. All rights reserved.
//

import Foundation

typealias Round = (quiz:Quiz, options:[QuizOption])

class QuizManager {
    
    public private(set) var quizes: [Quiz]  = []
    public private(set) var options: [QuizOption]  = []
    public private(set) var score: Int = 0
    var actualQuiz: Round? = nil

    init() {
        decode(resourceName: "quizes") { (result: [Quiz]) in
            self.quizes = result
        }
        
        decode(resourceName: "options") { (result: [QuizOption]) in
            self.options = result
        }
    }
    
    private func decode<T:Decodable>(resourceName: String, completion: @escaping (T) -> ()) {
        do {
            if let fileUrl = Bundle.main.url(forResource: resourceName, withExtension: "json") {
                let json = try Data(contentsOf: fileUrl)
                let decoder = JSONDecoder()
                let model = try decoder.decode(T.self, from: json)
                completion(model)
            }
        } catch let error {
            print(error)
        }
    }
    
    private func getRandomNumber() -> Int {
        return Int(arc4random_uniform(UInt32(quizes.count)))
    }
    
    func generate() -> Round {
        
        let correctIdx = getRandomNumber();
        
        var indexes: Set<Int> = [correctIdx]
        
        while indexes.count < 4 {
            let randomIdx = getRandomNumber()
            indexes.insert(randomIdx)
        }
        
        let options = indexes.map { (idx:Int) in
            self.options[idx]
        }
        
        actualQuiz = Round(quizes[correctIdx], options)
        
        return actualQuiz!
    }
    
    func check(name: String) {
        if let actual = actualQuiz?.quiz, actual.name == name {
            print("acertou")
            score+=1
        }
    }
}

struct Quiz: Codable {
    var name: String
    var number: Int
}

struct QuizOption: Codable {
    var name: String
}

