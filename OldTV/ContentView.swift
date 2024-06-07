//
//  ContentView.swift
//  OldTV
//
//  Created by Livsy on 24.01.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var startDate = Date()
    @AppStorage("date") var date = Date()
    
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
                    
                    ZStack {
                        Image("old-tv")
                            .resizable()
                            .scaledToFit()
                            .padding(.bottom, -66)
                        
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                DatePicker(selection: $date, in: ...Date.now, displayedComponents: .date) {
                                    EmptyView()
                                }
                                    .accentColor(.gray)
                                    .colorInvert()
                                    .colorMultiply(.clear)
                            }
                        }
                        .padding(.bottom, -13)
                    }
                }
                .overlay(
                    Text(date.formatted(date: .abbreviated, time: .omitted))
                        .font(.custom("VT323-Regular", size: 25))
                        .foregroundStyle(Color(#colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .padding(.leading, 65)
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

extension Date: RawRepresentable {
    
    public typealias RawValue = String
    
    public init?(rawValue: RawValue) {
        guard let data = rawValue.data(using: .utf8),
              let date = try? JSONDecoder().decode(Date.self, from: data) else {
            return nil
        }
        
        self = date
    }
    
    public var rawValue: RawValue{
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data,encoding: .utf8) else {
            return ""
        }
        
        return result
    }
    
}
