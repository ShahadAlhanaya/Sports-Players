//
//  ViewController.swift
//  Sports&Players
//
//  Created by Shahad Nasser on 28/12/2021.
//

import UIKit
import CoreData

class SportsViewController: UITableViewController {

    var sports = [Sport]()
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSports()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sports.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 124
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SportCell")! as! SportTableViewCell
        let sportItem = sports[indexPath.row]
        cell.sportLabel?.text = sportItem.name
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let alert = UIAlertController(title: "Edit",
                                    message: "Edit sport",
                                    preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Sport Name"
            textField.text = self.sports[indexPath.row].name
        }
            
        let saveAction = UIAlertAction(title: "Update", style: .default)
        { _ in
            let newName = alert.textFields![0].text ?? ""
            if newName.trimmingCharacters(in: .whitespaces) != ""{
                self.sports[indexPath.row].name = newName
                self.saveSport()
            }
        }
               
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sport = sports[indexPath.row]
        performSegue(withIdentifier: "ShowSportSegue", sender: sport)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        managedObjectContext.delete(sports[indexPath.row])
        saveSport()
    }
    
    func fetchSports() {
        do {
            sports = try managedObjectContext.fetch(Sport.fetchRequest())
            print("Success")
        } catch {
            print("Error: \(error)")
        }
        tableView.reloadData()
    }
    
    func saveSport() {
        do {
            try managedObjectContext.save()
            print("Successfully saved")
        } catch {
            print("Error when saving: \(error)")
        }
        fetchSports()
    }
    
    @IBAction func addSport(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add",
                                    message: "Add new sport",
                                    preferredStyle: .alert)
        alert.addTextField{ textField in
            textField.placeholder = "Sport Name"
        }
               
        let saveAction = UIAlertAction(title: "Save", style: .default)
        {
            _ in
            let textField = alert.textFields![0]
            let name = textField.text ?? ""
            if name.trimmingCharacters(in: .whitespaces) != ""{
                let newSport = Sport(context: self.managedObjectContext)
                newSport.name = textField.text!
                self.saveSport()
            }
        }
               
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSportSegue" {
            let playersTableViewController = segue.destination as! PlayersTableViewController
            playersTableViewController.sport = sender as! Sport
        }
    }

}

