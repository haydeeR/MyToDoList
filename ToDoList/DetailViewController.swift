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
        self.imageView.hidden = self.datePicker.hidden
        self.datePicker.hidden = !self.datePicker.hidden
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
                navigationController?.popViewControllerAnimated(true)
            }
        }
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
