//
//  ViewController.swift
//  Quiz
//
//  Created by Jeffrey Johnson on 1/10/16.
//  Copyright © 2016 Jeffrey Johnson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var currentQuestionLabelXConstraint: NSLayoutConstraint!
    @IBOutlet var nextQuestionLabel: UILabel!
    @IBOutlet var nextQuestionLabelXConstraint: NSLayoutConstraint!
    @IBOutlet var answerLabel: UILabel!
    
    let questions: [String] = ["From what is cognac made?", "What is 7+7?", "What is the capital of Vermont?"]
    
    let answers: [String] = ["Grapes", "14", "Montpelier"]
    
    var currentQuestionIndex: Int = 0;
    
    @IBAction func showNextQuestion(sender: AnyObject){
        ++currentQuestionIndex
        if (currentQuestionIndex == questions.count){
            currentQuestionIndex = 0;
        }
        
        let question: String = questions[currentQuestionIndex];
        nextQuestionLabel.text = question
        answerLabel.text = "???"
        
        animateLabelTransitions()
    }
    
    @IBAction func showAnswer(sender: AnyObject){
        let answer: String = answers[currentQuestionIndex]
        answerLabel.text = answer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = questions[currentQuestionIndex]
        updateOffScreenLabel()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        nextQuestionLabel.alpha = 0
    }
    
    func updateOffScreenLabel(){
        let screenWidth = view.frame.width
        nextQuestionLabelXConstraint.constant = -screenWidth
    }
    
    func animateLabelTransitions(){
        view.layoutIfNeeded()
        
        let screenWidth = view.frame.width
        self.nextQuestionLabelXConstraint.constant = 0
        self.currentQuestionLabelXConstraint.constant += screenWidth
        
        UIView.animateWithDuration(0.5,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.75,
            options: [UIViewAnimationOptions.CurveEaseOut],
            animations: {
                self.questionLabel.alpha = 0
                self.nextQuestionLabel.alpha = 1
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                swap (&self.questionLabel, &self.nextQuestionLabel)
                swap (&self.currentQuestionLabelXConstraint, &self.nextQuestionLabelXConstraint)
                self.updateOffScreenLabel()
            }
        )
    }
}

