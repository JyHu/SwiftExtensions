//
//  File.swift
//  
//
//  Created by hujinyou on 2025/1/9.
//

import Foundation

/// Protocol defining a condition used for grouping elements.
/// Each condition represents a single criterion for grouping.
public protocol GroupingConditionProtocol { }

/// Protocol defining an element that can be grouped based on conditions.
public protocol GroupableElementProtocol {
    /// Returns the key associated with the given condition, which is used for grouping.
    /// - Parameter condition: A condition defining the grouping criterion.
    /// - Returns: A `String` key for the given condition, or `nil` if the element doesn't match the condition.
    func makeKey(for condition: GroupingConditionProtocol) -> String?
}

/// Protocol defining a tree-like group structure for grouping elements hierarchically.
public protocol GroupedTreeNodeProtocol {
    associatedtype Element: GroupableElementProtocol
    
    /// A unique identifier for the group.
    var uniqueID: String { get }
    
    /// Child groups within the current group.
    var children: [Self] { get set }
    
    /// Elements directly belonging to the current group.
    var objects: [Element] { get set }
    
    /// Initializes a new group with the given unique identifier.
    /// - Parameter uniqueID: The unique identifier for the group.
    init(uniqueID: String)
    
    /// Method to handle the grouped element.
    /// - Parameter element: The element to be grouped
    func deal(with element: Element)
}

public extension GroupedTreeNodeProtocol {
    func deal(with element: Element) { }
}

public extension Array where Element: GroupableElementProtocol {
    /// Groups the elements in the array hierarchically based on the specified conditions.
    ///
    /// Each condition defines a level in the hierarchy. Elements are grouped into a tree structure
    /// where nodes correspond to unique keys returned by the `makeKey(for:)` method.
    ///
    /// - Parameter conditions: An array of conditions defining the grouping hierarchy.
    /// - Returns: An array of root-level groups of type `G` conforming to `GroupedTreeNodeProtocol`.
    ///
    /// Example Usage:
    /// ```swift
    /// struct MyCondition: GroupingConditionProtocol { }
    ///
    /// struct MyElement: GroupableElementProtocol {
    ///     let id: String
    ///     let category: String
    ///     let subcategory: String
    ///
    ///     func makeKey(for condition: GroupingConditionProtocol) -> String? {
    ///         if condition is MyCondition {
    ///             return category // Use category for grouping
    ///         }
    ///         return nil
    ///     }
    /// }
    ///
    /// struct MyGroup: GroupedTreeNodeProtocol {
    ///     var uniqueID: String
    ///     var children: [MyGroup] = []
    ///     var objects: [GroupableElementProtocol] = []
    ///
    ///     init(uniqueID: String) {
    ///         self.uniqueID = uniqueID
    ///     }
    /// }
    ///
    /// let elements = [MyElement(id: "1", category: "A", subcategory: "X"),
    ///                 MyElement(id: "2", category: "A", subcategory: "Y"),
    ///                 MyElement(id: "3", category: "B", subcategory: "Z")]
    ///
    /// let groups = elements.groupedHierarchically(by: [MyCondition()])
    /// ```
    func groupedHierarchically<G>(by conditions: [GroupingConditionProtocol]) -> [G] where G: GroupedTreeNodeProtocol, Element == G.Element {
        // Return an empty array if there are no conditions for grouping.
        if conditions.isEmpty {
            return []
        }
        
        // Create a root node to hold all groups.
        let rootNode = G(uniqueID: "root")
        
        let conditionCount = conditions.count
        
        // Iterate over each element to assign it to the appropriate group.
        for element in self {
            var parentGroup = rootNode // Start at the root group for each element.
            
            for (index, condition) in conditions.enumerated() {
                // Generate a grouping key for the current condition.
                if let key = element.makeKey(for: condition) {
                    // Check if a child group already exists for this key.
                    if let currentGroup = parentGroup.children.first(where: { $0.uniqueID == key }) {
                        // Navigate to the existing group.
                        parentGroup = currentGroup
                    } else {
                        // Create a new group if one does not exist.
                        let currentGroup = G(uniqueID: key)
                        parentGroup.children.append(currentGroup)
                        parentGroup = currentGroup
                    }
                    
                    // If it's the last condition, add the element to the current group.
                    if index == conditionCount - 1 {
                        parentGroup.objects.append(element)
                    }
                } else {
                    // If no key is generated, add the element to the current group directly.
                    parentGroup.objects.append(element)
                }
                
                parentGroup.deal(with: element)
            }
        }
        
        // Return the children of the root node as the top-level groups.
        return rootNode.children
    }
}
