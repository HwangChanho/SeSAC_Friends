//
//  DataSource.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/21.
//

import RxDataSources

struct TableViewItem {
    let title: String
    
    init(title: String) {
        self.title = title
    }
}

struct TableViewSection {
    let items: [TableViewItem]
    let header: String
    
    init(items: [TableViewItem], header: String) {
        self.items = items
        self.header = header
    }
}

extension TableViewSection: SectionModelType {
    typealias Item = TableViewItem
    
    init(original: Self, items: [Self.Item]) {
        self = original
    }
}
