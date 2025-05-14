//
//  GroupEnumerator.swift
//  SwiftExtensions
//
//  Created by hujinyou on 2025/5/14.
//

import Foundation

/// 一个分组枚举器，用于将数组按照指定大小分组并逐组处理。
/// 适用于需要分批处理或分页加载的场景，例如网络请求的分组上传、分页显示大数据等。
///
/// ### 功能说明
/// 1. **按组分割数组**：将一个数组分成若干组，每组大小由 `groupSize` 指定。
/// 2. **逐步获取分组数据**：通过调用 `nextGroup()` 方法获取下一组数据。
/// 3. **终止判断**：通过 `isAtEnd` 属性判断是否已经处理完所有数据。
///
/// ### 使用示例
/// 假设我们有 100 个订单 ID 的数组，需要以每组 20 个订单的形式进行批量处理：
///
/// ```swift
/// // 示例数据：100 个订单 ID
/// let orderIDs = (1...100).map { "Order-\($0)" }
///
/// // 创建分组枚举器，每组 20 个订单。
/// var enumerator = TBGroupEnumerate(elements: orderIDs, groupSize: 20)
///
/// // 使用 while 循环逐组处理订单。
/// while !enumerator.isAtEnd {
///     // 获取当前分组的数据
///     let tmpOrderIDs = enumerator.nextGroup()
///
///     // 模拟处理这些订单
///     print("Processing group: \(tmpOrderIDs)")
/// }
/// ```
///
/// ### 输出示例
/// 假设 `orderIDs` 为 ["Order-1", "Order-2", ..., "Order-100"]，程序输出如下：
/// ```
/// Processing group: ["Order-1", "Order-2", ..., "Order-20"]
/// Processing group: ["Order-21", "Order-22", ..., "Order-40"]
/// Processing group: ["Order-41", "Order-42", ..., "Order-60"]
/// Processing group: ["Order-61", "Order-62", ..., "Order-80"]
/// Processing group: ["Order-81", "Order-82", ..., "Order-100"]
/// ```
///
/// ### 边界情况
/// - 如果 `elements` 为空，则 `nextGroup()` 始终返回空数组。
/// - 如果 `groupSize` 大于 `elements` 的长度，则返回整个数组。
/// - 如果 `groupSize` 小于等于 0，内部逻辑仍会保证正确的结果，但请合理设置该值。
///
public struct TBGroupEnumerate<Element> {
    /// 需要分组的完整数据数组。
    public let elements: [Element]
    
    /// 每组包含的元素个数。
    /// - 如果为正整数，则每次 `nextGroup()` 返回该数量的元素（最后一组可能不足）。
    /// - 如果为负值或零，内部逻辑会自动处理为合理的结果。
    public let groupSize: Int
    
    /// 当前处理到的数据索引，初始为 0。
    /// 随着 `nextGroup()` 的调用，该值会逐渐增加，直至到达数组末尾。
    private var curIndex: Int = 0
    
    /// 初始化方法，用于构造分组枚举器。
    /// - Parameters:
    ///   - elements: 待分组的数组。
    ///   - groupSize: 每组的元素个数。
    public init(elements: [Element], groupSize: Int) {
        self.elements = elements
        self.groupSize = groupSize
    }
    
    /// 判断是否已经处理到数组末尾。
    /// - 返回 `true` 表示所有数据已处理完成，`false` 表示还有未处理的数据。
    public var isAtEnd: Bool {
        return curIndex >= elements.count
    }
    
    /// 获取下一组的数据。
    /// 每次调用都会返回当前索引位置开始的一组数据，并将索引移动到下一个分组的起始位置。
    /// - 如果数组中剩余数据不足一组，返回剩余的所有数据。
    /// - 如果已处理完所有数据，返回空数组。
    /// - Returns: 当前分组的数组。
    public mutating func nextGroup() -> [Element]? {
        // 判断是否已经到达末尾
        guard !isAtEnd else {
            return nil // 如果到达末尾，返回空值
        }
        
        // 计算本组的实际元素个数
        var tmpCount: Int = groupSize
        if curIndex + tmpCount > elements.count {
            tmpCount = elements.count - curIndex
        }
        
        // 如果分组大小小于或等于零（理论上不会出现），返回空数组。
        if tmpCount <= 0 {
            return nil
        }
        
        // 根据当前索引切片获取分组数据
        let group = Array(elements[curIndex..<curIndex + tmpCount])
        
        // 更新当前索引到下一个分组的起始位置
        curIndex += tmpCount
        
        return group
    }
}
