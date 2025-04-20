//  main.swift
//  ocrit
//
//  Created by Hu Gang on 2025/4/20.
//
// Author: Hu Gang
// Copyright (c) 2025 Hu Gang. All rights reserved.

import Foundation

let arguments = CommandLine.arguments

func getArg(_ key: String) -> String? {
   guard let index = arguments.firstIndex(of: key), arguments.count > index + 1 else {
      return nil
   }
   return arguments[index + 1]
}

print("OCRTool - A command-line image text recognition utility powered by Vision framework")
print("--------------------------------------------------------------------------------------------")
print("Author: Hu Gang (https://github.com/ihugang)")
print("Copyright (c) 2025 Hu Gang (ihugang@gmail.com). All rights reserved.")

guard let inputPath = getArg("--input") else {
   print("Usage: OCRTool --input <image> [--txt <out.txt>] [--json <out.json>] [--draw <out.jpg>]")
   exit(1)
}

let txtPath = getArg("--txt")
let jsonPath = getArg("--json")
let drawPath = getArg("--draw")

let processor = OCRProcessor(imagePath: inputPath)
print("\nInput image: \(inputPath)")

processor.recognize { result in
   switch result {
      case .success(let blocks):
         if let txtPath = txtPath {
            try? processor.saveTXT(to: txtPath, blocks: blocks)
         }
         if let jsonPath = jsonPath {
            try? processor.saveJSON(to: jsonPath, blocks: blocks)
         }
         if let drawPath = drawPath {
            try? processor.saveDrawnImage(to: drawPath, blocks: blocks)
         }
         print("------ OCR Result ------")
         for block in blocks {
             print(block.text)
         }
         print("------------------------")
      case .failure(let error):
         print("Error: \(error.localizedDescription)")
   }
}
