//
//  ContentView.swift
//  CodeBreaker
//
//  Created by abramovanto on 17.02.2026.
//

import SwiftUI

struct CodeBreakerView: View {
    @State
    var game = CodeBreaker()

    var body: some View {
        VStack(spacing: 10) {
            restartButton
            if game.isWinTheGame {
                Text("Congratulations! You won!")
                    .font(.system(size: 25))
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            } else {
                view(for: game.masterCode)
                ScrollView {
                    view(for: game.guess)
                    ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                        view(for: game.attempts[index])
                    }
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

    var restartButton: some View {
        Button("RESTART") {
            withAnimation {
                game.restart()
            }
        }
    }

    private func view(for code: Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                peg(for: code, at: index)
                    .overlay {
                        if code.pegs[index] == Code.missing {
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.gray)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if code.kind == .guess {
                            game.changeGuessPeg(at: index)
                        }
                    }
            }
            Group {
                switch code.kind {
                case .masterCode:
                    Text("Master")
                        .font(.system(size: 15))
                case .guess:
                    guessButton
                case .attempt(let matches):
                    MatchMarkers(matches: matches)
                default:
                    Spacer()
                }
            }
            .frame(width: 50, height: 50)
            .minimumScaleFactor(0.1)
        }
    }

    @ViewBuilder
    private func peg(for code: Code, at index: Int) -> some View {
        Circle()
            .foregroundStyle(.clear)
            .overlay {
                switch game.type {
                case .colors:
                    Circle()
                        .foregroundStyle(code.pegs[index].color ?? .clear)
                case .emojis:
                    Text(code.pegs[index])
                        .font(.system(size: 70))
                        .minimumScaleFactor(0.1)
                case .unknown:
                    Text("")
                }
            }
    }
}

#Preview {
    CodeBreakerView()
}
