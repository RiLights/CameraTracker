//
//  ContentView.swift
//  CameraTracker
//
//  Created by Ostap on 28/11/19.
//  Copyright © 2019 Ostap. All rights reserved.
//

import SwiftUI
import RealityKit


struct ContentView : View {
    @State var rec_test:Int = 0
    
    @State var rec:Bool = false
    @EnvironmentObject var g_data: CameraDataFlow
    
    var body: some View {
        ZStack(){
            ARViewContainer().edgesIgnoringSafeArea(.all)
                
            //ARViewContainer().tracking_state
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
                        Text(String(self.g_data.rec_state))
                        Button(action: {
                            //print("button pressed:"+String(UIDevice.current.orientation.rawValue))
                            if (self.g_data.track_state == 1){
                                self.rec = !self.rec
                                self.g_data.rec_state = self.rec
                            }
                        }){
                            RoundedRectangle(cornerRadius: self.rec ? 4 : 40)
                                //.size(CGSize(width: 50, height: 50))
                                .foregroundColor(self.rec ? .red : .white)
                                .padding(self.rec ? 15 : 3)
                                .overlay(
                                    Circle()
                                        .stroke(g_data.track_state == 1 ? Color.white : Color.gray, lineWidth: 2)
                                )
                                .animation(.easeInOut(duration: 0.3))
                        }
                            .frame(width: 50, height: 50)
                            .padding(.horizontal,20)
                        //.foregroundColor(.green)

                        Button(action: {
                            print("Make Archive")
                        }){
                            Text("Make Archive")
                                .fontWeight(.bold)
                                .font(.subheadline)
                                .padding(7)
                                .background(Color.blue)
                                .cornerRadius(15)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal,10)
                            
                    }
                }
//                ZStack(alignment: .bottom){
//
//
////                    Button(action: {
////                      print("button pressed")
////
////                    }){
////                        RoundedRectangle(cornerRadius: 10)
////                        .size(CGSize(width: 50, height: 50))
////                            .foregroundColor(.red)
////                    }
//                }
            }
        }
            
        //return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    //@Binding var rec:Bool
    
    //var arView:CTSession
    
    
    func makeUIView(context: Context) -> CTSession {
        
        let arView:CTSession = CTSession(frame: .zero)
        
        arView.create_dirs()
        arView.debugOptions = [.showFeaturePoints,.showWorldOrigin]
        
        arView.session.delegate = arView
        
        return arView
        
    }
    
//    func record(state:Bool){
//        print("debug rec",String(rec))
////        if state{
////            arView.start_record()
////        }
////        else{
////            arView.stop_record()
////        }
//    }
    
    func updateUIView(_ uiView: CTSession, context: Context) {}
    
}
