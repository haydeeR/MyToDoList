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
        let fileManager = FileManager.default
        let documentDirectoryURLs = fileManager.urls(for: .documentDirectory, in: .userDomainMask) as [NSURL]
        let documentDirectoryURL = documentDirectoryURLs.first!
        print("La url de documentos es: \(documentDirectoryURL)")
        return documentDirectoryURL.appendingPathComponent("todolist.plist")! as NSURL
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
        if let itemsArray = NSKeyedUnarchiver.unarchiveObject(withFile: self.fileURL.path!){
            self.items = itemsArray as! [ToDoItem]
        }
    }
    
    func getItem(index: Int)->ToDoItem{
        return items[index]
    }
}

extension ToDoList: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
        let item = items[indexPath.row]
        
        cell.textLabel!.text = item.todo //Lo ponemos con el signo de admiracion por que es opcional
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true         //se dice que si se puede editar la celda de la tabla
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) -> () {
        items.remove(at: indexPath.row)
        saveItems()
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.middle)
        tableView.endUpdates()
    }
}

