//
//  ContentView.swift
//  CameraTracker
//
//  Created by Ostap on 28/11/19.
//  Copyright © 2019 Ostap. All rights reserved.
//

import SwiftUI
import RealityKit
import ARKit


struct ContentView : View {
    @State var test:String = ""
    
    @State var rec:Bool = false
    @EnvironmentObject var g_data: CameraDataFlow
    
    var body: some View {
        ZStack(){
            ARViewContainer(test:$test,rec:$rec).edgesIgnoringSafeArea(.all)
                
            VStack(alignment: .center){
                ZStack(alignment: .center){
                    RoundedRectangle(cornerRadius: 10)
                        //.cornerRadius(5)
                        .fill(Color.black)
                        .frame(width: 150, height: 60)
                        //.blur(radius: 5, opaque: false)
                        .opacity(0.5)
                    VStack(alignment: .center){
                        Text("Tracking State:")
                        Text(g_data.track_state == 1 ? "Ready" : "Insufficient")
                    }
                    .foregroundColor(.white)
                }
                Spacer()
            }
            .edgesIgnoringSafeArea(.all)
            .padding(.top,0.5)
            
            VStack(alignment: .center){
                Spacer()
                ZStack(alignment: .bottom){
                    
                    Rectangle()
                        .fill(Color.black)
                        .frame(height: 110)
                        .opacity(0.5)
                        .padding(.bottom, -40)
                    
                    HStack{
                        Spacer()

                        Button(action: {
                            if (self.g_data.track_state == 1){
                                self.rec = !self.rec
                                self.g_data.rec_state = self.rec
                            }
                        }){
                            RoundedRectangle(cornerRadius: self.g_data.rec_state ? 4 : 40)
                                .foregroundColor(self.g_data.rec_state ? .red : .white)
                                .padding(self.g_data.rec_state ? 15 : 3)
                                .overlay(
                                    Circle()
                                        .stroke(g_data.track_state == 1 ? Color.white : Color.gray, lineWidth: 2)
                                )
                                .animation(.easeInOut(duration: 0.3))
                        }
                            .frame(width: 50, height: 50)
                            .padding(.horizontal,20)
                            .edgesIgnoringSafeArea(.all)
                            .padding(.bottom,7)
                        Spacer()
                    }
                }

            }
        }
            
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var test:String
    @Binding var rec:Bool
    var defaultConfiguration: ARWorldTrackingConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        let supportedFormats = ARWorldTrackingConfiguration.supportedVideoFormats

        configuration.isAutoFocusEnabled = false
        configuration.videoFormat = supportedFormats.last!
        for format: ARConfiguration.VideoFormat in supportedFormats {
            if (format.imageResolution.width == 720 ||
                format.imageResolution.height == 720 ){
                configuration.videoFormat = format
            }
        }

        return configuration
    }
    
    var arView:CTSession?
    
    
    func makeUIView(context: Context) -> CTSession {
        
        let arView:CTSession = CTSession(frame: .zero)
        
        arView.debugOptions = [.showFeaturePoints,.showWorldOrigin]
        
        arView.session.delegate = arView
        arView.session.run(self.defaultConfiguration)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: CTSession, context: Context) {
        let state = UIApplication.shared.applicationState
        uiView.session.run(self.defaultConfiguration)

        if rec && (state.rawValue == 0){
            uiView.start_record()
        }
        else{
            uiView.stop_record()
        }
    }
}
