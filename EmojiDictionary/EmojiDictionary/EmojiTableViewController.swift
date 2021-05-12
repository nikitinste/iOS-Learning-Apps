//
//  EmojiTableViewController.swift
//  EmojiDictionary
//
//  Created by Степан Никитин on 28.02.2021.
//

import UIKit

class EmojiTableViewController: UITableViewController {

    var emojis: [[Emoji]] = []
    
    var sections: [String] = ["Section 1", "Section 2", "Section 3"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emojis = Emoji.loadFromFile()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
    }

    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return emojis.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emojis[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiCell", for: indexPath) as! EmojiTableViewCell

        let emoji = emojis[indexPath.section][indexPath.row]
        
        cell.update(with: emoji)
        cell.showsReorderControl = true

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedEmoji = emojis[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        emojis[destinationIndexPath.section].insert(movedEmoji, at: destinationIndexPath.row)
        Emoji.saveToFile(emojis: emojis)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            emojis[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // MARK: - Actions
    
    @IBSegueAction func addEditEmoji(_ coder: NSCoder, sender: Any?) -> AddEditEmojiTableViewController? {
        
        if let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            let emojiToEdit = emojis[indexPath.section][indexPath.row]
            return AddEditEmojiTableViewController(coder: coder, emoji: emojiToEdit)
        } else {
            return AddEditEmojiTableViewController(coder: coder, emoji: nil)
        }
        
    }
    
    // MARK: - Segues:
    
    @IBAction func unwindToEmojiTableView(_ unwindSegue: UIStoryboardSegue) {
        guard let sourceViewController = unwindSegue.source as? AddEditEmojiTableViewController,
              let emoji = sourceViewController.emoji else { return }
        guard unwindSegue.identifier == "saveUnwind" else {
            if unwindSegue.identifier == "cancelUnwind",
               let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: false)
            }
            return
        }
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            emojis[selectedIndexPath.section][selectedIndexPath.row] = emoji
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else {
            let section = emojis.count - 1
            let newIndexPath = IndexPath(row: emojis[section].count, section: section)
            emojis[section].append(emoji)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        Emoji.saveToFile(emojis: emojis)
    }

}
