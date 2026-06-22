//
//  LUMAApp.swift
//  LUMA
//
//  Created by Kamakshi  on 04/04/26.
//

import SwiftUI
import SwiftData

@available(iOS 26.0, *)
@main
struct LUMAApp: App {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false

    var body: some Scene {
        WindowGroup {
            LaunchView()
        }
        .modelContainer(for: SymptomLog.self)
    }
}
