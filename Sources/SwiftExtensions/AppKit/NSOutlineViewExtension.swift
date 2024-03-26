//
//  File.swift
//  
//
//  Created by Jo on 2022/11/12.
//

#if canImport(AppKit) && os(macOS)

import AppKit

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
    
    @discardableResult
    func addOutlineColumn(identifier: NSUserInterfaceItemIdentifier, title: String, minWidth: CGFloat? = nil, maxWidth: CGFloat? = nil, width: CGFloat? = nil) -> NSTableColumn {
        let tableColumn = addTableColumn(identifier: identifier, title: title, minWidth: minWidth, maxWidth: maxWidth, width: width)
        self.outlineTableColumn = tableColumn
        return tableColumn
    }
}

public extension NSOutlineView {
    /// 节点类型
    enum NodeGrid {
        case empty      /// 不需要绘制节点
        case line       /// 竖线
        case last       /// ┗
        case middle     /// ┣
    }
    
    class NodeRowView: NSTableRowView {
        fileprivate enum Style {
            case line   /// 直线
            case dash   /// 虚线
        }
        
        /// 节点绘制的配置信息
        public struct Config {
            /// 线宽
            fileprivate var width: CGFloat
            /// 颜色
            fileprivate var color: NSColor
            /// 类型
            fileprivate var style: Style
            /// 虚线信息
            fileprivate var lengths: [CGFloat] = []
            
            /// 绘制直线
            public static func line(width: CGFloat = 1, color: NSColor = .gridColor) -> Config {
                return Config(width: width, color: color, style: .line)
            }
            
            /// 绘制虚线
            public static func dash(width: CGFloat = 1, color: NSColor = .gridColor, lengths: [CGFloat] = [1, 2]) -> Config {
                return Config(width: width, color: color, style: .dash, lengths: lengths)
            }
        }
        
        private var nodeGrids: [NSOutlineView.NodeGrid] = []
        private var minX: CGFloat = 0
        private var config: Config = .dash()
        private var indentation: CGFloat = 0
        
        /// 创建一个行视图
        /// - Parameters:
        ///   - minX: 当前列的起始x坐标
        ///   - nodeGrids: 节点绘制信息
        ///   - config: 配置信息
        ///   - indentation: outlineview的每行的缩紧
        init(minX: CGFloat, nodeGrids: [NSOutlineView.NodeGrid], config: Config, indentation: CGFloat) {
            super.init(frame: NSMakeRect(0, 0, 100, 100))
            self.nodeGrids = nodeGrids
            self.minX = minX
            self.indentation = indentation
            self.config = config
        }
        
        required public init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        open override func draw(_ dirtyRect: NSRect) {
            super.draw(dirtyRect)
            
            guard nodeGrids.count > 0 else { return }
            guard let context = NSGraphicsContext.current?.cgContext else { return }
            
            NSColor.secondaryLabelColor.setStroke()
            
            context.saveGState()
            
            context.setLineJoin(.round)
            context.setLineCap(.round)
            
            context.setLineWidth(1)
            context.setFillColor(config.color.cgColor)
            
            if config.style == .dash {
                context.setLineDash(phase: 0, lengths: config.lengths)
            }
            
            for (level, nodeGrid) in nodeGrids.enumerated() {
                if nodeGrid == .empty {
                    continue
                }
                
                let xorigin = indentation * CGFloat(level) + 7 + minX
                let centerY = dirtyRect.height / 2
                let horWidth = indentation - 6
                
                context.move(to: CGPoint(x: xorigin, y: 0))
                
                if nodeGrid == .line {
                    context.addLine(to: CGPoint(x: xorigin, y: dirtyRect.height))
                } else if nodeGrid == .middle {
                    context.addLine(to: CGPoint(x: xorigin, y: dirtyRect.height))
                    context.move(to: CGPoint(x: xorigin, y: centerY))
                    context.addLine(to: CGPoint(x: xorigin + horWidth, y: centerY))
                } else if nodeGrid == .last {
                    context.addLine(to: CGPoint(x: xorigin, y: dirtyRect.height / 2))
                    context.addLine(to: CGPoint(x: xorigin + horWidth, y: centerY))
                }
            }
            
            context.strokePath()
            context.restoreGState()
        }
    }
    
    /// 获取当前行节点信息
    func nodeGrids(of item: Any) -> [NodeGrid] {
        func isGroupEnding(of obj: Any) -> Bool {
            let parent = parent(forItem: obj)
            let index = childIndex(forItem: obj)
            let count = numberOfChildren(ofItem: parent)
            return index == count - 1
        }
        
        var object: Any? = item
        var endingStates: [Bool] = []
        
        while let obj = object {
            endingStates.insert(isGroupEnding(of: obj), at: 0)
            object = parent(forItem: obj)
        }
        
        endingStates.removeFirst()
        
        var grids: [NodeGrid] = []
        
        for (level, groupEnding) in endingStates.enumerated() {
            let isLast = level == endingStates.count - 1
            if groupEnding {
                grids.append(isLast ? .last : .empty)
            } else {
                grids.append(isLast ? .middle : .line)
            }
        }
        
        return grids
    }
    
    /// 创建一个行视图
    func nodeGridRow(of item: Any, config: NodeRowView.Config = .dash()) -> NSTableRowView? {
        guard let outlineTableColumn = self.outlineTableColumn else { return nil }
        guard !outlineTableColumn.isHidden else { return nil }
        let column = self.column(withIdentifier: outlineTableColumn.identifier)
        let rect = self.rect(ofColumn: column)
        return NodeRowView(minX: rect.minX, nodeGrids: self.nodeGrids(of: item), config: config, indentation: indentationPerLevel)
    }
}

#endif
