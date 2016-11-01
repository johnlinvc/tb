//
//  main.swift
//  tb
//
//  Created by Yu-Hsiang Lin on 10/31/16.
//  Copyright © 2016 jlvc. All rights reserved.
//

import Foundation
import AppKit
func shell(launchPath: String, arguments: [String]) -> String
{
    let task = Process()
    task.launchPath = launchPath
    task.arguments = arguments
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let stdout = FileHandle.standardOutput
    stdout.write(data)
    let output = String(data: data, encoding: String.Encoding.utf8)!
    if output.characters.count > 0 {
        //remove newline character.
        let lastIndex = output.index(before: output.endIndex)
        return output[output.startIndex ..< lastIndex]
    }
    return output
}

func bash(command: String, arguments: [String]) -> String {
    let env = ProcessInfo().environment
    if env["PWD"] == nil {
        var cmd = command
        for arg in arguments {
            cmd += " \(arg)"
        }
        return cmd
    }
    let whichPathForCommand = shell(launchPath: "/bin/bash", arguments: [ "-l", "-c", "which \(command)" ])
    return shell(launchPath: whichPathForCommand, arguments: arguments)
}
let subArgs = CommandLine.arguments.dropFirst()
let command = subArgs.first!
let arguments = Array(subArgs.dropFirst())
bash(command: command, arguments: arguments)
