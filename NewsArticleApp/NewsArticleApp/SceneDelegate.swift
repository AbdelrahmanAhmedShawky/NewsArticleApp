//
//  SceneDelegate.swift
//  NewsArticleApp
//
//  Created by Abdelrahman Ahmed Shawky  on 26/03/2021.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create the SwiftUI view that provides the window contents.
        
        let contentView = StartView()
        let settings = UserSettings()
        
        if UserDefaults.standard.bool(forKey: "isSelected") {
            settings.isSelected = true
        } else {
            settings.isSelected = false
        }
        
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView.environmentObject(settings))
            self.window = window
            window.makeKeyAndVisible()
        }
        
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    func sceneDidEnterBackground(_ scene: UIScene) {
        CoreDataHelper.shared.saveContext()
    }


}

class UserSettings: ObservableObject {
    
    @Published var isSelected : Bool = false
}

struct StartView: View {
    
    @EnvironmentObject var settings: UserSettings
    let context = CoreDataHelper.shared.persistentContainer.viewContext
    var body: some View {
                
        if settings.isSelected {
            return AnyView(NewsListView() .environment(\.managedObjectContext, context))
        } else {
            return AnyView(SelectCountriesAndCategoriesView())
        }
    }
}


