//
//  ViewController.swift
//  SuperQuizz
//
//  Created by formation4 on 04/12/2018.
//  Copyright © 2018 formation4. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController {
    
    var question: Question!
    
    private var onQuestionAnswered : ((_ question: Question,_ isCorrectAnswer : Bool)->())?
    
    @IBOutlet weak var questionTiltleLabel: UILabel!
    
    
    @IBOutlet weak var answer1Button: UIButton!
    
    @IBOutlet weak var answer2Button: UIButton!
    
    @IBOutlet weak var answer3Button: UIButton!
    
    @IBOutlet weak var answer4Button: UIButton!
    
    
    @IBOutlet weak var progressView: UIProgressView!
    
    var work: Void
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        questionTiltleLabel.text = question?.title
        
        answer1Button.setTitle(question?.propositions[0], for: .normal)
        answer2Button.setTitle(question?.propositions[1], for: .normal)
        answer3Button.setTitle(question?.propositions[2], for: .normal)
        answer4Button.setTitle(question?.propositions[3], for: .normal)
        
        
        work = DispatchQueue.global(qos: .userInitiated).async {
            for i in 1...100{
                Thread.sleep(forTimeInterval: 1)
                DispatchQueue.main.async {
                    self.progressView.setProgress(Float(i)*0.1, animated: true)
                }
            }
        }
    }
    
    func setOnReponseAnswered(closure : @escaping (_ question: Question,_ isCorrectAnswer :Bool)->()) {
        onQuestionAnswered = closure
    }
    
    func userDidChooseAnswer(isCorrectAnswer: Bool){
        //TODO : Faire animations reussites/echecs
        var result: String
        
        if isCorrectAnswer {
            result = "Bonne réponse"
        }else{
            result = "Mauvaise réponse"
        }
        let alertController = UIAlertController(title: "Résultat", message: result, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default ){ action in
            self.dismiss(animated: true, completion: nil)
            self.onQuestionAnswered?(self.question, isCorrectAnswer)
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
        
    }
    
    @IBAction func answerTapped(_ sender: UIButton) {
        guard let userAnswer = sender.titleLabel?.text else {
            return
        }
        question.userChoice = userAnswer
        
        userDidChooseAnswer(isCorrectAnswer: question.checkAnswer(answer: userAnswer))
        
    }
    
    
    
}

