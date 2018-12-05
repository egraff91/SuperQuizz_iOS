//
//  QuestionsTableViewController.swift
//  SuperQuizz
//
//  Created by formation4 on 04/12/2018.
//  Copyright © 2018 formation4. All rights reserved.
//

import UIKit

class QuestionsTableViewController: UITableViewController {

    var questions = [Question]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let question1 = Question(title: "Quelle est la capitale de la France ?", correctAnswer: "Paris")
        
        let propositions: [String] = ["Madrid", "Berlin", "Paris", "Londres"]
        
        question1.propositions = propositions
        
        questions.append(question1)
        
        let question2 = Question(title: "En quelle année l'Homme a-t-il posé pour la première fois le pied sur la Lune ?", correctAnswer: "1969")
        
        let propositions2: [String] = ["1968", "1969", "1970", "1971"]
        
        question2.propositions = propositions2
        
        questions.append(question2)
        
        
        tableView.register(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionTableViewCell")
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return questions.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AnswerViewController") as? AnswerViewController else{
            return
        }
        
        vc.question = questions[indexPath.row]
       /* vc.setOnReponseAnswered { (questionAnswered, result) in
            //TODO : Mettre à jour la liste, ou faire un appel reseau, ou mettre à jour la base
            vc.dismiss(animated: true, completion: nil)
            self.tableView.reloadData()
        }*/
 
        vc.setOnReponseAnswered { (questionAnswered, result) in
            //TODO : Mettre à jour la liste, ou faire un appel reseau, ou mettre à jour la base
            self.navigationController?.popViewController(animated: true)
            self.tableView.reloadData()
        }
        
        self.show(vc, sender: self)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath) as! QuestionTableViewCell

        // TODO: Configure the cell...
        
        cell.questionTitleLabel.text = questions[indexPath.row].title
        

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCreateOrEditViewController" {
            let controller = segue.destination as! CreateOrEditQuestionViewController
            controller.delegate = self
        }
    }
    
}

extension QuestionsTableViewController : CreateOrEditQuestionDelegate {
    func userDidEditQuestion(q: Question) {
        //TODO: Maj de la question
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func userDidCreateQuestion(q: Question) {
        // TODO:  creer la  question
        questions.append(q)
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        self.tableView.reloadData()
    }
}