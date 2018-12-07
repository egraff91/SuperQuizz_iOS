//
//  APIClient.swift
//  SuperQuizz
//
//  Created by formation4 on 06/12/2018.
//  Copyright © 2018 formation4. All rights reserved.
//

import Foundation


class APIClient {
    
    static let instance = APIClient()
    
    private let urlServer = "http://127.0.0.1:3000"
    private let urlImage = "https://vignette.wikia.nocookie.net/p__/images/0/0d/Initial_D_Fifth_Stage_-_01_-_Large_01.jpg/revision/latest?cb=20130724151955&path-prefix=protagonist"
    private let author = "Etienne"
    private init () {}
    
    
    //Recuperer toutes les questions
    @discardableResult
    func getAllQuestionsFromServer(onSuccess:@escaping ([Question])->(), onError:@escaping (Error)->())-> URLSessionTask {
        
        //préparation de la requete
        var request = URLRequest(url: URL(string: "\(urlServer)/questions")! )
        request.httpMethod = "GET"
        
        // preparation de la tache de telechargezmebnt des données
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // si j'ai de la donnée
            if let data = data {
                
                // Je la transforme en Array
                let dataArray = try! JSONSerialization.jsonObject(with: data, options: []) as! [Any]
                var questionsToreturn = [Question]()
                // pour chaque objet d'ans l'array
                for object in dataArray {
                    
                    let objectDictionary = object as! [String:Any]
                    
                    let answer1 = objectDictionary["answer_1"] as! String
                    let answer2 = objectDictionary["answer_2"] as! String
                    let answer3 = objectDictionary["answer_3"] as! String
                    let answer4 = objectDictionary["answer_4"] as! String
                    
                    let indexCorrectAnswer = objectDictionary["correct_answer"] as! Int
                    var correctAnswer = answer1
                    
                    switch indexCorrectAnswer {
                    case 2:
                        correctAnswer = answer2
                    case 3:
                        correctAnswer = answer3
                    case 4:
                        correctAnswer = answer4
                    default:
                        correctAnswer = answer1
                    }
                    
                    let q  = Question(title: objectDictionary["title"] as! String, correctAnswer: correctAnswer)
                    q.propositions.append(answer1)
                    q.propositions.append(answer2)
                    q.propositions.append(answer3)
                    q.propositions.append(answer4)
                    
                    q.id = objectDictionary["id"] as! Int
                    
                    questionsToreturn.append(q)
                }
                onSuccess(questionsToreturn)
                
            } else  {
                onError(error!)
            }
        }
        // lance la tache
        task.resume()
        
        // revoie la tache pour pouvoir l'annuler
        return task
    }
    

    func deleteQuestionFromServer(id: Int, onSuccess: @escaping (Int)->(), onError: @escaping (Error)->()) -> URLSessionTask{
        
        var request = URLRequest(url: URL(string: "\(urlServer)/questions/\(id)")! )
        request.httpMethod = "DELETE"
        
        print(request)
        
        let task = try! URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error{
                onError(error)
            }else{
                onSuccess(id)
            }
        }
        // lance la tache
        task.resume()
        
        // revoie la tache pour pouvoir l'annuler
        return task
        
        
        
    }
    
    
    func addQuestionToServer(question: Question, onSuccess: @escaping (Question)->(), onError: @escaping (Error)->()) -> URLSessionTask {
        
       
        let title = question.title
        let answer1 = question.propositions[0]
        let answer2 = question.propositions[1]
        let answer3 = question.propositions[2]
        let answer4 = question.propositions[3]
        
        var correctAnswer: Int
        
        switch question.correctAnswer {
        case answer1:
            correctAnswer = 1
        case answer2:
            correctAnswer = 2
        case answer3:
            correctAnswer = 3
        case answer4:
            correctAnswer = 4
        default:
            correctAnswer = 1
            
        }
        
        var jsonBody: Data?
        
        let questionDictionary: NSDictionary = ["title":title, "answer_1":answer1, "answer_2":answer2, "answer_3": answer3, "answer_4": answer4, "correct_answer": correctAnswer, "author_image_url": urlImage, "author": author]
        
        do {
            //this is your json data as NSData that will be your payload for your REST HTTP call.
            let JSONPayload: Data = try JSONSerialization.data(withJSONObject: questionDictionary, options: JSONSerialization.WritingOptions.sortedKeys)
            
            jsonBody = JSONPayload
            
        } catch {
            let err = error as NSError
            NSLog("\(err.localizedDescription)")
        }
        
        var request = URLRequest(url: URL(string: "\(urlServer)/questions")! )
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error{
                onError(error)
            } else {
                onSuccess(question)
            }
        }
        
        task.resume()
        
        return task
    }
    
  
    func updateQuestionFromServer(question: Question, onSuccess: @escaping (Question)->(), onError: @escaping (Error)->()) -> URLSessionTask{
        
        let title = question.title
        let answer1 = question.propositions[0]
        let answer2 = question.propositions[1]
        let answer3 = question.propositions[2]
        let answer4 = question.propositions[3]
        
        var correctAnswer: Int
        
        switch question.correctAnswer {
        case answer1:
            correctAnswer = 1
        case answer2:
            correctAnswer = 2
        case answer3:
            correctAnswer = 3
        case answer4:
            correctAnswer = 4
        default:
            correctAnswer = 1
            
        }
        
        var jsonBody: Data?
        
        let questionDictionary: NSDictionary = ["title":title, "answer_1":answer1, "answer_2":answer2, "answer_3": answer3, "answer_4": answer4, "correct_answer": correctAnswer, "author_image_url": urlImage, "author": author]
        
        do {
            //this is your json data as NSData that will be your payload for your REST HTTP call.
            let JSONPayload: Data = try JSONSerialization.data(withJSONObject: questionDictionary, options: JSONSerialization.WritingOptions.sortedKeys)
           
            jsonBody = JSONPayload
            
        } catch {
            let err = error as NSError
            NSLog("\(err.localizedDescription)")
        }
        
        print(jsonBody)
        
        var request = URLRequest(url: URL(string: "\(urlServer)/questions/\(question.id)")! )
        request.httpBody = jsonBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        
    
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error{
                onError(error)
            }else{
                onSuccess(question)
            }
        }
        // lance la tache
        task.resume()
        
        // revoie la tache pour pouvoir l'annuler
        return task
        
        
        
    }
    
}
