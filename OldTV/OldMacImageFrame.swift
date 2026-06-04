//
//  OldMacImageFrame.swift
//  OldTV
//
//  Created by Artem Mir on 01.06.26.
//


import SwiftUI

struct OldMacImageFrame<Content: View>: View {
    @State private var startDate = Date()

    private let content: Content

    init(@ViewBuilder content: () -> Content = { EmptyView() }) {
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            let width = min(geometry.size.width, geometry.size.height * 0.82)
            let height = width / 0.82
            let xOffset = (geometry.size.width - width) / 2
            let yOffset = (geometry.size.height - height) / 2

            ZStack {
                macBody(width: width, height: height)
                screenRecess(width: width, height: height)
                screenContent(width: width, height: height)
                screenGlass(width: width, height: height)
                diskDrive(width: width, height: height)
                appleBadge(width: width, height: height)
                lowerShadow(width: width, height: height)
            }
            .frame(width: width, height: height)
            .offset(x: xOffset, y: yOffset)
        }
        .aspectRatio(0.82, contentMode: .fit)
    }

    private func macBody(width: CGFloat, height: CGFloat) -> some View {
        MacBodyShape()
            .fill(
                LinearGradient(
                    colors: [
                        Color(red: 0.88, green: 0.84, blue: 0.72),
                        Color(red: 0.68, green: 0.62, blue: 0.48),
                        Color(red: 0.42, green: 0.34, blue: 0.20)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay {
                MacBodyShape()
                    .stroke(Color.white.opacity(0.34), lineWidth: width * 0.018)
                    .blur(radius: width * 0.002)
            }
            .overlay {
                MacBodyShape()
                    .stroke(Color.black.opacity(0.28), lineWidth: width * 0.012)
            }
            .shadow(color: .black.opacity(0.55), radius: width * 0.028, x: 0, y: width * 0.026)
    }

    private func screenRecess(width: CGFloat, height: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: width * 0.038, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        Color(red: 0.24, green: 0.15, blue: 0.06),
                        Color(red: 0.78, green: 0.73, blue: 0.58),
                        Color(red: 0.34, green: 0.26, blue: 0.14)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: width * 0.03, style: .continuous)
                    .stroke(Color.black.opacity(0.24), lineWidth: width * 0.014)
                    .padding(width * 0.012)
            }
            .frame(width: width * 0.80, height: height * 0.53)
            .position(x: width * 0.50, y: height * 0.315)
    }

    private func screenContent(width: CGFloat, height: CGFloat) -> some View {
        let screenWidth = width * 0.66
        let screenHeight = height * 0.41
        let cornerRadius = width * 0.026

        return TimelineView(.animation) { _ in
            content
                .frame(width: screenWidth - 4, height: screenHeight - 4)
                .background(Color(red: 0.47, green: 0.86, blue: 0.90))
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                .layerEffect(
                    ShaderLibrary.oldTVShader(
                        .float(-startDate.timeIntervalSinceNow),
                        .float2(screenWidth, screenHeight)
                    ),
                    maxSampleOffset: .zero
                )
        }
        .position(x: width * 0.50, y: height * 0.315)
    }

    private func screenGlass(width: CGFloat, height: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: width * 0.038, style: .continuous)
            .strokeBorder(
                LinearGradient(
                    colors: [
                        .black.opacity(0.78),
                        .black.opacity(0.95),
                        .white.opacity(0.14)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: width * 0.035
            )
            .background {
                RoundedRectangle(cornerRadius: width * 0.038, style: .continuous)
                    .fill(Color.black.opacity(0.10))
            }
            .overlay {
                RoundedRectangle(cornerRadius: width * 0.024, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [.white.opacity(0.18), .clear, .black.opacity(0.18)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .padding(width * 0.04)
                    .allowsHitTesting(false)
            }
            .frame(width: width * 0.70, height: height * 0.45)
            .position(x: width * 0.50, y: height * 0.315)
    }

    private func diskDrive(width: CGFloat, height: CGFloat) -> some View {
        ZStack(alignment: .trailing) {
            RoundedRectangle(cornerRadius: width * 0.008, style: .continuous)
                .fill(Color(red: 0.49, green: 0.39, blue: 0.18))
                .frame(width: width * 0.45, height: height * 0.035)
            
            ZStack(alignment: .trailing) {
                RoundedRectangle(cornerRadius: width * 0.008, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                .black.opacity(0.58),
                                Color(red: 0.50, green: 0.41, blue: 0.23),
                                Color(red: 0.73, green: 0.64, blue: 0.42)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay(alignment: .top) {
                        Rectangle()
                            .fill(Color.black.opacity(0.50))
                            .frame(height: height * 0.006)
                            .padding(.horizontal, width * 0.01)
                    }
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .fill(Color.white.opacity(0.22))
                            .frame(height: height * 0.004)
                            .padding(.horizontal, width * 0.012)
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: width * 0.008, style: .continuous)
                            .stroke(Color.black.opacity(0.34), lineWidth: width * 0.002)
                    }

                Circle()
                    .fill(Color.black.opacity(0.75))
                    .frame(width: width * 0.01, height: width * 0.01)
                    .padding(.trailing, width * 0.012)
            }
            .frame(width: width * 0.15, height: height * 0.052)
            .offset(x: width * 0.02, y: height * 0.005)

            RoundedRectangle(cornerRadius: width * 0.006, style: .continuous)
                .fill(Color.black.opacity(0.86))
                .frame(width: width * 0.32, height: height * 0.014)
                .padding(.trailing, width * 0.06)

        }
        .position(x: width * 0.67, y: height * 0.70)
    }

    private func appleBadge(width: CGFloat, height: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: width * 0.008, style: .continuous)
            .fill(Color(red: 0.86, green: 0.83, blue: 0.70))
            .overlay {
                LinearGradient(
                    colors: [.green, .yellow, .orange, .red, .blue],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .mask {
                    Image(systemName: "apple.logo")
                        .resizable()
                        .scaledToFit()
                }
                .padding(width * 0.008)
            }
            .overlay {
                RoundedRectangle(cornerRadius: width * 0.008, style: .continuous)
                    .stroke(Color.black.opacity(0.35), lineWidth: width * 0.002)
            }
            .frame(width: width * 0.052, height: height * 0.042)
            .position(x: width * 0.13, y: height * 0.80)
    }

    private func lowerShadow(width: CGFloat, height: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: width * 0.018, style: .continuous)
            .fill(Color.black.opacity(0.24))
            .frame(width: width * 0.86, height: height * 0.035)
            .blur(radius: width * 0.01)
            .position(x: width * 0.50, y: height * 0.965)
    }
}

private struct MacBodyShape: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height

        var path = Path()
        path.move(to: CGPoint(x: w * 0.08, y: h * 0.005))
        path.addLine(to: CGPoint(x: w * 0.91, y: h * 0.005))
        path.addQuadCurve(to: CGPoint(x: w * 0.985, y: h * 0.09), control: CGPoint(x: w * 0.975, y: h * 0.01))
        path.addLine(to: CGPoint(x: w * 0.985, y: h * 0.90))
        path.addQuadCurve(to: CGPoint(x: w * 0.93, y: h * 0.985), control: CGPoint(x: w * 0.985, y: h * 0.965))
        path.addLine(to: CGPoint(x: w * 0.07, y: h * 0.985))
        path.addQuadCurve(to: CGPoint(x: w * 0.015, y: h * 0.90), control: CGPoint(x: w * 0.015, y: h * 0.965))
        path.addLine(to: CGPoint(x: w * 0.015, y: h * 0.09))
        path.addQuadCurve(to: CGPoint(x: w * 0.08, y: h * 0.005), control: CGPoint(x: w * 0.02, y: h * 0.01))
        path.closeSubpath()
        return path
    }
}

#Preview("Empty Mac Frame") {
    ZStack {
        Color.black
            .ignoresSafeArea()

        OldMacImageFrame()
            .padding(24)
    }
}

#Preview("Mac Frame With Content") {
    ZStack {
        Color.black
            .ignoresSafeArea()

        OldMacImageFrame {
            Image(.redSaturn)
                .renderingMode(.template)
                .resizable()
                .scaledToFill()
                .foregroundStyle(.white)
                .overlay {
                    Text("iOS Performance Agent Skills")
                        .font(.custom("VT323-Regular", size: 40))
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                }
        }
        .padding(24)
    }
}
