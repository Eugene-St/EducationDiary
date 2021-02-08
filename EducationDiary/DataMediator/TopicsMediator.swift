//
//  TopicsMediator.swift
//  EducationDiary
//
//  Created by Eugene St on 01.02.2021.
//

import Foundation

class TopicsMediator: Mediator<Topics> {
    init() {
        super.init(.topics, pathForUpdate: .topicsUpdate)
    }
}
