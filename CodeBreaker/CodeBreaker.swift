//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by abramovanto on 24.02.2026.
//

import SwiftUI

typealias Peg = String

struct CodeBreaker {
    enum GameType {
        case colors
        case emojis
        case unknown

        static func random(with data: [String]) -> GameType {
            let isColors = data.allSatisfy { $0.color != nil }
            if data.isEmpty {
                return .unknown
            } else if isColors {
                return .colors
            } else {
                return .emojis
            }
        }
    }

    static func getRandomPegs(for type: GameType, count: Int) -> [Peg] {
        let resultCount: Int
        if count < Constant.minimumPegsCount {
            resultCount = Constant.minimumPegsCount
        } else if count > Constant.maximumPegsCount {
            resultCount = Constant.maximumPegsCount
        } else {
            resultCount = count
        }

        let result: [Peg]

        switch type {
        case .colors:
            result = Constant.colorNames
        case .emojis:
            result = Constant.emojisModes.randomElement() ?? []
        case .unknown:
            return []
        }

        return Array(result.prefix(upTo: resultCount))
    }

    var type: GameType = .unknown
    var masterCode: Code = .init(kind: .masterCode, pegs: [])
    var guess: Code = .init(kind: .guess, pegs: [])
    var attempts: [Code] = []
    var pegChoices: [Peg] = []

    init(
        type: GameType = .random(with: Constant.gameModes.randomElement() ?? []),
        pegsCount: Int = .random(in: Constant.minimumPegsCount...Constant.maximumPegsCount)
    ) {
        restart(type: type, pegsCount: pegsCount)
    }

    var isWinTheGame: Bool {
        attempts.contains(where: { $0.match(against: masterCode).allSatisfy({ $0 == .exact }) })
    }

    mutating func restart(
        type: GameType = .random(with: Constant.gameModes.randomElement() ?? []),
        pegsCount: Int = .random(in: Constant.minimumPegsCount...Constant.maximumPegsCount)
    ) {
        self.type = type
        pegChoices = Self.getRandomPegs(
            for: type,
            count: Int.random(in: Constant.minimumPegsCount...Constant.maximumPegsCount)
        )
        masterCode = .init(kind: .masterCode, pegs: pegChoices)
        masterCode.randomize(from: pegChoices)
        attempts = []
        guess = .init(kind: .guess, pegs: Array(repeating: Code.missing, count: pegChoices.count))
    }

    mutating func attemptGuess() {
        var attempt = guess
        attempt.kind = .attempt(attempt.match(against: masterCode))
        attempts.append(attempt)
    }

    mutating func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        if let indexOfExistingPegInPegChocies = pegChoices.firstIndex(of: existingPeg) {
            let newPeg = pegChoices[(indexOfExistingPegInPegChocies + 1) % pegChoices.count]
            guess.pegs[index] = newPeg
        } else {
            guess.pegs[index] = pegChoices.first ?? Code.missing
        }
    }
}

struct Code {
    var kind: Kind
    var pegs: [Peg]

    static let missing: Peg = ""

    enum Kind: Equatable {
        case masterCode
        case guess
        case attempt([Match])
        case unknown
    }

    mutating func randomize(from pegChoices: [Peg]) {
        for index in pegChoices.indices {
            pegs[index] = pegChoices.randomElement() ?? Code.missing
        }
    }

    func match(against otherCode: Code) -> [Match] {
        var results: [Match] = Array(repeating: .noMatch, count: pegs.count)
        var pegsToMatch = otherCode.pegs
        for index in pegs.indices.reversed() {
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] {
                results[index] = .exact
                pegsToMatch.remove(at: index)
            }
        }
        for index in pegs.indices {
            if results[index] != .exact {
                if let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                    results[index] = .inExact
                    pegsToMatch.remove(at: matchIndex)
                }
            }
        }
        return results
    }

    var matches: [Match] {
        switch kind {
        case .attempt(let matches): return matches
        default: return []
        }
    }
}

extension Peg {
    var color: Color? {
        Constant.namedColors[self]
    }
}

private enum Constant {
    static let minimumPegsCount = 3
    static let maximumPegsCount = 6
    static let namedColors: [String: Color] = [
        "blue": .blue, "teal": .teal, "yellow": .yellow,
        "red": .red, "green": .green, "purple": .purple
    ]
    static let colorNames = Array<String>(namedColors.keys)
    static let colors = Array<Color>(namedColors.values)
    static let smileEmojis: [String] = [
        "🤪", "🤨", "🧐", "🤓", "😎", "🥳"
    ]
    static let animalEmojis: [String] = [
        "🐶", "🐱", "🐭", "🐹", "🐰", "🦊"
    ]
    static let carEmojis: [String] = [
        "🚗", "🚕", "🚙", "🚌", "🚒", "🚐"
    ]
    static let colorModes: [[String]] = [
        colorNames
    ]
    static let emojisModes: [[String]] = [
        smileEmojis,
        animalEmojis,
        carEmojis
    ]
    static let gameModes: [[String]] = colorModes + emojisModes
}
