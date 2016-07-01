//
//  AppDelegate.swift
//  CrashLogTool
//
//  Created by 龚杰洪 on 16/7/1.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    @IBOutlet weak var armv7CheckBox: NSButton!
    @IBOutlet weak var armv7sCheckBox: NSButton!
    @IBOutlet weak var arm64CheckBox: NSButton!
    @IBOutlet weak var addressTextFiled: NSTextField!
    @IBOutlet weak var dsymPathTextField: NSTextField!
    @IBOutlet var outputTextView: NSTextView!
    
    var CPUType: String = "armv7"
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    
    @IBAction func checkBoxDicChecked(sender: NSButton) {
        if (sender == armv7CheckBox) {
            CPUType = "armv7"
        }
        else if (sender == armv7sCheckBox) {
            CPUType = "armv7s"
        }
        else if (sender == arm64CheckBox) {
            CPUType = "arm64"
        }
    }

    @IBAction func startCheck(sender: NSButton) {
        let task = NSTask()
        task.launchPath = "/usr/bin/dwarfdump"
        task.arguments = ["--lookup", addressTextFiled.stringValue, "--arch=\(CPUType)", dsymPathTextField.stringValue]
        let readPipe = NSPipe()
        let errorPipe = NSPipe()
        task.standardOutput = readPipe
        task.standardError = errorPipe
        
        let readHandle = readPipe.fileHandleForReading
        let errorHandle = errorPipe.fileHandleForReading
        
        task.launch()
        
        
        let data = readHandle.readDataToEndOfFile()
        if (data.length == 0) {
            let errorData = errorHandle.readDataToEndOfFile()
            let errorString = String(data: errorData, encoding: NSUTF8StringEncoding)
            outputTextView.string = errorString
            return
        }
        
        let outputString = String(data: data, encoding: NSUTF8StringEncoding)
        outputTextView.string = outputString
        
    }
}

