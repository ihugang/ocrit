//
//  Extensions.swift
//  ocrit
//
//  Created by Hu Gang on 2025/4/20.
//


import AppKit

extension NSImage {
    func cgImage() -> CGImage? {
        var rect = NSRect(origin: .zero, size: size)
        return cgImage(forProposedRect: &rect, context: nil, hints: nil)
    }
}
