//
//  File.swift
//  
//
//  Created by Jo on 2022/10/30.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public extension NSTableView {
    /// table列的状态数据对象
    struct ColumnState: Codable {
        /// 是否隐藏
        var isHidden: Bool
        /// 列宽度
        var width: CGFloat
        /// 列标识符
        var identifier: NSUserInterfaceItemIdentifier
        
        enum CodingKeys: String, CodingKey {
            case hidden, width, identifier
        }
        
        /// 初始化方法
        /// - Parameters:
        ///   - identifier: 列标识符
        ///   - width: 列宽度
        ///   - isHidden: 是否隐藏
        init(identifier: NSUserInterfaceItemIdentifier, width: CGFloat, isHidden: Bool) {
            self.identifier = identifier
            self.width = width
            self.isHidden = isHidden
        }
        
        /// 初始化方法，使用缓存的字典数据初始化
        /// - Parameter keyValues: 缓存的数据字典
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
    
    /// 按照缓存的所有列状态数据恢复数据
    /// - Parameter columnStates: 缓存的列数据，可以通过`arrangedColumnStates`方法生成缓存数据
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
    
    /// 按照缓存的所有列状态数据恢复数据
    /// - Parameter columnKeyValues: 缓存的列数据，可以通过`arrangedColumnStates`方法生成缓存数据
    func rearranged(with columnKeyValues: [[String: Any]]) {
        rearranged(with: columnKeyValues.compactMap { ColumnState(keyValues: $0 ) })
    }
    
    /// 对所有的列按照给定的顺序排序
    /// - Parameter columnIdentifiers: 排序好的列标识符数组
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
    
    /// 获取所有列的状态
    var arrangedColumnStates: [ColumnState] {
        tableColumns.map {
            ColumnState(identifier: $0.identifier, width: $0.width, isHidden: $0.isHidden)
        }
    }
    
    /// 隐藏给定的列，其他列保持现在状态
    /// - Parameter identifiers: 需要隐藏的列
    func hideColumns(with identifiers: [NSUserInterfaceItemIdentifier]) {
        for tableColumn in tableColumns {
            if identifiers.contains(tableColumn.identifier) {
                tableColumn.isHidden = true
            }
        }
    }
    
    /// 仅隐藏给定的列，其他的列会显示出来
    /// - Parameter identifiers: 需要隐藏的列，如果不在数组中，会显示出来
    func onlyHideColumns(with identifiers: [NSUserInterfaceItemIdentifier]) {
        for tableColumn in tableColumns {
            tableColumn.isHidden = identifiers.contains(tableColumn.identifier)
        }
    }
    
    /// 通过鼠标事件获取点击处的行列值
    /// - Parameter event: 鼠标点击事件
    /// - Returns: 鼠标选中的行、列
    func rowColumn(for event: NSEvent) -> (row: Int, column: Int) {
        let point = convert(event.locationInWindow, from: nil)

        let row = self.row(at: point)
        let column = self.column(at: point)
        
        return (row, column)
    }
    
    /// 刷新所有数据，并保持之前的选择行
    func reloadAndKeepSelection() {
        var selectedRow = selectedRow
        
        reloadData()
        
        if numberOfRows == 0 { return }
        
        if selectedRow < 0 || selectedRow >= numberOfRows {
            selectedRow = min(max(selectedRow, 0), numberOfRows - 1)
        }
        
        selectRowIndexes(IndexSet(arrayLiteral: selectedRow), byExtendingSelection: true)
    }
    
    /// 刷新一行数据，避免刷新时越界
    /// - Parameters:
    ///   - row: 需要刷新的数据行
    ///   - columnIndexes: 需要刷新的数据列，如果为空，那么会刷新所有列
    func reloadData(atRow row: Int, columnIndexes: IndexSet? = nil) {
        guard row >= 0 && row < numberOfRows else { return }
        let columns = columnIndexes ?? IndexSet(0..<numberOfColumns)
        reloadData(forRowIndexes: IndexSet(arrayLiteral: row), columnIndexes: columns)
    }
    
    /// 添加一个列对象
    /// - Description: 如果设置了最小最大宽度，那么默认宽度为平均值
    /// - Parameters:
    ///   - identifier: 列的唯一标识符
    ///   - title: 列标题
    ///   - minWidth: 列最小宽度
    ///   - maxWidth: 列最大宽度
    ///   - width: 初始展示的列宽
    /// - Returns: 添加后的列对象
    @discardableResult
    func addTableColumn(identifier: NSUserInterfaceItemIdentifier, title: String, minWidth: CGFloat? = nil, maxWidth: CGFloat? = nil, width: CGFloat? = nil) -> NSTableColumn {
        let tableColumn = NSTableColumn(identifier: identifier, title: title, minWidth: minWidth, maxWidth: maxWidth, width: width)
        self.addTableColumn(tableColumn)
        return tableColumn
    }
    
    /// 创建一个复用的cell
    /// - Description:  `tableView.reuse<MyCell>(with: .myidentifier)`
    /// - Parameter identifier: cell的唯一标识符
    /// - Returns: cell
    func reuse<T>(with identifier: NSUserInterfaceItemIdentifier) -> T where T: NSTableCellView {
        return reuse(with: identifier, orCreate: T())
    }
    
    /// 创建一个复用的cell
    /// - Description: `tableView.reuse(with: .myidentifier, orCreate: MyCell())`
    /// - Parameters:
    ///   - identifier: cell的唯一标识符
    ///   - creation: 用于创建cell的block
    /// - Returns: cell
    func reuse<T>(with identifier: NSUserInterfaceItemIdentifier, orCreate creation: @autoclosure() -> T) -> T where T: NSTableCellView {
        if let cellView = makeView(withIdentifier: identifier, owner: self) as? T {
            return cellView
        }
        
        let cellView = creation()
        cellView.identifier = identifier
        return cellView
    }
}

#endif
