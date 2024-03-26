//
//  File.swift
//  
//
//  Created by Jo on 2022/11/12.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public protocol SizeDetectableCollectionLayoutDelegate: NSObjectProtocol {
    func collectionLayout(_ collectionLayout: NSCollectionViewLayout, contentSizeDidChangeTo contentSize: NSSize)
}

private extension NSObject.AssociationKey {
    static let detectableInfo = NSObject.AssociationKey(rawValue: "com.auu.detectableInfo.cacheKey")
}

public extension NSCollectionViewLayout {
    enum AutoLayoutSide {
        case width
        case height
    }
    
    private class DetectableInfo {
        var layoutConstraint: NSLayoutConstraint?
        weak var delegate: SizeDetectableCollectionLayoutDelegate?
        var autoLayoutSide: AutoLayoutSide?
    }
    
    private var detectedInfo: DetectableInfo? {
        set {
            setAssociatedObject(newValue, for: .detectableInfo, policy: .retainNonatomic)
        }
        get {
            return associatedObject(for: .detectableInfo)
        }
    }
    
    convenience init(sizeDetectedDelegate: SizeDetectableCollectionLayoutDelegate?, autoLayoutSide: AutoLayoutSide? = .height) {
        self.init()
        
        let infoCache = DetectableInfo()
        infoCache.delegate = sizeDetectedDelegate
        infoCache.autoLayoutSide = autoLayoutSide
        
        self.detectedInfo = infoCache
    }
    
    fileprivate func inspectPrepareAction() {
        guard let detectedInfo = detectedInfo else { return }
        
        if detectedInfo.autoLayoutSide == .width {
            if detectedInfo.layoutConstraint == nil {
                detectedInfo.layoutConstraint = collectionView?.widthAnchor.constraint(equalToConstant: collectionViewContentSize.width)
                detectedInfo.layoutConstraint?.isActive = true
            }
            
            detectedInfo.layoutConstraint?.constant = collectionViewContentSize.width
        } else if detectedInfo.autoLayoutSide == .height {
            if detectedInfo.layoutConstraint == nil {
                detectedInfo.layoutConstraint = collectionView?.heightAnchor.constraint(equalToConstant: collectionViewContentSize.height)
                detectedInfo.layoutConstraint?.isActive = true
            }
            
            detectedInfo.layoutConstraint?.constant = collectionViewContentSize.height
        }
        
        detectedInfo.delegate?.collectionLayout(self, contentSizeDidChangeTo: collectionViewContentSize)
    }
}

public extension NSCollectionViewGridLayout {
    class SizeDetectableLayout: NSCollectionViewGridLayout {
        public override func prepare() {
            super.prepare()
            inspectPrepareAction()
        }
    }
}

public extension NSCollectionViewFlowLayout {
    class SizeDetectableLayout: NSCollectionViewFlowLayout {
        public override func prepare() {
            super.prepare()
            inspectPrepareAction()
        }
    }
}

@available(macOS 10.15, *)
public extension NSCollectionViewCompositionalLayout {
    class SizeDetectableLayout: NSCollectionViewCompositionalLayout {
        public override func prepare() {
            super.prepare()
            inspectPrepareAction()
        }
    }
}

@available(macOS 10.15, *)
public extension NSCollectionViewTransitionLayout {
    class SizeDetectableLayout: NSCollectionViewTransitionLayout {
        public override func prepare() {
            super.prepare()
            inspectPrepareAction()
        }
    }
}


#endif
