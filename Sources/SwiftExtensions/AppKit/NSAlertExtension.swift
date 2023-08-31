//
//  File.swift
//  
//
//  Created by Jo on 2022/10/28.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public extension NSAlert {
    
    /// Create a NSAlert using the given params.
    /// - Parameters:
    ///   - informativeText: The alert's informative text.
    ///   - messageText: The alert's title.
    ///   - alertStyle: Indicates the alert’s severity level.
    convenience init(
        informativeText: String,
        messageText: String? = nil,
        alertStyle: NSAlert.Style = .informational) {

        self.init()
        
        if let messageText = messageText {
            self.messageText = messageText
        }
        
        self.informativeText = informativeText
        self.alertStyle = alertStyle
    }
    
    /// Display a alert using the given params.
    /// ---------------------------------
    /// |          message text         |
    /// | informative text, the alert's |
    /// | informative text.             |
    /// |           Confirmed           |
    /// ---------------------------------
    /// - Parameters:
    ///   - informativeText: The message need to be confirmed.
    ///   - messageText: The alert title.
    ///   - alertStyle: The alert style.
    /// - Returns: Confirmed result.
    @discardableResult static func alert(
        informativeText: String,
        messageText: String? = nil,
        alertStyle: NSAlert.Style = .informational
    ) -> NSApplication.ModalResponse {
        
        return NSAlert(
            informativeText: informativeText,
            messageText: messageText,
            alertStyle: alertStyle
        ).runModal()
    }
    
    /// Confirm given infomation
    /// -----------------------------------------
    /// |              message text             |
    /// | informative text, the message need to |
    /// | be confirmed.                         |
    /// |          Cancel      Confirmed        |
    /// -----------------------------------------
    /// - Parameters:
    ///   - informativeText: The message need to be confirmed.
    ///   - messageText: The alert title.
    ///   - alertStyle: The alert style.
    ///   - confirmButtonTitle: The confirmed button title.
    ///   - cancelButtnTitle: The cancel button title.
    /// - Returns: Confirmed result.
    static func confirmed(
        informativeText: String,
        messageText: String? = nil,
        alertStyle: NSAlert.Style = .informational,
        confirmButtonTitle: String? = nil,
        cancelButtnTitle: String? = nil
    ) -> Bool {
        
        let alert = NSAlert(informativeText: informativeText, messageText: messageText, alertStyle: alertStyle)
        alert.addButton(withTitle: confirmButtonTitle ?? "Confirm")
        alert.addButton(withTitle: cancelButtnTitle  ?? "Cancel")
        alert.window.titlebarAppearsTransparent = true
        return alert.runModal() == .alertFirstButtonReturn
    }
    
    /// Safely pop up a modal window, if current thread is not the main thread,
    /// it will switches to the main thread automatically.
    func saftyRunModal() {
        if Thread.current.isMainThread {
            runModal()
        } else {
            DispatchQueue.main.async {
                self.runModal()
            }
        }
    }
    
    func hideActionButtons() {
        addButton(withTitle: "").isHidden = true
    }
}

#endif
