//
//  File.swift
//  
//
//  Created by Jo on 2022/10/30.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public extension NSTableView {
    struct ColumnState: Codable {
        var isHidden: Bool
        var width: CGFloat
        var identifier: NSUserInterfaceItemIdentifier
        
        enum CodingKeys: String, CodingKey {
            case hidden, width, identifier
        }
        
        init(identifier: NSUserInterfaceItemIdentifier, width: CGFloat, isHidden: Bool) {
            self.identifier = identifier
            self.width = width
            self.isHidden = isHidden
        }
        
        init?(keyValues: [String: Any]) {
            guard let isHidden = keyValues["hidden"] as? Bool,
                  let width = keyValues["width"] as? CGFloat else {
                return nil
            }
            
            if let identifier = keyValues["identifier"] as? String {
                self.identifier = NSUserInterfaceItemIdentifier(identifier)
            } else if let identifier = keyValues["identifier"] as? NSUserInterfaceItemIdentifier {
                self.identifier = identifier
            } else {
                return nil
            }
            
            self.isHidden = isHidden
            self.width = width
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            isHidden = try container.decode(Bool.self, forKey: .hidden)
            width = try container.decode(CGFloat.self, forKey: .width)
            let identifierStr = try container.decode(String.self, forKey: .identifier)
            self.identifier = NSUserInterfaceItemIdentifier(identifierStr)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(isHidden, forKey: .hidden)
            try container.encode(width, forKey: .width)
            try container.encode(identifier.rawValue, forKey: .identifier)
        }
    }
    
    func rearranged(with columnStates: [ColumnState]) {
        func isEqualTo(columnState: ColumnState, at index: Int) -> Bool {
            let tableColumn = tableColumns[index]
            
            if tableColumn.identifier == columnState.identifier {
                tableColumn.width = columnState.width
                tableColumn.isHidden = columnState.isHidden
                return true
            }
            
            return false
        }
        
        if columnStates.isEmpty { return }
        var index: Int = 0
        
        while index < tableColumns.count && index < columnStates.count {
            let arrangedColumnState = columnStates[index]
            if !isEqualTo(columnState: arrangedColumnState, at: index) {
                for innerIndex in (index + 1) ..< tableColumns.count {
                    if isEqualTo(columnState: arrangedColumnState, at: innerIndex) {
                        moveColumn(innerIndex, toColumn: index)
                        break
                    }
                }
            }
            
            index += 1
        }
    }
    
    func rearranged(with columnKeyValues: [[String: Any]]) {
        rearranged(with: columnKeyValues.compactMap { ColumnState(keyValues: $0 ) })
    }
    
    func rearranged(with columnIdentifiers: [NSUserInterfaceItemIdentifier]) {
        if columnIdentifiers.isEmpty { return }
        var index: Int = 0
        
        while index < tableColumns.count, index < columnIdentifiers.count {
            let arrangedIdentifier = columnIdentifiers[index]
            if arrangedIdentifier != tableColumns[index].identifier {
                for innerIndex in (index + 1) ..< tableColumns.count {
                    if arrangedIdentifier == tableColumns[innerIndex].identifier {
                        moveColumn(innerIndex, toColumn: index)
                        break
                    }
                }
            }
            
            index += 1
        }
    }
    
    var arrangedColumnStates: [ColumnState] {
        tableColumns.map {
            ColumnState(identifier: $0.identifier, width: $0.width, isHidden: $0.isHidden)
        }
    }
    
    func hideColumns(with identifiers: [NSUserInterfaceItemIdentifier]) {
        for tableColumn in tableColumns {
            if identifiers.contains(tableColumn.identifier) {
                tableColumn.isHidden = true
            }
        }
    }
    
    /// <#Description#>
    /// - Parameter identifiers: <#identifiers description#>
    func onlyHideColumns(with identifiers: [NSUserInterfaceItemIdentifier]) {
        for tableColumn in tableColumns {
            tableColumn.isHidden = identifiers.contains(tableColumn.identifier)
        }
    }
}

#endif
