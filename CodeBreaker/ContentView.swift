//
//  ContentView.swift
//  CodeBreaker
//
//  Created by abramovanto on 17.02.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            pegs(colors: [.red, .green, .green, .yellow])
            pegs(colors: [.red, .blue, .green, .red])
            pegs(colors: [.red, .yellow, .green, .blue])
        }
        .padding()
    }

    func pegs(colors: [Color]) -> some View {
        HStack {
            ForEach(colors.indices, id: \.self) { index in
                Circle()
                    .foregroundStyle(colors[index])
            }
            MatchMarkers(matches: [.exact, .inExact, .noMatch, .exact, .exact, .exact])
        }
    }
}

#Preview {
    ContentView()
}
