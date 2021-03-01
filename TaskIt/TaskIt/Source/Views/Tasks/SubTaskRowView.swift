//
//  SubTaskRowView.swift
//  TaskIt
//
//  Created by Kyle Dold on 28/02/2021.
//

import SwiftUI

struct SubTaskRowView<ViewModel: SubTaskRowViewModelProtocol>: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: ViewModel
    @Environment(\.editMode) var editMode: Binding<EditMode>?
    
    private var isInEditingMode: Bool {
        guard let editMode = editMode else { return false }
        return editMode.wrappedValue.isEditing
    }
    
    // MARK: - View
    
    var body: some View {
        HStack(spacing: 10) {
            
            if !isInEditingMode {
                Toggle(isOn: $viewModel.isComplete) {}
                    .toggleStyle(CheckboxToggleStyle())
            }
            
            Text(viewModel.subTaskTitle)
                .font(.regular_16)
                .padding(.leading, isInEditingMode ? Layout.Padding.compact : .zero)
            
            Spacer()
            
        }.listRowInsets(EdgeInsets())
    }
}

// MARK: - PreviewProvider -

struct SubTaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        SubTaskRowView(viewModel: FakeSubTaskRowViewModel())
            .previewLayout(.fixed(width: 300, height: 40))
    }
}