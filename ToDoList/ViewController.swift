//
//  ViewController.swift
//  ToDoList
//
//  Created by Haydee Rodriguez on 05/08/16.
//  Copyright © 2016 lizRodriguez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    let todoList = ToDoList()
        
    @IBAction func  addButtonPressed(sender: UIButton){
        print("Agregando un elemento a la lista: \(itemTextField.text)")
        todoList.addItem(itemTextField.text!)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = todoList
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

