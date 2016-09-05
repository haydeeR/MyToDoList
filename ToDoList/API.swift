//
//  API.swift
//  ToDoList
//
//  Created by Haydee Rodriguez on 03/09/16.
//  Copyright © 2016 lizRodriguez. All rights reserved.
//

import UIKit

class API {
    class func uniqueUsername()->String{
        if let username = NSUserDefaults.standardUserDefaults().objectForKey("username") as? String {
            return username
        }else{
            let newUsername = self.generateUserName()
            NSUserDefaults.standardUserDefaults().setObject(newUsername, forKey: "username")
            return newUsername
        }
    }
    
    class func generateUserName()->String {
       let uuid = NSUUID().UUIDString
        return (uuid as NSString).substringToIndex(5)
    }
    
    
    class func save(item: ToDoItem, todolist: ToDoList, completionBlock : (response : String?, error : NSError?) -> Void) {
            //Recuperamos la sesion que ya existe en cualquier aplicacion
            let session = NSURLSession.sharedSession()
            //Obtenemos la url del servicio web
            let url = NSURL(string: "http://api.geonames.org/citiesJSON")
            //Hacemos la peticion del servicio web
            let request = NSMutableURLRequest(URL: url!)
            //Especificamos que tipo de metodo http es el que vamos a usar
            request.HTTPMethod = "POST"
            
            //diccionario es un diccionario tipo json
            //Todo dependiendo de la documentacion de la API
            //usuario
            var dictionary: Dictionary<String, AnyObject> = ["message": item.todo!,
                "user": API.uniqueUsername()]
            //fecha
            if let date = item.dueDate{
                let formatter = NSDateFormatter()
                formatter.dateFormat = "dd/MM/yyyy HH:mm"
                dictionary["dueDate"] = formatter.stringFromDate(date)
            }
            //identificador
            if let identifier = item.id {
                dictionary["id"] = NSNumber(longLong: identifier)
            }
            //Para hacer el JSON
            let data = try! NSJSONSerialization.dataWithJSONObject(dictionary, options: NSJSONWritingOptions.PrettyPrinted)
            request.HTTPBody = data
            
            let task = session.dataTaskWithRequest(request) {
                (data, response, error) -> Void in
                if error != nil {
                    print("Lo siento paso un error: \(error)")
                }else{
                    //Si no hubo erro tenemos que hacer la desserializacion y convertilo a un json
                    if let d = data {
                        //Aqui se deserializa
                        let result = try! NSJSONSerialization.JSONObjectWithData(d, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                        print("response: \(result)")
                        //ya desserializado cargamos los datos de la clase a traves del json
                        if let id = result!["id"] as? Int64{
                            item.id = id
                            todolist.saveItems()
                        }
                    }
                }
            }
            task.resume()
    }
}
