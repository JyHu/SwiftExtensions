//
//  File.swift
//  
//
//  Created by Jo on 2022/11/12.
//

#if canImport(Cocoa) && os(macOS)

import Cocoa

public extension NSOutlineView {
    /// 展开所有节点
    func expandAll() {
        expandItem(nil, expandChildren: true)
    }

    /// 展开指定位置的节点
    /// - Parameters:
    ///   - row: 要展开节点的位置
    ///   - expandChildren: 是否展开子节点
    func expand(at row: Int, expandChildren: Bool = false) {
        if row < numberOfRows {
            expandItem(item(atRow: row), expandChildren: expandChildren)
        }
    }
}

#endif
