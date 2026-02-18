//
//  MatchMarkers.swift
//  CodeBreaker
//
//  Created by abramovanto on 18.02.2026.
//
import SwiftUI

enum Match {
    case noMatch
    case exact
    case inExact
}

struct MatchMarkers: View {
    var matches: [Match]

    var body: some View {
        matchMarkersGroups(rows: 2)
    }

    private func makeMarker(markers: [Int]) -> some View {
        HStack {
            ForEach(markers.indices, id: \.self) { index in
                VStack {
                    matchMarker(peg: markers[index])
                }
            }
        }
    }

    @ViewBuilder
    private func matchMarker(peg: Int) -> some View {
        let exactCount = matches.count { $0 == .exact }
        let foundCount = matches.count { $0 != .noMatch }
        Circle()
            .fill(exactCount > peg ? Color.primary : Color.clear)
            .strokeBorder(foundCount > peg ? Color.primary : Color.clear, lineWidth: 2)
            .aspectRatio(1, contentMode: .fit)
    }

    @ViewBuilder
    private func matchMarkersGroups(rows: Int) -> some View {
        let group = matchesGroup(rows: rows)
        HStack {
            ForEach(group.indices, id: \.self) { groupIndex in
                let group = group[groupIndex]
                VStack {
                    ForEach(group, id: \.self) { index in
                        matchMarker(peg: index)
                    }
                }
            }
        }
    }

    private func matchesGroup(rows: Int) -> [[Int]] {
        var result: [[Int]] = []
        var group: [Int] = []
        for matchIndex in matches.indices {
            if matchIndex > 0, matchIndex % rows == 0 {
                result.append(group)
                group.removeAll()
            }
            group.append(matchIndex)
        }
        result.append(group)
        return result
    }
}

#Preview {
    MatchMarkers(matches: [.exact, .noMatch, .exact, .inExact])
}
