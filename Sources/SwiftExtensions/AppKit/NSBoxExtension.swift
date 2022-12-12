//
//  NSBoxExtension.swift
//  
//
//  Created by Jo on 2022/11/25.
//

import Cocoa

public extension NSBox {
    convenience init(boxType: BoxType = .custom, title: String = "", contentView: NSView) {
        self.init(frame: NSMakeRect(0, 0, 100, 100))
        self.contentView = contentView
        self.boxType = boxType
        self.title = title
    }
}
