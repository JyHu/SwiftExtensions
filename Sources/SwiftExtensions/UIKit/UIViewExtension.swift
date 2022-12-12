//
//  File.swift
//  
//
//  Created by Jo on 2022/11/1.
//

#if canImport(UIKit)

import UIKit

public extension UIView {
    func snapShot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

#endif
