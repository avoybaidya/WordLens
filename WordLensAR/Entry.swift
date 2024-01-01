//
//  Entry.swift
//  iOS-echoAR-example
//
//  Copyright (C) echoAR, Inc. (dba "echo3D") 2018-2021.
//
//  Use subject to the Terms of Service available at https://www.echo3D.co/terms,
//  or another agreement between echoAR, Inc. and you, your company or other organization.
//
//  Unless expressly provided otherwise, the software provided under these Terms of Service
//  is made available strictly on an “AS IS” BASIS WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED.
//  Please review the Terms of Service for details on these and other terms and conditions.
//
//  Created by Alexander Kutner.
//

import Foundation
import SceneKit
import SceneKit.ModelIO

class Entry {
    var downloadURL: String?
    var entryID: String
    var serverURL: String
    var filename: String?
    var usdzID: String?
    var storageLocation: URL?
    var transforms = RemoteTransformation()
    var node: SCNNode?

    init(entryID: String, value: Any, serverURL: String) {
        self.entryID = entryID
        self.serverURL = serverURL
        parseData(value: value)
    }

    private func parseData(value: Any) {
        guard let dictionary = value as? [String: Any] else { return }
        
        for (key, value) in dictionary {
            switch key {
            case "hologram":
                parseHologram(value: value)
            case "additionalData":
                parseAdditionalData(value: value)
            default:
                break
            }
        }
        
        if let usdzID = usdzID {
            downloadURL = "\(serverURL)&file=\(usdzID)"
        }
    }
    
    // Other parsing methods remain the same
    
    func updateNode() {
        guard let node = node else {
            print("Model Error: \(getName())")
            return
        }
        node.scale = transforms.getScale()
        node.position = transforms.getPosition()
        node.eulerAngles = transforms.getRotation()
    }
    
    func parseWebSock(data: [String]) {
        // Implementation remains the same
    }
    
    func getName() -> String {
        return filename?
            .components(separatedBy: ".")
            .first?
            .replacingOccurrences(of: " ", with: "_") ?? ""
    }
    
    func loadScene(storageLocation: URL) throws -> SCNScene {
        self.storageLocation = storageLocation
        
        let scene = try SCNScene(url: storageLocation)
        scene.background.contents = UIColor.clear
        
        let name = getName()
        node = scene.rootNode.childNode(withName: name, recursively: true)
        updateNode()
        return scene
    }
    
    func downloadFile(completion: @escaping (Result<URL, Error>) -> Void) {
        guard let usdzID = usdzID, let downloadURLString = downloadURL, let downloadURL = URL(string: downloadURLString) else {
            completion(.failure(DownloadError.invalidURL))
            return
        }
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let savedURL = documentsDirectory.appendingPathComponent(usdzID)
        
        if FileManager.default.fileExists(atPath: savedURL.path) {
            print("Asset already cached")
            completion(.success(savedURL))
            return
        }
        
        FileManager.default.clearTmpDirectory()
        
        let downloadTask = URLSession.shared.downloadTask(with: downloadURL) { urlOrNil, _, errorOrNil in
            if let error = errorOrNil {
                completion(.failure(error))
                return
            }
            
            guard let fileURL = urlOrNil else {
                completion(.failure(DownloadError.noData))
                return
            }
            
            do {
                try FileManager.default.moveItem(at: fileURL, to: savedURL)
                completion(.success(savedURL))
            } catch {
                completion(.failure(error))
            }
        }
        
        downloadTask.resume()
    }
    
    enum DownloadError: Error {
        case invalidURL
        case noData
    }
}

extension FileManager {
    func clearTmpDirectory() {
        do {
            let tmpDirectory = try contentsOfDirectory(atPath: NSTemporaryDirectory())
            try tmpDirectory.forEach { file in
                let path = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(file).path
                try removeItem(atPath: path)
            }
        } catch {
            print(error)
        }
    }
}
