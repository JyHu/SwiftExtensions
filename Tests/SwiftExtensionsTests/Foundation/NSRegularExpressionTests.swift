//
//  NSRegularExpressionTests.swift
//  
//
//  Created by Jo on 2022/11/2.
//

import XCTest
import SwiftExtensions
import RegexBuilder
import WebKit

final class NSRegularExpressionTests: XCTestCase {
    func testExample() throws {
        let html =
            """
            <html>
                <head>
                    <title>this is test</title>
                </head>
                <body>
                    <a href="https://itiger.com">itiger</a>
                </body>
            </html>
            """
        
        let reg = try? NSRegularExpression(pattern: "<\\w+>")
        XCTAssertNotNil(reg)
        
        let firstRange = reg?.firstMatch(in: html)
        XCTAssertNotNil(firstRange)
        XCTAssertTrue(NSEqualRanges(firstRange!.range, NSRange(location: 0, length: 6)))
        
        XCTAssertTrue(reg!.matches(in: html).count == 4)
        
        let groupedResults: [[String]] = [["<html>"], ["<head>"], ["<title>"], ["<body>"]]
        XCTAssertEqual(reg!.groupedResults(in: html), groupedResults)
        
        var enumeratedResults: [String] = []
        reg!.enumerateMatches(in: html) { result, flags, stop in
            guard let range = result?.range, let text = html[range] else {
                return
            }
            enumeratedResults.append(text)
        }
        XCTAssertEqual(enumeratedResults, ["<html>", "<head>", "<title>", "<body>"])
        
        
        let replacedHtml =
            """
            <<html>>
                <<head>>
                    <<title>>this is test</title>
                </head>
                <<body>>
                    <a href="https://itiger.com">itiger</a>
                </body>
            </html>
            """
        XCTAssertEqual(reg!.stringByReplacingMatches(in: html, withTemplate: "<$0>"), replacedHtml)
    }
    
    func testGruops() throws {
        let reg = try NSRegularExpression(pattern: "<[\\w\\.]+:(?<ConstraintID>0x\\w+)\\s*(?<LeftItem>.*?):(?<LeftAddress>0x\\w+)\\.(?<LeftAnchor>\\w+)\\s+(?<Operater>==|>=|<=)\\s+(([\\d\\.]+)|((.*?):(0x\\w+))\\.(\\w+)(\\s+[+-]\\s+[\\d\\.]+)?)>")
        let groups = reg.namedCaptureGroups
        print(groups)
    }
    
