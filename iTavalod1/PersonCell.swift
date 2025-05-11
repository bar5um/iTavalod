//
//  PersonCell.swift
//  Tavalod
//
//  Created by Amir on 2/12/18.
//  Copyright © 2018 Amir. All rights reserved.
//

import UIKit

class PersonCell: UITableViewCell {
    
    @IBOutlet weak var personImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var remainingLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configureCell(_ person: Person) {
        nameLbl.text = person.firstName + " " + person.lastName
        dateLbl.text = person.dateOfBirthInPersianInString
        remainingLbl.text = "\(person.remainingDays)"
        personImg.image = DataService.instance.imageForPath(person.imagePath)
        
        personImg.layer.cornerRadius = personImg.frame.height / 2
        personImg.clipsToBounds = true
    }
}

