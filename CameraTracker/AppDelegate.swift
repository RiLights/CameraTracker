//
//  AppDelegate.swift
//  CameraTracker
//
//  Created by Ostap on 28/11/19.
//  Copyright © 2019 Ostap. All rights reserved.
//

import UIKit
import SwiftUI

class CameraDataFlow: ObservableObject {
    @Published var track_state = 0
    @Published var rec_state = false
    @Published var data_dir_state = false
    @Published var frame_label:String = "Frame: 0000"
}

var g_env = CameraDataFlow()

func check_data_dir() -> Bool{
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    let docURL = URL(string: documentsDirectory)!
    let data_path = docURL.appendingPathComponent("Data")
    if FileManager.default.fileExists(atPath: data_path.absoluteString) {
        return true
    }
    else {
        return false
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        //UIApplication.willResignActiveNotification
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()
        // Use a UIHostingController as window root view controller.
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIHostingController(rootView: contentView.environmentObject(g_env))
        self.window = window
        window.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        g_env.rec_state = false
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        //self.window?. = false
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        //g_env.rec_state = false
        g_env.data_dir_state = check_data_dir()
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        //g_env.rec_state = false
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

}

