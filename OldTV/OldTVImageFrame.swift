//
//  OldTVImageFrame.swift
//  OldTV
//
//  Created by Artem Mir on 31.05.26.
//

import SwiftUI

struct OldTVImageFrame<Content: View>: View {
    @State private var startDate = Date()

    private let content: Content

    init(@ViewBuilder content: () -> Content = { EmptyView() }) {
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            let side = min(geometry.size.width, geometry.size.height)
            let xOffset = (geometry.size.width - side) / 2
            let yOffset = (geometry.size.height - side) / 2

            ZStack {
                TVBodyShape()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.25, green: 0.19, blue: 0.10),
                                Color(red: 0.78, green: 0.58, blue: 0.25),
                                Color(red: 0.20, green: 0.14, blue: 0.08)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay {
                        TVBodyShape()
                            .stroke(Color.white.opacity(0.34), lineWidth: side * 0.018)
                            .blur(radius: side * 0.002)
                    }
                    .overlay {
                        TVBodyShape()
                            .stroke(Color.black.opacity(0.6), lineWidth: side * 0.014)
                    }
                    .shadow(color: .black.opacity(0.55), radius: side * 0.022, x: 0, y: side * 0.02)

                screenBezelBackground(in: side)
                screenContent(in: side)
                screenBezelBorder(in: side)
                lowerControls(in: side)
            }
            .frame(width: side, height: side)
            .offset(x: xOffset, y: yOffset)
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func screenContent(in side: CGFloat) -> some View {
        let screenWidth = side * 0.64
        let screenHeight = side * 0.50
        let screenCornerRadius = side * 0.045

        return TimelineView(.animation) { _ in
            content
                .frame(width: screenWidth - 4, height: screenHeight - 4)
                .clipShape(RoundedRectangle(cornerRadius: screenCornerRadius, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: screenCornerRadius, style: .continuous)
                        .fill(
                            RadialGradient(
                                colors: [.white.opacity(0.28), .clear],
                                center: .center,
                                startRadius: side * 0.04,
                                endRadius: side * 0.38
                            )
                        )
                        .allowsHitTesting(false)
                }
                .layerEffect(
                    ShaderLibrary.oldTVShader(
                        .float(-startDate.timeIntervalSinceNow),
                        .float2(screenWidth, screenHeight)
                    ),
                    maxSampleOffset: .zero
                )
        }
        .position(x: side * 0.48, y: side * 0.38)
    }

    private func screenBezelBackground(in side: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: side * 0.065, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        Color(red: 0.08, green: 0.08, blue: 0.07),
                        Color(red: 0.74, green: 0.73, blue: 0.68),
                        Color(red: 0.18, green: 0.18, blue: 0.16)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: side * 0.72, height: side * 0.58)
            .shadow(color: .black.opacity(0.55), radius: side * 0.012, x: 0, y: side * 0.012)
            .position(x: side * 0.48, y: side * 0.38)
    }

    private func screenBezelBorder(in side: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: side * 0.105, style: .continuous)
            .strokeBorder(
                LinearGradient(
                    colors: [
                        .white.opacity(0.65),
                        .black.opacity(0.62),
                        .white.opacity(0.22)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: side * 0.035
            )
            .frame(width: side * 0.68, height: side * 0.54)
            .position(x: side * 0.48, y: side * 0.38)
    }

    private func lowerControls(in side: CGFloat) -> some View {
        ZStack {
            speakerGrid(in: side)
                .position(x: side * 0.21, y: side * 0.77)

            HStack(spacing: side * 0.045) {
                TVKnob(size: side * 0.085)
                TVKnob(size: side * 0.085)
            }
            .position(x: side * 0.48, y: side * 0.76)

            RoundedRectangle(cornerRadius: side * 0.028, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.06, green: 0.04, blue: 0.02),
                            Color(red: 0.30, green: 0.14, blue: 0.04),
                            Color(red: 0.03, green: 0.02, blue: 0.01)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay {
                    RoundedRectangle(cornerRadius: side * 0.028, style: .continuous)
                        .stroke(Color.black.opacity(0.7), lineWidth: side * 0.01)
                }
                .frame(width: side * 0.22, height: side * 0.10)
                .position(x: side * 0.75, y: side * 0.77)
        }
    }

    private func speakerGrid(in side: CGFloat) -> some View {
        VStack(spacing: side * 0.018) {
            ForEach(0..<3, id: \.self) { row in
                HStack(spacing: side * 0.035) {
                    ForEach(0..<5, id: \.self) { column in
                        Circle()
                            .fill(Color.black.opacity((row + column).isMultiple(of: 2) ? 0.82 : 0.66))
                            .frame(width: side * 0.017, height: side * 0.017)
                    }
                }
            }
        }
    }
}

