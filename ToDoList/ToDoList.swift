//
//  ToDoList.swift
//  ToDoList
//
//  Created by Haydee Rodriguez on 09/08/16.
//  Copyright © 2016 lizRodriguez. All rights reserved.
//

import UIKit

class ToDoList: NSObject {
    //  var items: [String] = [] // Cambiamos por el tipo de clase que hicimos nosotros
    var items:[ToDoItem] = []
    
    override init() {
        super.init()
        loadItems()
    }
    
    private let fileURL: NSURL = {
        let fileManager = NSFileManager.defaultManager()
        let documentDirectoryURLs = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask) as [NSURL]
        let documentDirectoryURL = documentDirectoryURLs.first!
        print("La url de documentos es: \(documentDirectoryURL)")
        return documentDirectoryURL.URLByAppendingPathComponent("todolist.plist")
    }()

    func addItem(item: ToDoItem){
        items.append(item)
        saveItems()
    }
    
    func saveItems(){
        /* solo con NSArray.writeTo
        let itemsArray = items as NSArray
        if itemsArray.writeToURL(self.fileURL, atomically: true){
            print("Guardado")
        }
        else{
            print("No se pudo guardar")
        }
        */ //Con NSCoding
        let itemsArray = items as NSArray
        if(NSKeyedArchiver.archiveRootObject(itemsArray, toFile: self.fileURL.path!)){
            print("Guardado")
        }else{
            print("No se pudo guardar")
        }
    }
    
    func loadItems(){
        /* Solo para NSArray
        if let itemsArray = NSArray(contentsOfURL: self.fileURL) as? [String]{
            self.items = itemsArray
        }
*/          //Con NSCoding
        if let itemsArray = NSKeyedUnarchiver.unarchiveObjectWithFile(self.fileURL.path!){
            self.items = itemsArray as! [ToDoItem]
        }
    }
    
    func getItem(index: Int)->ToDoItem{
        return items[index]
    }
}

extension ToDoList: UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell",forIndexPath: indexPath)
        let item = items[indexPath.row]
        
        cell.textLabel!.text = item.todo //Lo ponemos con el signo de admiracion por que es opcional
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true         //se dice que si se puede editar la celda de la tabla
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
        items.removeAtIndex(indexPath.row)
        saveItems()
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Middle)
        tableView.endUpdates()
    }
}

