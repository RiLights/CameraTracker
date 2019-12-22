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
import VideoToolbox

class CTSession: ARView, ARSessionDelegate, ObservableObject {
    
    var rec_state:Bool = false
    var tracking_state = ARCamera.TrackingState.notAvailable
    var seq_output_dir:URL?
    var data_output_dir:URL?
    var output_dir:URL?
    var track_data_file:String?
    var track_data_mat_file:String?
    var record_frames:Int = 0
    var total_frames:Float = 0
    var track_data:String = ""
    var track_data_mat:String = ""
    
    
    
    func remove_content(_ dir_url:URL){
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: dir_url,
                                                                    includingPropertiesForKeys: nil,
                                                                    options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
            for fileURL in fileURLs {
                try FileManager.default.removeItem(at: fileURL)
            }
        } catch  { print(error) }
    }
    
    func create_dirs(){
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let docURL = URL(string: documentsDirectory)!
        let data_path = docURL.appendingPathComponent("Data")
        let seq_path = data_path.appendingPathComponent("Sequence")
        
        if FileManager.default.fileExists(atPath: data_path.absoluteString) {
            remove_content(data_path)
        }
        if !FileManager.default.fileExists(atPath: data_path.absoluteString) {
            do {
                try FileManager.default.createDirectory(atPath: data_path.absoluteString, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error);
            }
        }
        
        if !FileManager.default.fileExists(atPath: seq_path.absoluteString) {
            do {
                try FileManager.default.createDirectory(atPath: seq_path.absoluteString, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error);
            }
        }
            
        if FileManager.default.fileExists(atPath: seq_path.absoluteString) {
            self.data_output_dir = data_path
            self.seq_output_dir = seq_path
            self.output_dir = docURL
        }
    }
    
    func get_orientation() -> UIImage.Orientation{
        if UIDevice.current.orientation.rawValue == 1{
            return UIImage.Orientation.right
        }
        else if UIDevice.current.orientation.rawValue == 3{
            return UIImage.Orientation.up
        }
        else{
            return UIImage.Orientation.right
        }
    }
//    func get_rotation(mat:simd_float4x4) -> SCNVector3 {
//        var x:Float = 0
//        var y:Float = 0
//        var z:Float = 0
//        x = asin(mat.columns.2.y)
//
//        if (CGFloat(x) < (CGFloat.pi / 2))
//        {
//            if (CGFloat(x) > (-(CGFloat.pi) / 2))
//            {
//                z = atan2(-mat.columns.0.y, mat.columns.1.y);
//                y = atan2(-mat.columns.2.x, mat.columns.2.z);
//            }
//            else
//            {
//                z = -atan2(-mat.columns.0.z, mat.columns.0.x);
//                y = 0;
//            }
//        }
//        else
//        {
//            z = atan2(-mat.columns.0.z, -mat.columns.0.x);
//            y = 0;
//        }
//        x = x * 180/Float(CGFloat.pi)
//        y = y * 180/Float(CGFloat.pi)
//        z = z * 180/Float(CGFloat.pi)
//        let rot = SCNVector3(x,y,z)
//        return rot
//    }
    
    func rad2deg(_ number: Float) -> Float {
        return number * 180 / .pi
    }
    func save_track_data(_ frame_num:Int,_ frame: ARFrame){
        let transform = frame.camera.transform
        //let d_rots = self.get_rotation(mat:transform)
        let rotx = self.rad2deg(frame.camera.eulerAngles.x) //* 180/Float(CGFloat.pi)
        let roty = self.rad2deg(frame.camera.eulerAngles.y) //* 180/Float(CGFloat.pi)
        let rotz = self.rad2deg(frame.camera.eulerAngles.z) //* 180/Float(CGFloat.pi)
        
        
        let position = SCNVector3(
            transform.columns.3.x,
            transform.columns.3.y,
            transform.columns.3.z
        )
        let str_data = String(frame_num) + "  " + String(position.x)+"  " + String(position.y)+"  " + String(position.z)+" "+String(rotx)+" "+" "+String(roty)+" "+String(rotz)+"\n"
        
        let str_mat = String(frame_num) + "  " + String(transform.columns.0.x) + "  " + String(transform.columns.0.y) + "  " + String(transform.columns.0.z) + " 0.0" + "  " + String(transform.columns.1.x) + "  " + String(transform.columns.1.y) + "  " + String(transform.columns.1.z) + " 0.0" + "  " + String(transform.columns.2.x) + "  " + String(transform.columns.2.y) + "  " + String(transform.columns.2.z) + " 0.0" + "  " + String(transform.columns.3.x) + "  " + String(transform.columns.3.y) + "  " + String(transform.columns.3.z) + " 1.0"+"\n"
        
//        let rotx_ = d_rots.x
//        let roty_ = d_rots.y
//        let rotz_ = d_rots.z
//
//        let str_data_matm = String(frame_num) + "  " + String(position.x)+"  " + String(position.y)+"  " + String(position.z)+" "+String(rotx_)+" "+" "+String(roty_)+" "+String(rotz_)+"\n"
        
        self.track_data.append(str_data)
        self.track_data_mat.append(str_mat)
        if (self.track_data_file != nil){
            FileManager.default.createFile(atPath: self.track_data_file!, contents: self.track_data.data(using: .ascii), attributes: nil)
            FileManager.default.createFile(atPath: self.track_data_mat_file!, contents: self.track_data_mat.data(using: .ascii), attributes: nil)
        }
        //print("debug tr:",transform.)
    }
    
    func save_image(_ frame_num:Int,_ frame: ARFrame){
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(frame.capturedImage,options:  nil,
                                         imageOut: &cgImage)
        
        let uiImage = UIImage(cgImage: cgImage!,scale: 1,
                              orientation: self.get_orientation())
        
        let data = uiImage.jpegData(compressionQuality: 0.55)

        if (self.seq_output_dir != nil){
            do {
                let j_file = seq_output_dir!.appendingPathComponent(String(frame_num)+"_fileName.jpg")
                let url:URL = URL(fileURLWithPath: j_file.absoluteString)
                try data!.write(to: url)
            } catch {
                print(error)
            }
        }
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState{
            case ARCamera.TrackingState.normal:
                g_env.track_state = 1
            default:
                g_env.track_state = 0
        }
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if g_env.rec_state{
            self.total_frames+=1
            let mod = Int(fmod(self.total_frames,2))
            if (mod != 0) {
                return
            }
            
            self.record_frames+=1

            
            DispatchQueue.global(qos:.background).async {
                self.save_track_data(self.record_frames,frame)
                self.save_image(self.record_frames,frame)
            }
        }
    }
    
    func start_record(){
        print("start_record")
        self.create_dirs()
        if (data_output_dir != nil){
            self.track_data_file = self.data_output_dir!.appendingPathComponent("track_data.txt").absoluteString
            self.track_data_mat_file = self.data_output_dir!.appendingPathComponent("track_data_mat.txt").absoluteString
        }
        self.record_frames = 0
        self.total_frames = 0
        self.track_data = ""
        g_env.data_dir_state = false
    }
    
    func stop_record(){
        print("stop_record")
        g_env.data_dir_state = check_data_dir()
    }

}
