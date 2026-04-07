//
//  LUMAApp.swift
//  LUMA
//
//  Created by Kamakshi  on 04/04/26.
//

import SwiftUI

@available(iOS 26.0, *)
@main
struct LUMAApp: App {
    
    @StateObject private var symptomStore = SymptomStore()
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false

    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(symptomStore)
                .preferredColorScheme(.light)
        }
    }
}
