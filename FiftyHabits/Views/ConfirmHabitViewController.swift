//
//  ConfirmHabitViewController.swift
//  FiftyHabits
//
//  Created by Khalid Kamil on 9/12/20.
//

import UIKit

class ConfirmHabitViewController: UIViewController, UITextFieldDelegate {
    
    var habitImage: Habit.Images!
    
    @IBOutlet weak var habitImageView: UIImageView!
    @IBOutlet weak var habitNameInputField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateUI()
        
        self.habitNameInputField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func updateUI() {
        title = "New Habit"
        habitImageView.image = habitImage.image
    }
    
    func textFieldShouldReturn(_ habitNameInputField: UITextField) -> Bool {
        habitNameInputField.resignFirstResponder()
        return true
    }


    @IBAction func createHabitButtonPressed() {
        // TODO: Add validation function to provent useres from submitting empty fields as habits
        var persistenceLayer = PersistenceLayer()
        guard let habitText = habitNameInputField.text else { return }
        persistenceLayer.createNewHabit(name: habitText, image: habitImage)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

}
