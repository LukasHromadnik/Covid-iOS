//
//  RView.swift
//  Covid
//
//  Created by Lukáš Hromadník on 05.07.2021.
//

import SwiftUI
import CovidCore

struct LineGraph: Shape {
    var points: [Double]
    
    func path(in rect: CGRect) -> Path {
        let stepX = rect.width / (CGFloat(points.count) - 1)
        let stepY = Double(rect.height) / 2
        
        return Path { p in
            guard !points.isEmpty else { return }
            for i in 0..<points.count {
                let point = CGPoint(
                    x: Double(stepX) * Double(i),
                    // We need to have (0, 0) at bottom left
                    // but canvas has it at top left
                    // so the values have to be inverted.
                    y: stepY * (2 - points[i])
                )
                if i == 0 {
                    p.move(to: point)
                } else{
                    p.addLine(to: point)
                }
            }
        }
    }
}

public struct RView: View {
    @ObservedObject var dataLoader: CumulativeReportDataLoader

    public init(dataLoader: CumulativeReportDataLoader) {
        self.dataLoader = dataLoader
    }
    
    public var body: some View {
        HStack {
            GeometryReader { proxy in
                Path { p in
                    p.move(to: CGPoint(x: 0, y: 0))
                    p.addLine(to: CGPoint(x: proxy.size.width, y: 0))
                }
                .stroke(Color.gray, lineWidth: 1)
                
                Path { p in
                    p.move(to: CGPoint(x: 0, y: proxy.size.height / 2))
                    p.addLine(to: CGPoint(x: proxy.size.width, y: proxy.size.height / 2))
                }
                .stroke(Color.gray, style: StrokeStyle(lineWidth: 1, dash: [3]))
                
                Path { p in
                    p.move(to: CGPoint(x: 0, y: proxy.size.height))
                    p.addLine(to: CGPoint(x: proxy.size.width, y: proxy.size.height))
                }
                .stroke(Color.gray, lineWidth: 1)
            }
            .overlay(
                LineGraph(points: dataLoader.r)
                    .stroke(Color.blue, lineWidth: 2)
            )
            .padding([.top, .bottom], 7)
            
            VStack {
                Text("2")
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
                Spacer()
                Text("1")
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
                Spacer()
                Text("0")
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
            }
        }
    }
}

#if DEBUG
struct RView_Previews: PreviewProvider {
    static var previews: some View {
        RView(
            dataLoader: CumulativeReportDataLoader(
                dataFetcher: localDataFetcher(resource: "nakaza.min"),
                dateProvider: .fixed("2021-04-23")
            )
        )
        .padding()
        .previewLayout(.fixed(width: 500, height: 200))
    }
}
#endif
