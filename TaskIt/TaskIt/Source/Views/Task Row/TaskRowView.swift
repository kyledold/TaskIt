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
        VStack {
            HStack {
                Toggle(isOn: $viewModel.isComplete) {}
                    .toggleStyle(CheckboxToggleStyle())
                    .onChange(of: viewModel.isComplete) { _ in
                        feedback.notificationOccurred(.success)
                    }
                Text(viewModel.title)
                    .strikethrough(viewModel.isComplete, color: .primary)
                    .font(.regular_16)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if let time = viewModel.time {
                    HStack(spacing: 4) {
                        Image(systemName: Image.Icons.alarm)
                            .resizable()
                            .foregroundColor(.gray)
                            .frame(width: 12, height: 12)
                        Text(time)
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            if let subTasksCompletionValue = viewModel.subTasksCompletionPercentage {
                HStack {
                    ProgressView(viewModel.subTasksCompletedText, value: subTasksCompletionValue)
                        .font(.footnote)
                    Spacer()
                }.padding(.leading, Layout.Spacing.spacious)
            }
            
        }.padding(Layout.Spacing.compact)
    }
}

// MARK: - PreviewProvider -

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TaskRowView(viewModel: FakeTaskRowViewModel())
                .previewLayout(.fixed(width: 300, height: 200))
        }
    }
}
