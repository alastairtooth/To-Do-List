//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Alastair Tooth on 3/9/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm() //Initialises a Realm instance
    
    var categoryArray: Results<Category>? //initialising the array's found in the Item 'entity' (class) located in the CoreData DataModel

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(UIColor.randomFlat().hexValue())

        tableView.rowHeight = 70.0 //change the height of each cell in the tableview
        tableView.separatorStyle = .none //removes the seperator lines between the cells in the tableview
        loadCategory()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {fatalError("NavBar doesn't exist.")}
        navBar.backgroundColor = UIColor(hexString: "#1D9BF6")
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray?.count ?? 1 //This is the 'Nil Coalescing Operator'
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //THE BELOW IS RESPONSIBLE FOR FILLING THE CELLS WITH THE VALUES THAT CORRESPOND WITH THE TABLE ARRAY
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath) //refers to the Super Category Cell Format/Function
        
        
        if let category = categoryArray?[indexPath.row] {
            
            cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added Yet"
            
            guard let categoryColour = UIColor(hexString: category.hex) else {fatalError("Couldn't bla bla bla")}
        
            cell.backgroundColor = categoryColour
            
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        
        }
        
        return cell
        
    }
    

    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
        
    }
    
    
    //MARK: - Data Manipulation Methods (savedata and loaddata)
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
                
                // realm.
            }
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
        
    }
    
    func loadCategory() {
  
        categoryArray = realm.objects(Category.self)
                
        tableView.reloadData()
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting item \(error)")
            }
            
        }
    }
    

    
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var catText = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
  
            
            let newCategory = Category()
            newCategory.name = catText.text!
            newCategory.hex = UIColor.randomFlat().hexValue()

            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in //alertTextField is a random name generated for the func, and is used to pass into this method.
            alertTextField.placeholder = "Add a new category." //The placeholder text within the editable field in the alert
            catText = alertTextField //Sets the value of the UITextField created above (catText) to be the value of alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}
