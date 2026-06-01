//
//  LUMAApp.swift
//  LUMA
//
//  Created by Kamakshi  on 04/04/26.
//

import SwiftUI

import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

import FirebaseAuth

@available(iOS 26.0, *)
@main
struct LUMAApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
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
