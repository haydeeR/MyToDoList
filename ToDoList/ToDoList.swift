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
    
    override init() {
        super.init()
        loadItems()
    }
    
    private let fileURL: NSURL = {
        let fileManager = NSFileManager.defaultManager()
        let documentDirectoryURLs = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask) as [NSURL]
        let documentDirectoryURL = documentDirectoryURLs.first!
        print("La url de documentos es: \(documentDirectoryURL)")
        return documentDirectoryURL.URLByAppendingPathComponent("todolist.items")
    }()

    func addItem(item: String){
        items.append(item)
        saveItems()
    }
    
    func saveItems(){
        let itemsArray = items as NSArray
        if itemsArray.writeToURL(self.fileURL, atomically: true){
            print("Guardado")
        }
        else{
            print("No se pudo guardar")
        }
    }
    
    func loadItems(){
        if let itemsArray = NSArray(contentsOfURL: self.fileURL) as? [String]{
            self.items = itemsArray
        }
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

