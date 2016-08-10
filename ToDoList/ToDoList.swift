//
//  ToDoList.swift
//  ToDoList
//
//  Created by Haydee Rodriguez on 09/08/16.
//  Copyright © 2016 lizRodriguez. All rights reserved.
//

import UIKit

class ToDoList: NSObject {
    var items: [String] = []
    func addItem(item: String){
        items.append(item)
    }
}

extension ToDoList: UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell",forIndexPath: indexPath)
        let item = items[indexPath.row]
        
        cell.textLabel!.text = item //Lo ponemos con el signo de admiracion por que es opcional
        return cell
    }
}

