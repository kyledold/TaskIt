//
//  TaskRowView.swift
//  TaskIt
//
//  Created by Kyle Dold on 16/02/2021.
//

import SwiftUI

struct TaskRowView<ViewModel: TaskRowViewModelProtocol>: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: ViewModel
    @State private var feedback = UINotificationFeedbackGenerator()
    
    // MARK: - View
    
    var body: some View {
        HStack {
            
            Toggle(isOn: $viewModel.isComplete) {}
                .toggleStyle(CheckboxToggleStyle())
                .onChange(of: viewModel.isComplete) { _ in
                    feedback.notificationOccurred(.success)
                }
            
            Text(viewModel.taskTitle)
                .strikethrough(viewModel.isComplete, color: .primary)
                .font(.regular_16)
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(Layout.Spacing.compact)
    }
}

// MARK: - PreviewProvider -

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TaskRowView(viewModel: FakeTaskRowViewModel())
                .preferredColorScheme(.dark)
                .previewLayout(.fixed(width: 300, height: 80))
        }
    }
}
