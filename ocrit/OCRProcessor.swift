//
//  OCRProcessor.swift
//  ocrit
//
//  Created by Hu Gang on 2025/4/20.
//


import Foundation
import Vision
import AppKit



class OCRProcessor {
    let imagePath: String
    private var image: NSImage?

    init(imagePath: String) {
        self.imagePath = imagePath
        self.image = NSImage(contentsOfFile: imagePath)
    }

    func recognize(completion: @escaping (Result<[OCRBlock], Error>) -> Void) {
        guard let cgImage = image?.cgImage() else {
            completion(.failure(NSError(domain: "OCR", code: 0, userInfo: [NSLocalizedDescriptionKey: "无法加载图片"])))
            return
        }

        let request = VNRecognizeTextRequest { req, err in
            if let err = err {
                completion(.failure(err))
                return
            }

            guard let observations = req.results as? [VNRecognizedTextObservation] else {
                completion(.success([]))
                return
            }

            let blocks: [OCRBlock] = observations.compactMap { obs in
                guard let best = obs.topCandidates(1).first else { return nil }
                return OCRBlock(text: best.string, boundingBox: OCRBoundingBox(
                    x: obs.boundingBox.origin.x,
                    y: obs.boundingBox.origin.y,
                    width: obs.boundingBox.size.width,
                    height: obs.boundingBox.size.height
                ))
            }

            completion(.success(blocks))
        }

        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        request.recognitionLanguages = ["zh-Hans", "en-US"]

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
    }

    func saveTXT(to path: String, blocks: [OCRBlock]) throws {
        let lines = blocks.map { $0.text }
        try lines.joined(separator: "\n").write(toFile: path, atomically: true, encoding: .utf8)
    }

    func saveJSON(to path: String, blocks: [OCRBlock]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(blocks)
        try data.write(to: URL(fileURLWithPath: path))
    }

    func saveDrawnImage(to path: String, blocks: [OCRBlock]) throws {
        guard let nsImage = image, let cgImage = nsImage.cgImage() else { return }
        let size = CGSize(width: cgImage.width, height: cgImage.height)

        let rep = NSBitmapImageRep(cgImage: cgImage)
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)

        for block in blocks {
            let rect = block.boundingBox.rectIn(size: size)
            NSColor.red.set()
            NSBezierPath(rect: rect).stroke()
        }

        NSGraphicsContext.restoreGraphicsState()

        let data = rep.representation(using: .jpeg, properties: [:])
        try data?.write(to: URL(fileURLWithPath: path))
    }
}
