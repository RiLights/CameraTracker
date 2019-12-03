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
    var test:CGFloat = 4
    //@State private var test:CGFloat = 40
    //@State private var pad:CGFloat = 3
    @State var rec_test:Int = 0
    
    var rec:Bool = false
    //@Binding var rec:Int = 0
    @EnvironmentObject var sett: UserS
    //@ObservedObject var ct_session = CTSession()
    
    var body: some View {
        ZStack(){
            ARViewContainer(rec:$rec_test).edgesIgnoringSafeArea(.all)
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
                        Text("Stabel")
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
                        Text(String(sett.score))
                        Button(action: {
                            print("button pressed:"+String(UIDevice.current.orientation.rawValue))
                            //self.rec = !self.rec
                        }){
                            RoundedRectangle(cornerRadius: self.rec ? 4 : 40)
                                //.size(CGSize(width: 50, height: 50))
                                .foregroundColor(self.rec ? .red : .white)
                                .padding(self.rec ? 15 : 3)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                )
                                .animation(.easeInOut(duration: 0.3))
                        }
                            .frame(width: 50, height: 50)
                            .padding(.horizontal,20)

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
    
    @Binding var rec:Int
    
    func makeUIView(context: Context) -> CTSession {
        
        let arView:CTSession = CTSession(frame: .zero)
        
        // Load the "Box" scene from the "Experience" Reality File
        //let boxAnchor = try! Experience.loadBox()
        
        // Add the box anchor to the scene
        //arView.scene.anchors.append(boxAnchor)
        
        arView.debugOptions = [.showFeaturePoints,.showWorldOrigin]
        
        arView.session.delegate = arView
        //rec = arView.test_bind
        
        return arView
        
    }
    
    func updateUIView(_ uiView: CTSession, context: Context) {}
    
}