    func testMatches() throws {
        let sources =
        """
        Conflicting constraints detected: [
            <NSLayoutConstraint:0x60000205c820 TBView:0x153328210.width >= 210>,
            <NSLayoutConstraint:0x60000205cb40 TBView:0x153328210.right == _NSSplitViewItemViewWrapper:0x153327e30.right>,
            <NSLayoutConstraint:0x60000205caf0 TBView:0x153328210.left == _NSSplitViewItemViewWrapper:0x153327e30.left>,
            <NSLayoutConstraint:0x6000023a9130 _NSSplitViewItemViewWrapper:0x153327e30.left == TBSplitView:0x153267b00.left>,
            <NSAutoresizingMaskLayoutConstraint:0x6000023aef30 TBSplitView:0x153267b00.(null) == 0>,
            <NSAutoresizingMaskLayoutConstraint:0x6000023ac820 NSView:0x153327c00.width == TBSplitView:0x153267b00.(null)>,
            <NSAutoresizingMaskLayoutConstraint:0x600002040c80 NSView:0x153327c00.(null) == 0>,
            <NSAutoresizingMaskLayoutConstraint:0x600002040cd0 TBTabView:0x153258b60.width == NSView:0x153327c00.(null)>,
            <NSLayoutConstraint:0x6000023a9310 _NSSplitViewItemViewWrapper:0x15332be20.left == _NSSplitViewItemViewWrapper:0x153327e30.right + 1>,
            <NSLayoutConstraint:0x6000023aada0 TBSplitView:0x153267b00.right == _NSSplitViewItemViewWrapper:0x15332be20.right>,
            <NSLayoutConstraint:0x60000205cfa0 TBTabView:0x10a06fb10.width >= 200>,
            <NSLayoutConstraint:0x60000205d090 TBTabView:0x10a06fb10.right == _NSSplitViewItemViewWrapper:0x15332be20.right>,
            <NSLayoutConstraint:0x60000205d040 TBTabView:0x10a06fb10.left == _NSSplitViewItemViewWrapper:0x15332be20.left>,
            <MASLayoutConstraint:0x6000024aa460 TBTabView:0x153258b60.left == TBView:0x153251e70.left>,
            <MASLayoutConstraint:0x6000024aa2e0 TBTabView:0x153258b60.right == TBView:0x153251e70.right>,
            <NSLayoutConstraint:0x60000206bc00 TBView:0x153251e70.left == _NSSplitViewItemViewWrapper:0x15326de10.left>,
            <NSLayoutConstraint:0x60000206bc50 _NSSplitViewItemViewWrapper:0x15326de10.right == TBView:0x153251e70.right>,
            <NSLayoutConstraint:0x600002040550 _NSSplitViewItemViewWrapper:0x15326de10.left == TBSplitView:0x11dd65f70.left>,
            <NSLayoutConstraint:0x6000020405a0 _NSSplitViewItemViewWrapper:0x15326de10.right == TBSplitView:0x11dd65f70.right>,
            <NSLayoutConstraint:0x6000023a5770 TBView:0x109ffc810.left == _NSSplitViewItemViewWrapper:0x11ddc7430.left>,
            <NSLayoutConstraint:0x6000023a57c0 _NSSplitViewItemViewWrapper:0x11ddc7430.right == TBView:0x109ffc810.right>,
            <NSLayoutConstraint:0x6000023a04b0 _NSSplitViewItemViewWrapper:0x11ddc7430.left == TBSplitView:0x109ffab10.left>,
            <NSLayoutConstraint:0x6000023a0500 _NSSplitViewItemViewWrapper:0x11ddc7430.right == TBSplitView:0x109ffab10.right>,
            <NSAutoresizingMaskLayoutConstraint:0x6000023a0730 TBSplitView:0x109ffab10.(null) == 0>,
            <NSAutoresizingMaskLayoutConstraint:0x6000023a0780 NSView:0x10a05fe30.width == TBSplitView:0x109ffab10.(null)>,
            <NSAutoresizingMaskLayoutConstraint:0x60000204d680 NSView:0x10a05fe30.(null) == 0>,
            <NSAutoresizingMaskLayoutConstraint:0x60000204d6d0 TBTabView:0x10a05e850.width == NSView:0x10a05fe30.(null)>,
            <MASLayoutConstraint:0x600002550ae0 TBTabView:0x10a05e850.left == TBView:0x10a05cd20.left>,
            <MASLayoutConstraint:0x600002550ba0 TBTabView:0x10a05e850.right == TBView:0x10a05cd20.right>,
            <MASLayoutConstraint:0x600002550420 TBView:0x10a05cd20.left == TBView:0x10a05c690.left>,
            <MASLayoutConstraint:0x6000025504e0 TBView:0x10a05cd20.right == TBView:0x10a05c690.right>,
            <NSLayoutConstraint:0x60000206af30 TBView:0x10a05c690.right == _NSSplitViewItemViewWrapper:0x15326cdd0.right>,
            <NSLayoutConstraint:0x60000206aee0 TBView:0x10a05c690.left == _NSSplitViewItemViewWrapper:0x15326cdd0.left>,
            <NSLayoutConstraint:0x60000204ceb0 _NSSplitViewItemViewWrapper:0x15326d170.left == _NSSplitViewItemViewWrapper:0x15326cdd0.right + 2>,
            <NSAutoresizingMaskLayoutConstraint:0x6000020407d0 TBSplitView:0x11dd65f70.(null) == 0>,
            <NSAutoresizingMaskLayoutConstraint:0x600002040820 NSView:0x15326d840.width == TBSplitView:0x11dd65f70.(null)>,
            <NSLayoutConstraint:0x6000023b5b80 NSView:0x15326d840.right == _NSSplitViewItemViewWrapper:0x15326d170.right>,
            <NSLayoutConstraint:0x6000023b5ae0 NSView:0x15326d840.left == _NSSplitViewItemViewWrapper:0x15326d170.left>,
            <NSLayoutConstraint:0x60000204d220 _NSSplitViewItemViewWrapper:0x153338ab0.left == _NSSplitViewItemViewWrapper:0x15326d170.right + 2>,
            <NSLayoutConstraint:0x600002044280 NSView:0x11ddcdd00.width >= 100>,
            <NSLayoutConstraint:0x600002044410 NSView:0x11ddcdd00.right == _NSSplitViewItemViewWrapper:0x153338ab0.right>,
            <NSLayoutConstraint:0x6000020443c0 NSView:0x11ddcdd00.left == _NSSplitViewItemViewWrapper:0x153338ab0.left>,
            <NSLayoutConstraint:0x60000204d090 _NSSplitViewItemViewWrapper:0x15326cdd0.left == TBSplitView:0x11dd65800.left>,
            <NSLayoutConstraint:0x60000204d310 TBSplitView:0x11dd65800.right == _NSSplitViewItemViewWrapper:0x153338ab0.right>,
            <NSAutoresizingMaskLayoutConstraint:0x6000020be120 NSView:0x15326cba0.width == 500>,
            <NSAutoresizingMaskLayoutConstraint:0x60000204d590 TBSplitView:0x11dd65800.(null) == 0>,
            <NSAutoresizingMaskLayoutConstraint:0x60000204d360 NSView:0x15326cba0.width == TBSplitView:0x11dd65800.(null)>,
            <MASLayoutConstraint:0x6000024abc60 TBOptionalHeaderView:0x153305360.left == TBView:0x109ffc810.left>,
            <MASLayoutConstraint:0x6000024abcc0 TBOptionalHeaderView:0x153305360.right == TBView:0x109ffc810.right>,
            <MASLayoutConstraint:0x6000024ab300 TBOptionalHeaderItemView:0x15322d6c0.width >= 58>,
            <MASLayoutConstraint:0x6000024ab000 NSStackView:0x153306b00.left == TBOptionalHeaderView:0x153305360.left>,
            <MASLayoutConstraint:0x6000024aac40 NSStackView:0x153306b00.right == TBOptionalHeaderView:0x153305360.right>,
            <NSLayoutConstraint:0x6000023a7610 TBOptionalHeaderItemView:0x153230560.left >= TBOptionalHeaderItemView:0x15322d6c0.right + 5>,
            <NSLayoutConstraint:0x6000023a7c50 NSStackView:0x153306b00.right >= TBOptionalHeaderItemView:0x153231d40.right + 5>,
            <NSLayoutConstraint:0x6000023a78e0 TBOptionalHeaderItemView:0x153231d40.left >= TBOptionalHeaderItemView:0x153230560.right + 5>,
            <MASLayoutConstraint:0x6000024ab480 TBOptionalHeaderItemView:0x153231d40.width >= 56>,
            <NSLayoutConstraint:0x6000023a7340 TBOptionalHeaderItemView:0x15322d6c0.left >= TBSystemButton:0x153233700.right + 5>,
            <NSLayoutConstraint:0x6000023a7110 TBSystemButton:0x153233700.left >= NSStackView:0x153306b00.left>,
            <MASLayoutConstraint:0x6000024ab1e0 TBSystemButton:0x153233700.width == 25>
        ].
        """
        let pattern = "<[\\w\\.]+:(?<ConstraintID>0x\\w+)\\s*(?<LeftItem>.*?):(?<LeftAddress>0x\\w+)\\.(?<LeftAnchor>\\w+)\\s+(==|>=|<=)\\s+(([\\d\\.]+)|((.*?):(0x\\w+))\\.(\\w+)(\\s+[+-]\\s+[\\d\\.]+)?)>"
        
        let regex = try NSRegularExpression(pattern: pattern)
        let textCheckingResults = regex.matches(in: sources, range: NSMakeRange(0, sources.count))
        
        let nssource = NSString(string: sources)
        for checkingResult in textCheckingResults {
            let nameRange = checkingResult.range(at: 1) // checkingResult.range(withName: "ConstraintID")
            if nameRange.location != NSNotFound {
                print(nssource.substring(with: nameRange))
            }
        }
    }
}

