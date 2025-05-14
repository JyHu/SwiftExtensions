//
//  Array+HierarchicalTests.swift
//
//
//  Created by hujinyou on 2025/1/9.
//

import XCTest
import SwiftExtensions

final class Array_HierarchicalTests: XCTestCase {
    struct TestCondition: GroupingConditionProtocol {
        let name: String
    }
    
    struct TestElement: GroupableElementProtocol {
        let properties: [String: String]
        
        func makeKey(for condition: GroupingConditionProtocol) -> String? {
            guard let condition = condition as? TestCondition else { return nil }
            return properties[condition.name]
        }
    }
    
    final class TestGroup: GroupedTreeNodeProtocol {
        typealias Element = TestElement
        
        var uniqueID: String
        var children: [TestGroup] = []
        var objects: [Element] = []
        
        required init(uniqueID: String) {
            self.uniqueID = uniqueID
        }
    }
    
    func testSingleLevelGrouping() {
        // Single-level condition
        let conditions = [TestCondition(name: "category")]
        
        // Elements to group
        let elements: [TestElement] = [
            TestElement(properties: ["category": "A"]),
            TestElement(properties: ["category": "B"]),
            TestElement(properties: ["category": "A"]),
        ]
        
        // Perform grouping
        let groupedResult = elements.groupedHierarchically(by: conditions) as [TestGroup]
        
        // Assertions
        XCTAssertEqual(groupedResult.count, 2, "There should be two groups.")
        XCTAssertTrue(groupedResult.contains { $0.uniqueID == "A" }, "Group A should exist.")
        XCTAssertTrue(groupedResult.contains { $0.uniqueID == "B" }, "Group B should exist.")
        
        let groupA = groupedResult.first { $0.uniqueID == "A" }
        XCTAssertEqual(groupA?.objects.count, 2, "Group A should contain 2 elements.")
        
        let groupB = groupedResult.first { $0.uniqueID == "B" }
        XCTAssertEqual(groupB?.objects.count, 1, "Group B should contain 1 element.")
    }
    
    func testMultiLevelGrouping() {
        // Multi-level conditions
        let conditions = [
            TestCondition(name: "category"),
            TestCondition(name: "subcategory"),
        ]
        
        // Elements to group
        let elements: [TestElement] = [
            TestElement(properties: ["category": "A", "subcategory": "X"]),
            TestElement(properties: ["category": "A", "subcategory": "Y"]),
            TestElement(properties: ["category": "B", "subcategory": "Z"]),
            TestElement(properties: ["category": "A", "subcategory": "X"]),
        ]
        
        // Perform grouping
        let groupedResult = elements.groupedHierarchically(by: conditions) as [TestGroup]
        
        // Assertions
        XCTAssertEqual(groupedResult.count, 2, "There should be two top-level groups.")
        
        let groupA = groupedResult.first { $0.uniqueID == "A" }
        XCTAssertNotNil(groupA, "Group A should exist.")
        XCTAssertEqual(groupA?.children.count, 2, "Group A should have 2 sub-groups.")
        
        let subGroupX = groupA?.children.first { $0.uniqueID == "X" }
        XCTAssertEqual(subGroupX?.objects.count, 2, "Sub-group X should contain 2 elements.")
        
        let subGroupY = groupA?.children.first { $0.uniqueID == "Y" }
        XCTAssertEqual(subGroupY?.objects.count, 1, "Sub-group Y should contain 1 element.")
        
        let groupB = groupedResult.first { $0.uniqueID == "B" }
        XCTAssertNotNil(groupB, "Group B should exist.")
        XCTAssertEqual(groupB?.children.count, 1, "Group B should have 1 sub-group.")
        
        let subGroupZ = groupB?.children.first { $0.uniqueID == "Z" }
        XCTAssertEqual(subGroupZ?.objects.count, 1, "Sub-group Z should contain 1 element.")
    }
    
    func testNoConditions() {
        let conditions: [GroupingConditionProtocol] = []
        let elements: [TestElement] = [
            TestElement(properties: ["key": "value"])
        ]
        
        // Perform grouping
        let groupedResult = elements.groupedHierarchically(by: conditions) as [TestGroup]
        
        // Assertions
        XCTAssertTrue(groupedResult.isEmpty, "Grouping with no conditions should return an empty array.")
    }
    
    func testNoElements() {
        let conditions = [TestCondition(name: "category")]
        let elements: [TestElement] = []
        
        // Perform grouping
        let groupedResult = elements.groupedHierarchically(by: conditions) as [TestGroup]
        
        // Assertions
        XCTAssertTrue(groupedResult.isEmpty, "Grouping with no elements should return an empty array.")
    }
    
