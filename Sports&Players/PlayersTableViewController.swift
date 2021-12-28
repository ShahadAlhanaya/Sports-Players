//
//  PlayersTableViewController.swift
//  Sports&Players
//
//  Created by Shahad Nasser on 28/12/2021.
//

import UIKit
import CoreData

class PlayersTableViewController: UITableViewController {

    var sport: Sport!
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var players = [Player]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = sport.name
        fetchPlayers()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell")! as! PlayerTableViewCell
        let playerItem = players[indexPath.row]
        cell.nameLabel?.text = playerItem.name
        cell.ageLabel?.text = "\(playerItem.age)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let alert = UIAlertController(title: "Edit",
                                    message: "Edit player",
                                    preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = self.players[indexPath.row].name
            textField.placeholder = "Player Name"
        }
        alert.addTextField { textField in
            textField.text = "\(self.players[indexPath.row].age)"
            textField.placeholder = "Player Age"
            textField.keyboardType = UIKeyboardType.numberPad
        }
            
        let saveAction = UIAlertAction(title: "Update", style: .default)
        {_ in
            let name = alert.textFields![0].text ?? ""
            let age = alert.textFields![1].text ?? ""
            if name.trimmingCharacters(in: .whitespaces) != "" &&
                age.trimmingCharacters(in: .whitespaces) != "" {
                if age.isNumber {
                    self.players[indexPath.row].name = name
                    self.players[indexPath.row].age = Int16(age) ?? 0
                    self.savePlayer()
                    self.fetchPlayers()
                }
            }
        }
               
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        managedObjectContext.delete(players[indexPath.row])
        savePlayer()
        fetchPlayers()
    }
    
    @IBAction func addPlayer(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add",
                                    message: "Add new player",
                                    preferredStyle: .alert)
        alert.addTextField{ textField in
            textField.placeholder = "Player Name"
        }
        alert.addTextField{ textField in
            textField.placeholder = "Player Age"
            textField.keyboardType = UIKeyboardType.numberPad
        }

        let saveAction = UIAlertAction(title: "Save", style: .default)
        {
            _ in
            let name = alert.textFields![0].text ?? ""
            let age = alert.textFields![1].text ?? ""
            if name.trimmingCharacters(in: .whitespaces) != "" &&
                age.trimmingCharacters(in: .whitespaces) != "" {
                if age.isNumber {
                    let newPlayer = Player(context: self.managedObjectContext)
                    newPlayer.name = name
                    newPlayer.age = Int16(age) ?? 0
                    self.sport.addToPlayers(newPlayer)
                    self.savePlayer()
                    self.fetchPlayers()
                }
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    func fetchPlayers(){
        let playersRequest: NSFetchRequest<Player> = Player.fetchRequest()
        let requestPredicate = NSPredicate(format: "sport == %@", sport)
        playersRequest.predicate = requestPredicate
        do {
            players = try managedObjectContext.fetch(playersRequest)
        }catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func savePlayer() {
        do {
            try managedObjectContext.save()
            print("Successfully saved")
        } catch {
            print("Error when saving: \(error)")
        }
        fetchPlayers()
    }
}

extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
