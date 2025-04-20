//
//  OCRBlock.swift
//  ocrit
//
//  Created by Hu Gang on 2025/4/20.
//


import Foundation
import CoreGraphics
import Vision 

struct OCRBoundingBox: Codable {
    let x: CGFloat
    let y: CGFloat
    let width: CGFloat
    let height: CGFloat

    func rectIn(size: CGSize) -> CGRect {
        let normalizedRect = CGRect(x: x, y: y, width: width, height: height)
        return VNImageRectForNormalizedRect(normalizedRect, Int(size.width), Int(size.height))
    }
}

struct OCRBlock: Codable {
    let text: String
    let boundingBox: OCRBoundingBox

    enum CodingKeys: String, CodingKey {
        case text = "text"
        case boundingBox = "boundingBox"
    }

    
}