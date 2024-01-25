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
                        Image("tokyo")
                            .resizable()
                            .scaledToFit()
                            .blur(radius: 0.5)
                            .layerEffect(
                                ShaderLibrary.oldTVShader(
                                    .float(-startDate.timeIntervalSinceNow),
                                    .float2(geo.size)
                                ),
                                maxSampleOffset: .zero
                            )
                            .opacity(0.4)
                        
                    }
                    
                    Image("old-tv")
                        .resizable()
                        .scaledToFit()
                        .padding(.bottom, -66)
                }
                .overlay(
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                        .font(.custom("VT323-Regular", size: 20))
                        .foregroundStyle(Color(#colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .padding(.vertical, 44)
                        .padding(.leading, 65)
                        .padding(.trailing, 150)
                        .layerEffect(
                            ShaderLibrary.oldTVShader(
                                .float(-startDate.timeIntervalSinceNow),
                                .float2(geo.size)
                            ),
                            maxSampleOffset: .zero
                        )
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
