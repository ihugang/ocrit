//  main.swift
//  ocrit
//
//  Created by Hu Gang on 2025/4/20.
//
// Author: Hu Gang
// Copyright (c) 2025 Hu Gang. All rights reserved.

import Foundation
import CoreGraphics
import AppKit

let arguments = CommandLine.arguments

func getArg(keys: [String]) -> String? {
    for key in keys {
        if let index = arguments.firstIndex(of: key), arguments.count > index + 1 {
            return arguments[index + 1]
        }
    }
    return nil
}

print("OCRTool - A command-line image text recognition utility powered by Vision framework")
print("--------------------------------------------------------------------------------------------")
print("Author: Hu Gang (https://github.com/ihugang)")
print("Copyright (c) 2025 Hu Gang (ihugang@gmail.com). All rights reserved.")

guard let inputPath = getArg(keys: ["--input", "-i"]) else {
   print("Usage: OCRTool --input <image> | -i <image>")
   print("              [--txt <out.txt> | -t <out.txt>]")
   print("              [--json <out.json> | -j <out.json>]")
   print("              [--draw <out.jpg> | -d <out.jpg>]")
   print("              [--enhanced | -e]")
   exit(1)
}

let txtPath = getArg(keys: ["--txt", "-t"])
let jsonPath = getArg(keys: ["--json", "-j"])
let drawPath = getArg(keys: ["--draw", "-d"])
let enhancedMode = arguments.contains("--enhanced") || arguments.contains("-e")

func groupBlocksByLine(blocks: [OCRBlock], yThreshold: CGFloat = 8) -> [[OCRBlock]] {
    guard let image = NSImage(contentsOfFile: inputPath),
          let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
        print("Failed to load image for line grouping")
        return []
    }
    let size = CGSize(width: cgImage.width, height: cgImage.height)

    let sorted = blocks.sorted {
        $0.boundingBox.rectIn(size: size).origin.y > $1.boundingBox.rectIn(size: size).origin.y
    }

    #if DEBUG
    print("Sorted blocks by Y:")
    for block in sorted {
        print("  y: \(block.boundingBox.rectIn(size: size).origin.y), text: \(block.text)")
    }
    #endif

    var grouped: [[OCRBlock]] = []

    for block in sorted {
        let y = block.boundingBox.rectIn(size: size).origin.y
        if let lastGroup = grouped.last,
           let lastY = lastGroup.first?.boundingBox.rectIn(size: size).origin.y,
           abs(y - lastY) <= yThreshold {
            grouped[grouped.count - 1].append(block)
            #if DEBUG
            print("  ↳ Appended to existing group (Δy = \(abs(y - lastY)))")
            #endif
        } else {
            grouped.append([block])
            #if DEBUG
            print("  ↳ Started new group")
            #endif
        }
    }

    // ✅ 对每组行内按 X 从左到右排序
    for i in grouped.indices {
        grouped[i].sort {
            $0.boundingBox.rectIn(size: size).origin.x < $1.boundingBox.rectIn(size: size).origin.x
        }
    }

    return grouped
}



let processor = OCRProcessor(imagePath: inputPath)
print("\nInput image: \(inputPath)")

processor.recognize { result in
   switch result {
      case .success(let blocks):
         let grouped = groupBlocksByLine(blocks: blocks)
         if let txtPath = txtPath {
            let textOutput = enhancedMode
                ? grouped.map { $0.map(\.text).joined(separator: " ") }.joined(separator: "\n")
                : blocks.map(\.text).joined(separator: "\n")
            try? textOutput.write(toFile: txtPath, atomically: true, encoding: .utf8)
         }
         if let jsonPath = jsonPath {
            try? processor.saveJSON(to: jsonPath, blocks: blocks)
         }
         if let drawPath = drawPath {
            try? processor.saveDrawnImage(to: drawPath, blocks: blocks)
         }
         if enhancedMode {
             print("------ Enhanced OCR Result ------")
             let enhancedText = grouped.map { $0.map(\.text).joined(separator: " ") }.joined(separator: "\n")
             print(enhancedText)
         } else {
             print("------ OCR Result ------")
             for block in blocks {
                 print(block.text)
             }
         }
         print("------------------------")
      case .failure(let error):
         print("Error: \(error.localizedDescription)")
   }
}
