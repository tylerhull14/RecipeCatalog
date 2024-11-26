//
//  LoadingView.swift
//  RecipeCatalog
//
//  Created by Tyler Hull on 11/25/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
            Text("Loading...")
                .foregroundColor(.secondary)
        }
    }
}
