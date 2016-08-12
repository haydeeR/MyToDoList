//
//  DetailViewController.swift
//  ToDoList
//
//  Created by Haydee Rodriguez on 10/08/16.
//  Copyright © 2016 lizRodriguez. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var item: String?
    @IBOutlet weak var tareaLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tareaLabel.text = item
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.numberOfTouchesRequired = 1
        tapGestureRecognizer.addTarget(self, action: "toggleDatePicker")
        self.fechaLabel.addGestureRecognizer(tapGestureRecognizer)
        self.fechaLabel.userInteractionEnabled = true
    }

    func toggleDatePicker(){
        self.datePicker.hidden = !self.datePicker.hidden
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addNotification(sender: UIBarButtonItem) {
        if let dateString = self.fechaLabel.text{
            if let parseString = parseDate(dateString){
                scheduleNotification(self.item!, date: parseString)
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
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func dateSelected(sender: UIDatePicker) {
        self.fechaLabel.text = formatDate(sender.date)
        self.datePicker.hidden = true
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


}
