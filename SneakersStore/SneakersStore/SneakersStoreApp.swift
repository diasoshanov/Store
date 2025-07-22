//
//  SneakersStoreApp.swift
//  SneakersStore
//
//  Created by Диас Рошанов on 12.07.2025.
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

@main
struct SneakersStoreApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @StateObject private var authViewModel = AuthViewModel()

  var body: some Scene {
    WindowGroup {
      if authViewModel.isAuthenticated {
        MainTabView()
          .environmentObject(authViewModel)
      } else {
        OnboardingView()
          .environmentObject(authViewModel)
      }
    }
  }
}

