//
//  Session.swift
//  CameraTracker
//
//  Created by Ostap on 30/11/19.
//  Copyright © 2019 Ostap. All rights reserved.
//

import ARKit
import RealityKit
import Combine

let pub = PassthroughSubject<Int,Never>()
let sub = pub.sink { value in print("tt \(value)")}
var t = 1
let nc = NotificationCenter.default
//pub.send(6)

class CTSession: ARView, ARSessionDelegate, ObservableObject {
    
    //@EnvironmentObject var settings: UserS
    //var test_bind:Int = 0
    @Published var test_bind:Int = 1
    //@Binding var rec:Bool
    //@Binding var currentPage: Int
    var tracking_state = ARCamera.TrackingState.notAvailable
    
    
    //nc.post(name: Notification.Name("UserLoggedIn"), object: nil)
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        //print("debug session tracking state",camera.trackingState)
        self.tracking_state = camera.trackingState
        //test_bind+=1
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        //print("tt")
        //nc.post(name: Notification.Name("UserLoggedIn"), object: nil)
        //self.rec = true
        //settings.score =
        //test_bind+=1
        //settings.score = 5
        sett.score += 1
    }
    

}

//let sub = pub.sink { value in print("debug \(value)")}
