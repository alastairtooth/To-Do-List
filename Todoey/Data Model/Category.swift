//
//  Category.swift
//  Todoey
//
//  Created by Alastair Tooth on 6/9/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object { //Object is a Realm SuperClass, so by making Category a sub of it, it allows us to save data to the Realm instance
    
    @objc dynamic var name: String = "" //All Objects need to be @Objc Dynamic to work with Realm.
    @objc dynamic var hex: String = "" //grabs a hex code for a new category
    
    let items = List<Item>()  //This defines the forward relationship between Catagories and Items.  It basically says 'within each category there will be a list of items'
    
    
}
