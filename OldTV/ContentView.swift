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
                    let side = min(geo.size.width, geo.size.height)
                    
                    TimelineView(.animation) { _ in
                        Image("tokyo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: side - 2, height: side - 2)
                            .clipped()
                            .blur(radius: 0.5)
                            .opacity(0.4)
                            .overlay {
                                Text(date.formatted(date: .abbreviated, time: .omitted))
                                    .font(.custom("VT323-Regular", size: 25))
                                    .foregroundStyle(Color(#colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)))
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                    .padding(.leading, 60)
                                    .padding(.top, 60)
                            }
                            .layerEffect(
                                ShaderLibrary.oldTVShader(
                                    .float(-startDate.timeIntervalSinceNow),
                                    .float2(side, side)
                                ),
                                maxSampleOffset: .zero
                            )
                    }
                    
                    Image("old-tv")
                        .resizable()
                        .scaledToFit()
                        .frame(width: side, height: side)
                        .overlay(alignment: .bottomTrailing) {
                            DatePicker(selection: $date, in: ...Date.now, displayedComponents: .date) {
                            }
                            .accentColor(.gray)
                            .colorInvert()
                            .colorMultiply(.clear)
                        }
                    
                }
            }
            
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

extension Date: @retroactive RawRepresentable {
    
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

#Preview {
    ContentView()
}
