//
//  DataManager.swift
//  SkeletonApp
//
//  Created by zpier on 9/12/24.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    
    func clearData() {
        ImageSaver.clearSavedImage()
        UserDefaults.standard.removeObject(forKey: "questionnaireResults")
        UserDefaults.standard.removeObject(forKey: "isSubscribed")
    }
}
