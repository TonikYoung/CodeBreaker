//
//  ContentView.swift
//  CodeBreaker
//
//  Created by abramovanto on 17.02.2026.
//

import SwiftUI

struct CodeBreakerView: View {
    @State
    var game = CodeBreaker(pegChoices: [.brown, .yellow, .orange, .black])

    var body: some View {
        VStack(spacing: 10) {
            view(for: game.masterCode)
            ScrollView {
                view(for: game.guess)
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view(for: game.attempts[index])
                }
            }
        }
        .padding()
    }

    var guessButton: some View {
        Button("Guess") {
            withAnimation {
                game.attemptGuess()
            }
        }
    }

    func view(for code: Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                RoundedRectangle(cornerRadius: 10)
                    .overlay {
                        if code.pegs[index] == Code.missing {
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.gray)
                        }
                    }
                    .contentShape(Rectangle())
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 70, height: 70)
                    .foregroundStyle(code.pegs[index])
                    .onTapGesture {
                        if code.kind == .guess {
                            game.changeGuessPeg(at: index)
                        }
                    }
            }
            if code.kind == .guess {
                guessButton
            } else {
                MatchMarkers(matches: code.matches)
            }
            Spacer()
        }
    }
}

#Preview {
    CodeBreakerView()
}
