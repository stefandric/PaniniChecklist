//
//  Sticker.swift
//  PaniniChecklist
//
//  Created by Stefan Andric on 4/15/18.
//  Copyright © 2018 stefandric. All rights reserved.
//

import UIKit
import RealmSwift

class Sticker: Object {
    @objc dynamic var elementId = 0
    @objc dynamic var isSelected = false
    @objc dynamic var numberOfDuplicates = 0
}
