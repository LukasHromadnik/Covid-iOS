//
//  ValueView.swift
//  Bars
//
//  Created by Lukáš Hromadník on 25.04.2021.
//

import SwiftUI

struct ValueView: View {
    let title: String
    let color: Color
    
    var body: some View {
        Text(title)
            .font(.caption)
            .padding([.top, .bottom], 4)
            .padding([.leading, .trailing], 6)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                    Rectangle()
                        .frame(width: 16, height: 16)
                        .rotationEffect(Angle(degrees: 45))
                        .offset(x: 0, y: 6)
                }
                .foregroundColor(color)
            )
    }
}

struct ValueView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ValueView(title: "Test text", color: Color(.secondarySystemBackground))
                .padding()
                .previewLayout(.sizeThatFits)
            
            ValueView(title: "Very very loooooong text", color: Color(.secondarySystemBackground))
                .padding()
                .previewLayout(.sizeThatFits)
            
            ValueView(title: "ab", color: Color(.secondarySystemBackground))
                .padding()
                .previewLayout(.sizeThatFits)
        }
    }
}
