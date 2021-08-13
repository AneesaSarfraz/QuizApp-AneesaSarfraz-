

import Foundation
struct Question {
    let text: String
    let answers: [Answer]
    let difficulty: QuestionDifficulty
}
struct Answer {
    let text: String
    let correct: Bool
}

enum QuestionDifficulty: Int {
    case easy = 0
    case medium = 1
    case hard = 2
}
