//
//  AppDelegate.swift
//  Destini
//
//  Created by Philipp Muellauer on 01/09/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITableViewDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // print(Realm.Configuration.defaultConfiguration.fileURL) - FINDS REALM FILE PATHWAY

        // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)) - FINDS COREDATA PATHWAY
        
        do {
            let _ = try Realm()
        } catch {
            print("error initialising new realm, \(error)")
        }
        
        return true
    }
    
    //The above is used to attempt to initialise Realm.  Even though it's not used in the code except for the very first usage setting up a Realm instance, it's kept so that if we have an error initialising a Realm, it'll happen at app launch instead of at a later stage.
    //  a "_" is used instead of previously having "realm" written because we're not using the variable for anything so it cleans up the code.
    
}
