//
//  ToDoItem.swift
//  ToDoList
//
//  Created by Haydee Rodriguez on 15/08/16.
//  Copyright © 2016 lizRodriguez. All rights reserved.
//

import UIKit


class ToDoItem: NSObject, NSCoding {
    
    func encode(with aCoder: NSCoder) {
        //something
    }
    
    var todo: String?
    
    var dueDate: NSDate?
    
    var image: UIImage?
    
    var id: Int64?
    
    override init(){
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        if let message = aDecoder.decodeObject(forKey: "todo") as? String{
            self.todo = message
        }
        if let date = aDecoder.decodeObject(forKey: "dueDate") as? NSDate{
            self.dueDate = date
        }
        if let img = aDecoder.decodeObject(forKey: "image") as? UIImage{
            self.image = img
        }
        let identifier = aDecoder.decodeInt64(forKey: "identifier")
        if identifier != 0 {
            self.id = identifier
        }
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        if let message = self.todo{
            aCoder.encode(message, forKey: "todo")
        }
        if let date = self.dueDate{
            aCoder.encode(date,forKey: "dueDate")
        }
        if let img = self.image{
            aCoder.encode(img,forKey: "image")
        }
        if let identifier = self.id{
            aCoder.encode(identifier, forKey: "identifier")
        }
    }
}
