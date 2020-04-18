//
//  Helper.swift
//  meetapp
//
//  Created by Maor Refaeli on 18/04/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class Helper{
    private static let levels = [
        0: "Beginner",
        1: "Intermidate",
        2: "Advanced"
    ]
    
    static func showToast(controller: UIViewController, message : String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        
        controller.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
    static func unionArrays(arr1:[String], arr2:[String]) -> [String] {
        return Array(Set(arr1).union(Set(arr2)))
    }
    
    static func subtractArrays(arr1:[String], arr2:[String]) -> [String] {
        return Array(Set(arr1).subtracting(Set(arr2)))
    }
    
    static func getLevelAsString(_ level: Int) -> String {
        if let result = levels[level] {
            return result
        } else {
            return levels[0]!
        }
    }
}
