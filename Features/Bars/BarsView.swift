//
//  BarsView.swift
//  Playground
//
//  Created by Lukáš Hromadník on 22.04.2021.
//

import SwiftUI
import CovidCore

struct GraphWidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

public struct BarsView: View {
    @ObservedObject var dataLoader: CumulativeReportDataLoader
    
    private var columnSpacing: CGFloat = 2
    private var groupSpacing: CGFloat = 12
    private let graphHeight: CGFloat = 300
    
    private let days = ["Po", "Út", "St", "Čt", "Pá", "So", "Ne"]
    private let legend = ["Předminulý", "Minulý", "Tento"]
    private let colors: [Color] = [
        Color(red: 250/255, green: 203/255, blue: 137/255),
        Color(red: 255/255, green: 154/255, blue: 77/255),
        Color(red: 253/255, green: 63/255, blue: 63/255)
    ]
    
    public init(dataLoader: CumulativeReportDataLoader) {
        self.dataLoader = dataLoader
    }
    
    public var body: some View {
        Group {
            if dataLoader.items.isEmpty {
                ProgressView()
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    legendView
                    graphView
                    labelsView
                }
            }
        }
    }
    
    private var legendView: some View {
        HStack(spacing: 24) {
            ForEach(0..<legend.count) { index in
                HStack {
                    Rectangle()
                        .frame(width: 16, height: 8)
                        .foregroundColor(colors[index])
                    Text(legend[index])
                        .font(.caption)
                }
            }
        }
        .padding(.bottom, 24)
    }
    
    @State var graphWidth: CGFloat = 0
    @State var isValueHidden = true
    @State var valueOffset: CGSize = .zero
    @State var valueTitle = ""
    @State var valueColor: Color = Color(.secondarySystemBackground)
    @State var previousIndex: Int?
    
    private var graphView: some View {
        GeometryReader { proxy in
            ZStack {
                HStack(alignment: .bottom, spacing: groupSpacing) {
                    ForEach(0..<days.count) { day in
                        HStack(alignment: .bottom, spacing: columnSpacing) {
                            ForEach(0..<3) { index in
                                Rectangle()
                                    .foregroundColor(colors[index])
                                    .frame(
                                        width: columnWidth(for: proxy.size.width),
                                        height: max(dataLoader.sizes[day * 3 + index], 0)
                                    )
                            }
                        }
                    }
                }
                .coordinateSpace(name: "graph")
                .preference(key: GraphWidthPreferenceKey.self, value: proxy.size.width)
                
                if !isValueHidden {
                    ValueView(title: valueTitle, color: Color(.secondarySystemBackground))
                        .position(x: 0, y: 0)
                        .offset(valueOffset)
                }
            }
        }
        .frame(height: graphHeight)
        .gesture(drag)
        .onPreferenceChange(GraphWidthPreferenceKey.self) {
            graphWidth = $0
        }
    }
    
    private var drag: some Gesture {
        DragGesture(minimumDistance: 5, coordinateSpace: .named("graph"))
            .onChanged { showValue(at: $0.location) }
            .onEnded { _ in hideValue() }
    }
    
    private func showValue(at location: CGPoint) {
        let safeMargin: CGFloat = 100
        guard location.x >= 0 && location.y >= 0 && location.y <= graphHeight + safeMargin else { return }
        
        let colWidth = columnWidth(for: graphWidth)
        let groupWidth = 3 * colWidth + 2 * columnSpacing + groupSpacing
        
        var ranges: [ClosedRange<CGFloat>] = []
        for i in 0..<7 {
            for j in 0..<3 {
                let from = CGFloat(j) * (colWidth + columnSpacing) + CGFloat(i) * groupWidth
                let to = from + colWidth
                let range = from...to
                ranges.append(range)
            }
        }
        
        guard
            let index = ranges.firstIndex(where: { $0.contains(location.x) }),
            dataLoader.items[index] >= 0
        else { return }
        
        valueOffset = CGSize(width: location.x, height: graphHeight - dataLoader.sizes[index] - 18)
        valueTitle = "\(dataLoader.items[index])"
        isValueHidden = false
        
        if previousIndex != index {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            previousIndex = index
        }
    }
    
    private func hideValue() {
        isValueHidden = true
    }
    
    private var labelsView: some View {
        HStack(spacing: groupSpacing) {
            ForEach(days, id: \.self) { day in
                Text(day)
                    .font(.caption)
                    .inExpandingRectangle()
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
    
    func columnWidth(for width: CGFloat) -> CGFloat {
        (width - 7 * 2 * columnSpacing - 6 * groupSpacing) / 21
    }
}

struct BarsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BarsView(
                dataLoader: CumulativeReportDataLoader(
                    dataFetcher: localDataFetcher(resource: "nakaza.min"),
                    dateProvider: .fixed("2021-04-23")
                )
            )
            .previewLayout(.sizeThatFits)
            
            BarsView(
                dataLoader: CumulativeReportDataLoader(
                    dataFetcher: emptyDataFetcher(),
                    dateProvider: .fixed("2021-04-23")
                )
            )
            .previewLayout(.sizeThatFits)
        }
    }
}
