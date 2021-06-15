//
//  Item.swift
//  Todoey
//
//  Created by Alastair Tooth on 6/9/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var Done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    //This says 'each item has a parent category which is of the type 'Category', from the category property 'items''
    
}
