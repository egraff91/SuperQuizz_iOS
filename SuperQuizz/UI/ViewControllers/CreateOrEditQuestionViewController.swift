//
//  CreateOrEditQuestionViewController.swift
//  SuperQuizz
//
//  Created by formation4 on 05/12/2018.
//  Copyright © 2018 formation4. All rights reserved.
//

import UIKit

protocol CreateOrEditQuestionDelegate : AnyObject {
    func userDidEditQuestion(q : Question) -> ()
    func userDidCreateQuestion(q : Question) -> ()
}

class CreateOrEditQuestionViewController: UIViewController {

    var questionToEdit: Question?
    weak var delegate : CreateOrEditQuestionDelegate?
    
    @IBOutlet weak var questionTitleLabel: UITextField!
    
    @IBOutlet weak var answer1Label: UITextField!
    @IBOutlet weak var answer2Label: UITextField!
    @IBOutlet weak var answer3Label: UITextField!
    @IBOutlet weak var answer4Label: UITextField!
    
    @IBOutlet weak var answer1Switch: UISwitch!
    @IBOutlet weak var answer2Switch: UISwitch!
    @IBOutlet weak var answer3Switch: UISwitch!
    @IBOutlet weak var answer4Switch: UISwitch!
    
    var correctAnswerCheck = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func createOrEditQuestion () {
        if let question = questionToEdit {
            delegate?.userDidEditQuestion(q: question)
        } else {
            guard let title = questionTitleLabel.text else {
                return
            }
            let propositions = [answer1Label.text, answer2Label.text, answer3Label.text, answer4Label.text]
            
           var correctAnswer = answer1Label.text
            
            if answer2Switch.isOn {
                correctAnswer = answer2Label.text
            }else if answer3Switch.isOn {
                correctAnswer = answer3Label.text
            }else if answer4Switch.isOn {
                correctAnswer = answer4Label.text
            }
            
            
            let question = Question(title: title, correctAnswer: correctAnswer ?? "")
            
            question.propositions = propositions as! [String]
            
            
            
            delegate?.userDidCreateQuestion(q: question)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func validateButton(_ sender: UIButton) {
        if correctAnswerCheck == false {
            let alertController = UIAlertController(title: "Choix bonne réponse", message: "Veuillez sélectionner une réponse", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default ){ action in
                print("ok")
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        }else{
           createOrEditQuestion()
        }
        
    }
    
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        if sender.isOn {
            
            correctAnswerCheck = true
            answer1Switch.setOn(false, animated: true)
            answer2Switch.setOn(false, animated: true)
            answer3Switch.setOn(false, animated: true)
            answer4Switch.setOn(false, animated: true)
            
            sender.setOn(true, animated: true)
            
        }else{
            correctAnswerCheck = false
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
