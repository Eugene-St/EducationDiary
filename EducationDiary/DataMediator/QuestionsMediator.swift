//
//  QuestionsMediator.swift
//  EducationDiary
//
//  Created by Eugene St on 01.02.2021.
//

import Foundation

class QuestionsMediator: Mediator<Question> {
    init() {
        super.init(.questions, pathForUpdate: .questionsUpdate)
    }
}