    func testDeepGrouping() {
        // Deeply nested conditions
        let conditions = [
            TestCondition(name: "level1"),
            TestCondition(name: "level2"),
            TestCondition(name: "level3")
        ]
        
        // Elements to group
        let elements: [TestElement] = [
            TestElement(properties: ["level1": "A", "level2": "X", "level3": "P"]),
            TestElement(properties: ["level1": "A", "level2": "X", "level3": "Q"]),
            TestElement(properties: ["level1": "A", "level2": "Y", "level3": "R"]),
            TestElement(properties: ["level1": "B", "level2": "Z", "level3": "S"]),
        ]
        
        // Perform grouping
        let groupedResult = elements.groupedHierarchically(by: conditions) as [TestGroup]
        
        // Assertions
        XCTAssertEqual(groupedResult.count, 2, "There should be two top-level groups.")
        
        let groupA = groupedResult.first { $0.uniqueID == "A" }
        XCTAssertNotNil(groupA, "Group A should exist.")
        XCTAssertEqual(groupA?.children.count, 2, "Group A should have 2 second-level groups.")
    }
}

final class ArrayHierachicalTests: XCTestCase {
    struct TestCondition: GroupingConditionProtocol {
        let name: String
    }
    
    struct TestElement: GroupableElementProtocol {
        let properties: [String: String]
        let price: Double
        let quantity: Int
        
        func makeKey(for condition: GroupingConditionProtocol) -> String? {
            guard let condition = condition as? TestCondition else { return nil }
            return properties[condition.name]
        }
    }
    
    final class TestGroup: GroupedTreeNodeProtocol {
        typealias Element = TestElement
        
        var uniqueID: String
        var children: [TestGroup] = []
        var objects: [TestElement] = []
        
        var price: Double = 0
        var quantity: Int = 0
        
        required init(uniqueID: String) {
            self.uniqueID = uniqueID
        }
        
        func deal(with element: TestElement) {
            price += element.price
            quantity += element.quantity
        }
    }
    
    // 测试多级分组
    func testMultiLevelGrouping() {
        // 条件定义
        let conditions = [
            TestCondition(name: "shape"),
            TestCondition(name: "color"),
            TestCondition(name: "size")
        ]
        
        // 创建一些元素用于分组
        let elements = [
            TestElement(properties: ["shape": "circle", "color": "red", "size": "large"], price: 9.99, quantity: 5),
            TestElement(properties: ["shape": "circle", "color": "red", "size": "small"], price: 8.99, quantity: 3),
            TestElement(properties: ["shape": "circle", "color": "blue", "size": "large"], price: 10.99, quantity: 7),
            TestElement(properties: ["shape": "square", "color": "red", "size": "large"], price: 12.99, quantity: 4),
            TestElement(properties: ["shape": "square", "color": "blue", "size": "small"], price: 11.99, quantity: 6)
        ]
        
        // 使用groupedHierarchically方法分组
        let groups: [TestGroup] = elements.groupedHierarchically(by: conditions)
        
        // 验证分组结果
        XCTAssertEqual(groups.count, 2)  // 两个主类别：circle 和 square
        
        // 验证第一个主组
        if let circleGroup = groups.first(where: { $0.uniqueID == "circle" }) {
            XCTAssertEqual(circleGroup.children.count, 2)  // 需要分出color和size组
            let redGroup = circleGroup.children.first(where: { $0.uniqueID == "red" })
            XCTAssertEqual(redGroup?.children.count, 2)  // 需要分出size组
            let largeGroup = redGroup?.children.first(where: { $0.uniqueID == "large" })
            XCTAssertEqual(largeGroup?.objects.count, 1)
            
            let smallGroup = redGroup?.children.first(where: { $0.uniqueID == "small" })
            XCTAssertEqual(smallGroup?.objects.count, 1)
        }
        
        // 验证第二个主组
        if let squareGroup = groups.first(where: { $0.uniqueID == "square" }) {
            XCTAssertEqual(squareGroup.children.count, 2)  // color 和 size
            let redGroup = squareGroup.children.first(where: { $0.uniqueID == "red" })
            XCTAssertEqual(redGroup?.children.count, 1)  // size
            let largeGroup = redGroup?.children.first(where: { $0.uniqueID == "large" })
            XCTAssertEqual(largeGroup?.objects.count, 1)
        }
        
        // 验证deal方法正确合并元素数据
        if let circleGroup = groups.first(where: { $0.uniqueID == "circle" }) {
            let redGroup = circleGroup.children.first(where: { $0.uniqueID == "red" })
            let largeGroup = redGroup?.children.first(where: { $0.uniqueID == "large" })
            
            // 价格和数量应该是合并的
            XCTAssertEqual(largeGroup?.price, 9.99)  // 只有一个元素，价格是9.99
            XCTAssertEqual(largeGroup?.quantity, 5)  // 只有一个元素，数量是5
        }
    }
}
