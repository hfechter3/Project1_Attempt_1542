//
//  ViewController.swift
//  GuessTheNumber
//
//  Created by Peter Fechter on 1/20/20.
//  Copyright © 2020 Peter Fechter. All rights reserved.
//
import UIKit
import FirebaseDatabase

class ViewController: UIViewController {
    var ref: DatabaseReference!
// Initialize Game Variables
    let lowerBound = 1
    let upperBound = 100
    var numberToGuess: Int!
    var numberOfGuesses = 0
    var key: String?
    
    @IBOutlet weak var guessLabel: UILabel!
    @IBOutlet weak var guessTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var JakeMessage1: UILabel!
    @IBOutlet weak var JakeMessage2: UILabel!
    
    // Override load request for our app
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference().child("users")
        generateRandomNumber()
    }
    
    func generateRandomNumber(){
        numberToGuess = Int(arc4random_uniform(100) + 1)
    }
    
    func addUser() {
        let user = ["id": key!,
                    "correctNumber": guessTextField.text!,
                    "guesses": String(numberOfGuesses)]
        ref.child(key!).setValue(user)
    }
    
    func getKey(){
        key = ref.childByAutoId().key
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        if let guess = guessTextField.text {
            if let guessInt = Int(guess) {
                numberOfGuesses = numberOfGuesses + 1
                validateGuess(guessInt)
            }
        }
    }
    
    func validateGuess(_ guess: Int) {
        if guess < lowerBound || guess > upperBound {
            showBoundsAlert()
        } else if guess < numberToGuess {
            guessLabel.text = "Higher! ⬆️"
        } else if guess > numberToGuess {
            guessLabel.text = "Lower! ⬇️"
        } else {
            // You win yay!
            showWinAlert()
            guessLabel.text = "Guess the Number" // reset the label before restart game
            numberOfGuesses = 0
            generateRandomNumber()
        }
        guessTextField.text = "" // reset textField after guess so you don't have to delete previous guess
    }
    
    func showBoundsAlert() {
        let alert = UIAlertController(title: "Hey!", message: "Your guess should be between 1 and 100!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Got it", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showWinAlert() {
        let alert = UIAlertController(title: "Congrats! 🎉", message: "You won with a total of \(numberOfGuesses) guesses", preferredStyle: .alert)
        let action = UIAlertAction(title: "Play again", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
