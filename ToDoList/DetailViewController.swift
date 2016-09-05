//
//  DetailViewController.swift
//  ToDoList
//
//  Created by Haydee Rodriguez on 10/08/16.
//  Copyright © 2016 lizRodriguez. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var item: ToDoItem?
    var todoList: ToDoList?
    @IBOutlet weak var tareaLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showItem()
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.numberOfTouchesRequired = 1
        tapGestureRecognizer.addTarget(self, action: "toggleDatePicker")
        self.fechaLabel.addGestureRecognizer(tapGestureRecognizer)
        self.fechaLabel.userInteractionEnabled = true
    }

    func showItem(){
        self.tareaLabel.text = item?.todo
        if let date = item?.dueDate{
            let formatter = NSDateFormatter()
            formatter.dateFormat = "dd/MM/yyyy HH:mm"
            self.fechaLabel.text = formatter.stringFromDate(date)
        }
        if let img = item?.image{
            self.imageView.image = img
        }
    }
    
    func toggleDatePicker(){
        if self.datePicker.hidden{
            self.fadeInDatePicker()
        }else{
            self.fadeOutDatePicker()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addNotification(sender: UIBarButtonItem) {
        if let dateString = self.fechaLabel.text{
            if let parseString = parseDate(dateString){
                self.item?.dueDate = parseString
                self.todoList?.saveItems()
                scheduleNotification(self.item!.todo!, date: parseString)
                API.save(self.item! , todolist:self.todoList!){ (response, error) in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if error != nil{
                            self.showError()
                        }else{
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                    })
                }
            }
        }
    }
    //No se como mostrar el error en un clousure
    func showError(){
        let alert = UIAlertController(title: "Ups", message: "No pudimos guardar tus cambios 😒, revisa tu conexion a internet", preferredStyle: .Alert)
        let accion = UIAlertAction(title: "OK", style: .Default){
            _ in
            self.navigationController?.popViewControllerAnimated(true)
        }
        alert.addAction(accion)
        self.presentViewController(alert,animated: true,completion: nil)
    }
    
    func scheduleNotification(message: String, date: NSDate){
        let localNotification = UILocalNotification()
        localNotification.fireDate = date
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.alertBody = message
        localNotification.alertTitle = "Recuerda esta tarea"
        localNotification.applicationIconBadgeNumber = 1;
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    @IBAction func addImage(sender: UIBarButtonItem) {
        let imagePickerController = UIImagePickerController()
        //imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera si el simulador
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePickerController.delegate = self
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func dateSelected(sender: UIDatePicker) {
        self.fechaLabel.text = formatDate(sender.date)
        self.datePicker.hidden = true
        self.imageView.hidden = false
    }
    
    func formatDate(date: NSDate)->String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter.stringFromDate(date)
    }
    
    func parseDate(string: String)->NSDate?{
        let parse = NSDateFormatter()
        parse.dateFormat = "dd/MM/yyyy HH:mm"
        return parse.dateFromString(string)
    }
    
    //MARK: Animation
    func fadeInDatePicker(){
        self.datePicker.alpha = 0
        self.datePicker.hidden = false
        UIView.animateWithDuration(1) { () -> Void in
            self.datePicker.alpha = 1
            self.imageView.alpha = 0
        }
    }
    
    func fadeOutDatePicker(){
        self.datePicker.alpha = 1
        self.datePicker.hidden = false
        UIView.animateWithDuration(1, animations: { () -> Void in
            self.datePicker.alpha = 0
            self.imageView.alpha = 1
            }) { (completed) -> Void in
                if completed {
                    self.datePicker.hidden = true
                }
        }
    }
    
    //MARK: ImagePickerControllerMethons
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.item?.image = image
            self.todoList?.saveItems()  //Serializando item por item
            self.imageView.image = image
        }
        self.dismissViewControllerAnimated(true,completion: nil)
    }


}
