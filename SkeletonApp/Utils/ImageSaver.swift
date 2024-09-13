//
//  ImageSaver.swift
//  SkeletonApp
//
//  Created by zpier on 9/12/24.
//

import UIKit

struct ImageSaver {
    static func saveImage(_ image: UIImage, forKey key: String) -> Bool {
        if let data = image.jpegData(compressionQuality: 1.0) {
            let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(key + ".jpeg")
            do {
                try data.write(to: fileURL)
                return true
            } catch {
                print("Unable to save image: \(error)")
                return false
            }
        }
        return false
    }

    static func loadImage(forKey key: String) -> UIImage? {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(key + ".jpeg")
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    static func clearSavedImage() {
        UserDefaults.standard.removeObject(forKey: "savedImageKey")
    }
}

//for external use
func loadImage() -> UIImage? {
    if let key = UserDefaults.standard.string(forKey: "savedImageKey") {
        return ImageSaver.loadImage(forKey: key)
    }
    return nil
}