private struct TVBodyShape: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height

        var path = Path()
        path.move(to: CGPoint(x: w * 0.10, y: h * 0.12))
        path.addQuadCurve(to: CGPoint(x: w * 0.20, y: h * 0.06), control: CGPoint(x: w * 0.11, y: h * 0.07))
        path.addLine(to: CGPoint(x: w * 0.88, y: h * 0.06))
        path.addQuadCurve(to: CGPoint(x: w * 0.94, y: h * 0.14), control: CGPoint(x: w * 0.94, y: h * 0.07))
        path.addLine(to: CGPoint(x: w * 0.94, y: h * 0.84))
        path.addLine(to: CGPoint(x: w * 0.87, y: h * 0.90))
        path.addLine(to: CGPoint(x: w * 0.15, y: h * 0.90))
        path.addLine(to: CGPoint(x: w * 0.07, y: h * 0.83))
        path.addLine(to: CGPoint(x: w * 0.07, y: h * 0.16))
        path.addQuadCurve(to: CGPoint(x: w * 0.10, y: h * 0.12), control: CGPoint(x: w * 0.07, y: h * 0.13))
        path.closeSubpath()
        return path
    }
}

private struct TVKnob: View {
    let size: CGFloat

    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        .white.opacity(0.86),
                        Color(red: 0.40, green: 0.39, blue: 0.35),
                        .black.opacity(0.86)
                    ],
                    center: .topLeading,
                    startRadius: size * 0.08,
                    endRadius: size * 0.58
                )
            )
            .overlay {
                Circle()
                    .stroke(Color.white.opacity(0.45), lineWidth: size * 0.08)
            }
            .overlay {
                Circle()
                    .inset(by: size * 0.22)
                    .fill(Color.black.opacity(0.28))
            }
            .frame(width: size, height: size)
    }
}

private struct CornerHighlight: Shape {
    let corner: ScreenCorner

    func path(in rect: CGRect) -> Path {
        var path = Path()
        switch corner {
        case .topLeft:
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY), control: CGPoint(x: rect.minX, y: rect.minY))
        case .topRight:
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY), control: CGPoint(x: rect.maxX, y: rect.minY))
        case .bottomLeft:
            path.move(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.minY), control: CGPoint(x: rect.minX, y: rect.maxY))
        case .bottomRight:
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY), control: CGPoint(x: rect.maxX, y: rect.maxY))
        }

        return path
    }
}

private enum ScreenCorner: CaseIterable, Identifiable {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight

    var id: Self { self }

    func position(in side: CGFloat) -> CGPoint {
        switch self {
        case .topLeft:
            CGPoint(x: side * 0.16, y: side * 0.12)
        case .topRight:
            CGPoint(x: side * 0.80, y: side * 0.12)
        case .bottomLeft:
            CGPoint(x: side * 0.16, y: side * 0.64)
        case .bottomRight:
            CGPoint(x: side * 0.80, y: side * 0.64)
        }
    }
}

#Preview("Empty TV Frame") {
    ZStack {
        Color.black
            .ignoresSafeArea()

        OldTVImageFrame()
            .padding(24)
    }
}

#Preview("TV Frame With Content") {
    ZStack {
        Color.black
            .ignoresSafeArea()

        OldTVImageFrame {
            Image(.tokyo)
                .resizable()
                .scaledToFill()
        }
    }
}
