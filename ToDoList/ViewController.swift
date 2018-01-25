//
//  ViewController.swift
//  ToDoList
//
//  Created by Haydee Rodriguez on 05/08/16.
//  Copyright © 2016 lizRodriguez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
   //class let MAX_SIZE_TXT = 50
    static let MAX_SIZE_TXT = 50 //Las estaticas no se pueden sobreescribir
    let todoList = ToDoList()
    var selectedItem: ToDoItem?
    
    @IBAction func  addButtonPressed(sender: UIButton){
        print("Agregando un elemento a la lista: \(String(describing: itemTextField.text))")
        let todoItem = ToDoItem()
        todoItem.todo = self.itemTextField.text!
        todoList.addItem(item: todoItem)
        tableView.reloadData()
        self.itemTextField = nil
        self.itemTextField?.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = todoList
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let DetailViewController = segue.destination as? DetailViewController{
            DetailViewController.item = self.selectedItem
            DetailViewController.todoList = self.todoList
        }
    }
    
    //MARK: Metodos del table view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.itemTextField?.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedItem  =  self.todoList.getItem(index: indexPath.row)
        self.performSegue(withIdentifier: "showItem", sender: self)
        //Si se quisiera hacer de forma programatica se comenta la linea de arriba y se pone
        /*
        let detailVC = DetailViewController()
        detailVC.item = self.selectedItem
        self.navigationController?.pushViewController(detailVC, animated: true)
        */
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, ReplaceString string: String)-> Bool{
        if let newString = textField.text as NSString?{
            let updatedString = newString.replacingCharacters(in: range, with: string)
            return updatedString.count <= ViewController.MAX_SIZE_TXT
        }
        else{
            return true
        }
    }

}

