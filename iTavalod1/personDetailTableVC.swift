//
//  personDetailTableVC.swift
//  iTavalod1
//
//  Created by Amir on 2/24/18.
//  Copyright © 2018 Amir. All rights reserved.
//

import UIKit

class personDetailTableVC: UITableViewController {
    
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var remainingLbl: UILabel!
    @IBOutlet weak var shamsiLbl: UILabel!
    @IBOutlet weak var miladiLbl: UILabel!
    @IBOutlet weak var ghamariLbl: UILabel!
    @IBAction func editBtnPressed(_ sender: Any) {
    performSegue(withIdentifier: "editPersonTVC", sender: personIndex)
    }
    
    var personIndex:Int!
    var person: Person!
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.tableFooterView = UIView()
        personImage.layer.cornerRadius = personImage.frame.height / 2
        person = DataService.instance.loadedPersons[personIndex]
        nameLbl.text = person.firstName + " " + person.lastName
        personImage.image = DataService.instance.imageForPath(person.imagePath)
        remainingLbl.text = "\(person.remainingDays)" + " روز تا " + "\(DataService.instance.age(person: person))" + "سالگی "
        shamsiLbl.text = person.dateOfBirthInPersianInString
        miladiLbl.text = person.dateOfBirthInString
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.tableFooterView = UIView()
//        personImage.layer.cornerRadius = personImage.frame.height / 2
//        person = DataService.instance.loadedPersons[personIndex]
//        nameLbl.text = person.firstName + " " + person.lastName
//        personImage.image = DataService.instance.imageForPath(person.imagePath)
//        remainingLbl.text = "\(person.remainingDays)" + "روز تا"
//        shamsiLbl.text = person.dateOfBirthInPersianInString
//        miladiLbl.text = person.dateOfBirthInString
//
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editPersonTVC" {
            if let navVC = segue.destination as? UINavigationController {
                if let editPersonTVC = navVC.viewControllers.first as? editPersonTVC {
                    if let personIndex = sender as? Int {
                        editPersonTVC.personIndex = personIndex
                    }
            }
            }
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
