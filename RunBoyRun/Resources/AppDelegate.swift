//
//  AppDelegate.swift
//  RunBoyRun
//
//  Created by Dimo Popov on 10/06/2021.
//
let programString = """
    [
        {
            "name": "Example 1",
            "description": "This training program will make you feel better. I promise ;)",
            "sections": [
                {"1": 3.5},
                {"2": 3.0},
                {"5": 8.4},
                {"1": 2.0},
                {"4": 4.0}
            ]
        },
        {
            "name": "Example 2",
            "description": "This training program will make you feel better. I promise ;)",
            "sections": [
                {"1": 3.5},
                {"2": 3.0},
                {"5": 8.4},
                {"1": 2.0},
                {"4": 4.0}
            ]
        }
    ]
"""

import UIKit
extension Notification.Name {
    static let UserSet = Notification.Name("UserSet")
}
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let jsonData = jsonString.data(using: .utf8)
    let jsonProgram = programString.data(using: .utf8)
    let decoder = JSONDecoder()
    let playURI = "spotify:track:4tmIJTSnuvskqsPwB5RCqx"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        let requestedScopes: SPTScope = [.appRemoteControl]
//        self.sessionManager.initiateSession(with: requestedScopes, options: .default)
//        configureation.playerResume()
//        let asd = SpotifyManager.init()
//       print(asd.configuration.clientID)
//        print(asd.configuration.redirectURL)
//
//        asd.configuration.tokenSwapURL =  URL(string: "localhost:9292/api/token")
//        print(asd.isPlaying)
//        asd.playerResume()
//        print(SpotifyManager.sharedInstance.appRemote.connectionParameters.accessToken)
        
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        print(url)
        
        // Handle the Spotify login session scheme
        if (!SpotifyManager.sharedInstance.spotifySessionManager.application(app, open: url, options: options)) {
            // else resort to manual parsing
            let scheme = url.scheme!
            let message = url.host?.removingPercentEncoding!
            if (scheme == "RunBoyRun" && message == "signin"){
                let userId = url.lastPathComponent
                UserDefaults.standard.set(userId, forKey: "userId")
                NotificationCenter.default.post(name: NSNotification.Name.UserSet, object: nil, userInfo: nil)
                print("NEW USER ID SET:", userId)
            }
        }
        return true
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    

}


