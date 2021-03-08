//
//  NewTaskView.swift
//  TaskIt
//
//  Created by Kyle Dold on 06/03/2021.
//

import SwiftUI
import Introspect

struct NewTaskView<ViewModel: NewTaskViewModelProtocol>: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: ViewModel
    
    @Binding var showNewTaskView: Bool
    
    // MARK: - View
    
    var body: some View {
        
        dimmedBackgroundView
        VStack {
            Spacer()
            newTaskInputView
        }
        .transition(.move(edge: .bottom))
    }
    
    // MARK: - Events
    
    private func createTaskButtonTapped() {
        viewModel.createTaskButtonTapped {
            showNewTaskView = false
        }
    }
}

extension NewTaskView {
    
    private var dimmedBackgroundView: some View {
        VStack {
        }
        .backgroundOverlay(color: .black).opacity(0.3)
        .onTapGesture {
            showNewTaskView = false
        }
    }
    
    private var newTaskInputView: some View {
        HStack {
            TextField(viewModel.taskNamePlaceholder, text: $viewModel.taskName)
                .textFieldStyle(SimpleTextFieldStyle())
                .introspectTextField { textField in
                    textField.becomeFirstResponder()
                }
            
            Spacer()
            
            Button(action: createTaskButtonTapped, label: {
                Image(systemName: Image.Icons.create).iconStyle()
            })
            .buttonStyle(ImageButtonStyle(isDisabled: viewModel.isCreateButtonDisabled, buttonColor: .primary))
            .disabled(viewModel.isCreateButtonDisabled)
        }
        .padding()
        .frame(height: 80)
        .background(RoundedCorners(color: .t_content_background, topLeft: 10, topRight: 10, bottomLeft: 0, bottomRight: 0))
    }
}

// MARK: - PreviewProvider -

struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskView(viewModel: FakeNewTaskViewModel(), showNewTaskView: .constant(true))
    }
}