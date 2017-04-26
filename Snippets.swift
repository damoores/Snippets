//
//  Snippets.swift
//  
//
//  Created by Jeremy Moore on 4/26/17.
//
//  A collections of code snippets and extensions I have found useful, and may reuse some day.

import UIKit


/**
Conforming objects will return property names as an array of strings.
NOTE: Will NOT return super-class properties or computed properties
*/
protocol PropertyNames {
    /**
     Returns property names as an array of strings.
     NOTE: Will NOT return super-class properties or computed properties
     */
    func propertyNames() -> [String]
}

extension PropertyNames {

    func propertyNames() -> [String] {
        return Mirror(reflecting: self).children.flatMap { $0.label }
    }
}


extension UIResponder {
    /// Adds 'identifier' property to all subclasses of UIResponder
    static var identifier : String {
        return String(describing: self)
    }
}

extension UIImage {
    /// Resizes image to desired size.
    func resize(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}

extension UIImage {
    /// Shorcut URL to '../documentDirectory/image'
    var path: URL {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("error getting documents directory")
        }
        return documentsDirectory.appendingPathComponent("image")
    }
}


