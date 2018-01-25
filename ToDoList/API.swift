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
        if let username = UserDefaults.standard.object(forKey: "username") as? String {
            return username
        }else{
            let newUsername = self.generateUserName()
            UserDefaults.standard.set(newUsername, forKey: "username")
            return newUsername
        }
    }
    
    class func generateUserName()->String {
        let uuid = NSUUID().uuidString
        return (uuid as NSString).substring(to: 5)
    }
    
    
    class func save(item: ToDoItem, todolist: ToDoList, completionBlock : (_ response : String?, _ error : NSError?) -> Void) {
            //Recuperamos la sesion que ya existe en cualquier aplicacion
        let session = URLSession.shared
            //Obtenemos la url del servicio web
            let url = NSURL(string: "http://api.geonames.org/citiesJSON")
            //Hacemos la peticion del servicio web
        let request = NSMutableURLRequest(url: url! as URL)
            //Especificamos que tipo de metodo http es el que vamos a usar
        request.httpMethod = "POST"
            
            //diccionario es un diccionario tipo json
            //Todo dependiendo de la documentacion de la API
            //usuario
        var dictionary: Dictionary<String, AnyObject> = ["message": item.todo! as AnyObject,
                                                         "user": API.uniqueUsername() as AnyObject]
            //fecha
            if let date = item.dueDate{
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy HH:mm"
                dictionary["dueDate"] = formatter.string(from: date as Date) as AnyObject
            }
            //identificador
            if let identifier = item.id {
                dictionary["id"] = NSNumber(value: identifier)
            }
            //Para hacer el JSON
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
        request.httpBody = data
            
        let task = session.dataTask(with: request as URLRequest) {
                (data, response, error) -> Void in
                if error != nil {
                    print("Lo siento paso un error: \(String(describing: error))")
                }else{
                    //Si no hubo erro tenemos que hacer la desserializacion y convertilo a un json
                    if let d = data {
                        //Aqui se deserializa
                        let result = try! JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
                        print("response: \(String(describing: result))")
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
