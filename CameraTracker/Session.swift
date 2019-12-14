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

class CTSession: ARView, ARSessionDelegate, ObservableObject {
    
    var rec_state:Bool = false
    var tracking_state = ARCamera.TrackingState.notAvailable
    var seq_output_dir:URL?
    var data_output_dir:URL?
    var output_dir:URL?
    
    func create_dirs(){
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let docURL = URL(string: documentsDirectory)!
        let dataPath = docURL.appendingPathComponent("Sequence")
        if !FileManager.default.fileExists(atPath: dataPath.absoluteString) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath.absoluteString, withIntermediateDirectories: true, attributes: nil)
                self.seq_output_dir = dataPath
                self.output_dir = docURL
            } catch {
                print(error);
            }
        }
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        //print("debug session tracking state",camera.trackingState)
        //self.tracking_state = camera.trackingState
        switch camera.trackingState{
            case ARCamera.TrackingState.normal:
                g_env.track_state = 1
            default:
                g_env.track_state = 0
        }
        //test_bind+=1
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        //print("tt")
        //nc.post(name: Notification.Name("UserLoggedIn"), object: nil)
        //self.rec = true
        //settings.score =
        //test_bind+=1
        //settings.score = 5
        if g_env.rec_state{
            if (self.output_dir != nil){
                print("recording")
//                FileManager.default.createFile(atPath: self.path!, contents: ss.data(using: .ascii), attributes: nil)
            }
        }
        //g_env.track_state += 1
    }
    
    func start_record(){
        self.rec_state = true
    }
    
    func stop_record(){
        self.rec_state = false
    }

}

//let sub = pub.sink { value in print("debug \(value)")}
