//
//  QuestionnaireResults.swift
//  SkeletonApp
//
//  Created by zpier on 9/12/24.
//

import Foundation

struct QuestionnaireResults: Codable {
    var answer1: String
    var answer2: String

    // Save the results to UserDefaults
    func save() {
        if let encodedData = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encodedData, forKey: "questionnaireResults")
        }
    }

    // Load the results from UserDefaults
    static func load() -> QuestionnaireResults? {
        if let savedData = UserDefaults.standard.data(forKey: "questionnaireResults"),
           let decodedData = try? JSONDecoder().decode(QuestionnaireResults.self, from: savedData) {
            return decodedData
        }
        return nil
    }
}
