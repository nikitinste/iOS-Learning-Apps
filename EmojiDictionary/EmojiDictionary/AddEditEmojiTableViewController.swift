//
//  AddEditEmojiTableViewController.swift
//  EmojiDictionary
//
//  Created by Степан Никитин on 04.03.2021.
//

import UIKit

class AddEditEmojiTableViewController: UITableViewController {
    
    @IBOutlet weak var saveButton:              UIBarButtonItem!
    @IBOutlet weak var symbolTextField:         UITextField!
    @IBOutlet weak var nameTextField:           UITextField!
    @IBOutlet weak var descriptionTextField:    UITextField!
    @IBOutlet weak var usageTextField:          UITextField!
    
    
    var emoji: Emoji?
    
    init?(coder: NSCoder, emoji: Emoji?) {
        self.emoji = emoji
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    
    // MARK - Actions
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let emoji = emoji {
            symbolTextField.text = emoji.symbol
            nameTextField.text = emoji.name
            descriptionTextField.text = emoji.description
            usageTextField.text = emoji.usage
            title = "Edit Emoji"
        } else {
            title = "Add Emoji"
        }
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        
        updateSaveButtonState()
    }


    // MARK: - Private
    
    private func updateSaveButtonState() {
        let nameText = nameTextField.text ?? ""
        let descriptionText = descriptionTextField.text ?? ""
        let usageText = usageTextField.text ?? ""
        saveButton.isEnabled = containsSingleEmoji(symbolTextField) && !nameText.isEmpty && !descriptionText.isEmpty && !usageText.isEmpty
    }
    
    func containsSingleEmoji(_ textField: UITextField) -> Bool {
        guard let text = textField.text, text.count == 1 else {
            return false
        }
        
        let isEmoji = text.containsOnlyEmoji
        return isEmoji
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveUnwind" else { return }
        
        let symbol = symbolTextField.text!
        let name = nameTextField.text!
        let description = descriptionTextField.text!
        let usage = usageTextField.text!
        emoji = Emoji(symbol: symbol, name: name, description: description, usage: usage)
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
