//
//  KeyboardBrightnessApplication.swift
//  MacAppDemo
//
//  Created by Jack Xue on 2022/10/30.
//

import Cocoa

class KeyboardBrightnessApplication: NSApplication {
    
    var item:NSStatusItem!
    
    override init() {
        super.init()
//        let delegate = AppDelegate.init()
//        self.delegate = delegate
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            let statusBar = NSStatusBar.system

            self.item = statusBar.statusItem(withLength: NSStatusItem.squareLength)
            self.item.button?.title = "-"
            // useless target and action
//            self.item.button?.target = self
//            self.item.button?.action = #selector(self.actionTapMenu)
            
            let menu = NSMenu.init(title: "Title")
            menu.addItem(withTitle: "退出/Quit", action: #selector(self.actionQuit), keyEquivalent: "q")
            self.item.menu = menu
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sendEvent(_ event: NSEvent) {
        
        guard let key = Key(event: event) else {
            super.sendEvent(event)
            return
        }

        let extra = event.data1 & 0x0000FFFF
        let newData1 = Int(key.dual << 16) | extra

        guard
            let newEvent = NSEvent.otherEvent(
                with: event.type,
                location: event.locationInWindow,
                modifierFlags: event.modifierFlags.subtracting(Key.modifier),
                timestamp: event.timestamp,
                windowNumber: event.windowNumber,
                context: nil,
                subtype: event.subtype.rawValue,
                data1: newData1,
                data2: -1
            ),
            let cgEvent = newEvent.cgEvent
            else { return }

        cgEvent.post(tap: .cghidEventTap)
    }
    
    @objc private func actionQuit() {
        self.terminate(nil)
    }
    
}
