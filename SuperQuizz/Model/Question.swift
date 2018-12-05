//
//  Question.swift
//  SuperQuizz
//
//  Created by formation4 on 04/12/2018.
//  Copyright © 2018 formation4. All rights reserved.
//

import Foundation

class Question {
    
    public var title: String
    public var propositions: [String] = []
    public var correctAnswer: String
    public var userChoice: String = ""
    public var id: Int = 0
    
    init(title: String, correctAnswer: String){
        self.title = title
        self.correctAnswer = correctAnswer
    }
    
    func checkAnswer(answer: String) -> Bool{
        return self.correctAnswer == answer
    }
    
}
