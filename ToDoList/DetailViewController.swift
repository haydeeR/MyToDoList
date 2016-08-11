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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tareaLabel.text = item
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dateSelected(sender: UIDatePicker) {
        self.fechaLabel.text = formatDate(sender.date)
    }
    
    func formatDate(date: NSDate)->String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter.stringFromDate(date)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
