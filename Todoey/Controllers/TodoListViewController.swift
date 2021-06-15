//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()

    var todoItems: Results<Item>? //initialising the array's found in the Item 'entity' (class) located in the CoreData DataModel
//    var catColour: Results<Category>?
    
    var selectedCategory : Category? {
        didSet {
            //Everything in the braces will happen, but only once selectedCategory has been given a value
            //selectedCategory is set a value in the CategoryViewController as part of the prepareForSegue
            //It basically makes load items run, but only if selectedCategory has a value, and does this so LoadItems knows which category of data it needs to pull from.
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.separatorStyle = .none

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
               
        if let colourHex = selectedCategory?.hex {
            
            title = selectedCategory!.name
            
            guard let navBar = navigationController?.navigationBar else {fatalError("NavCon  does not exist")}
            
            if let navBarColour = UIColor(hexString: colourHex) {
                
                navBar.backgroundColor = navBarColour
                navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
//                navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
                
                searchBar.barTintColor = navBarColour
            }
        }
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            //The row value within the todoItems, based on the row of the cell the user has selected
            cell.textLabel?.text = item.title //set value of the cell to the data in the item.title column
            
            let catColour = selectedCategory!.hex
            
            if let colour = UIColor(hexString: catColour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
                
            }
            cell.accessoryType = item.Done == true ? .checkmark : .none //adds a checkmark based on data boolean
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
        
        //        Below is the 'Swift Ternary Operator' - basically removes the requirement to write an IF statement.
        //        value = condition ? valueIfTrue : valueIfFalse
        
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write  {
                    item.Done = !item.Done //swaps the boolean status if the box is check, then reloads the data which will re-apply the checkmark if bool is true
                }
            } catch {
                print("error saving done status. \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true) //deselects the row after check changes
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //popup to show when the add button is pressed, and have a text field
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)  //create pop up alert
        var tempText = UITextField()
                
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //what will happen once the user clicks the Add item button
            
  
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item() //Loading up the Context(?)
                        newItem.title = tempText.text! //Adding/updating items in the Array, within the context
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem) //adds the parent category to the items list
                    }
                } catch {
                    print("Error saving context \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
      
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item." //The test within the amendable field in the alert
            tempText = alertTextField
        }
        
        alert.addAction(action) //Runs the above 'action' property through the addAction method
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK: - Model Manipulation Methods
    
    
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()

    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let items = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(items)
                }
            } catch {
                print("Error deleting item, \(error)")
            }
            
        }
    }
    

    
}

//MARK: - UISearch Bar Methods

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }



    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //this runs every single time the search bar is changed (every letter typed, or when the field is blankerd out.

        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder() //tell the search bar that is should no longer be the thing that's selected, and the keyboard should hide.
            }

        }
    }

}
