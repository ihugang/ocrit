   //
   //  Package.swift
   //  ocrit
   //
   //  Created by Hu Gang on 2025/4/20.
   //


   // swift-tools-version:6.1
import PackageDescription

let package = Package(
   name: "ocrit",
   platforms: [
      .macOS(.v12)
   ],
   dependencies: [],
   targets: [
      .executableTarget(
         name: "ocrit",
         path: "./ocrit"
      )
   ]
)
