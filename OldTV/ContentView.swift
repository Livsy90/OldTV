//
//  ContentView.swift
//  OldTV
//
//  Created by Livsy on 24.01.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var startDate = Date()
    
    var body: some View {
        VStack {
            Spacer()
            
            GeometryReader { geo in
                ZStack {
                    TimelineView(.animation) { _ in
                        Image("street")
                            .resizable()
                            .scaledToFit()
                            .blur(radius: 1.2)
                            .layerEffect(
                                ShaderLibrary.oldTVShader(
                                    .float(-startDate.timeIntervalSinceNow),
                                    .float2(geo.size)
                                ),
                                maxSampleOffset: .zero
                            )
                            .opacity(0.4)
                        
                    }
                }
                .overlay(
                    ZStack {
                        Image("old-tv")
                            .resizable()
                            .scaledToFill()
                        
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                            .font(.custom("VT323-Regular", size: 20))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .padding(.vertical, 44)
                            .padding(.leading, 55)
                            .padding(.trailing, 150)
                            .layerEffect(
                                ShaderLibrary.oldTVShader(
                                    .float(-startDate.timeIntervalSinceNow),
                                    .float2(geo.size)
                                ),
                                maxSampleOffset: .zero
                            )
                    }
                )
            }
            .aspectRatio(1, contentMode: .fit)
            
            Spacer()
        }
        .background(
            ZStack {
                Color.black
                
                RadialGradient(stops: [
                    .init(color: .purple.opacity(0.2), location: 0),
                    .init(color: .black, location: 1)
                ], center: .center, startRadius: 10, endRadius: 1000)
            }
                .edgesIgnoringSafeArea(.all)
        )
    }
}
