//
//  File.swift
//  iTavalod1
//
//  Created by Amir on 2/13/18.
//  Copyright © 2018 Amir. All rights reserved.
//

import Foundation

class Person: NSObject, NSCoding {

    private var _personId: String!
    private var _firstName: String!
    private var _lastName: String!
    private var _imagePath: String!
    private var _dateOfBirthInGrogrianInString: String!
    private var _remainingDays: Int!
    private var _dateOfBirthInPersianInString: String!
    private var _switch1: Bool!
    private var _switch2: Bool!
    var remainingDays: Int {
        get {
            return _remainingDays
        }
        set {
            _remainingDays = newValue
        }
    }
    
    var switch1: Bool {
        get {
            return _switch1
        }
        set {
            _switch1 = newValue
        }
    }
    var switch2: Bool {
        get {
            return _switch2
        }
        set {
            _switch2 = newValue
        }
    }


    var dateOfBirthInPersianInString: String {
        return _dateOfBirthInPersianInString
    }
    var personId: String {
        return _personId
    }
    var firstName: String {
        return _firstName
    }
    var lastName: String {
        return _lastName
    }
    var imagePath: String {
        return _imagePath
    }
    var dateOfBirthInString: String {
        return _dateOfBirthInGrogrianInString
    }
    
    init(personId: String,firstName: String, lastName: String,imagePath: String,dateOfBirthInGrogrianInString: String, dateOfBirthInPersianInString: String){
        self._personId = personId
        self._firstName = firstName
        self._lastName = lastName
        self._imagePath = imagePath
        self._dateOfBirthInGrogrianInString = dateOfBirthInGrogrianInString
        self._dateOfBirthInPersianInString = dateOfBirthInPersianInString

    }
    
    override init() {
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self._personId = aDecoder.decodeObject(forKey: "personID") as? String
        self._firstName = aDecoder.decodeObject(forKey: "fistName") as? String
        self._lastName = aDecoder.decodeObject(forKey: "lastName") as? String
        self._imagePath = aDecoder.decodeObject(forKey: "imagePath") as? String
        self._dateOfBirthInGrogrianInString = aDecoder.decodeObject(forKey: "dateOfBirthInGrogrianInString") as? String
        self._dateOfBirthInPersianInString = aDecoder.decodeObject(forKey: "dateOfBirthInPersianInString") as? String
        self._switch1 = aDecoder.decodeObject(forKey: "switch1") as? Bool
        self._switch2 = aDecoder.decodeObject(forKey: "switch2") as? Bool
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self._personId, forKey: "personID")
        aCoder.encode(self._firstName, forKey: "fistName")
        aCoder.encode(self._lastName, forKey: "lastName")
        aCoder.encode(self._dateOfBirthInGrogrianInString, forKey: "dateOfBirthInGrogrianInString")
        aCoder.encode(self._dateOfBirthInPersianInString, forKey: "dateOfBirthInPersianInString")
        aCoder.encode(self._imagePath, forKey: "imagePath")
        aCoder.encode(self._switch1, forKey: "switch1")
        aCoder.encode(self._switch2, forKey: "switch2")
    }
    
    
    
    
}
