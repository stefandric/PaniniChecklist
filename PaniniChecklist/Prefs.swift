//
//  Prefs.swift
//  PaniniChecklist
//
//  Created by Stefan Andric on 4/14/18.
//  Copyright © 2018 stefandric. All rights reserved.
//

import UIKit

class Prefs: NSObject {
    
    public class var isFirstTime: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "firstStart")
        } get {
            return UserDefaults.standard.bool(forKey: "firstStart")
        }
    }

}
