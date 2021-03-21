//
//  TaskDetailsView.swift
//  TaskIt
//
//  Created by Kyle Dold on 15/02/2021.
//

import SwiftUI

struct TaskDetailsView<ViewModel: TaskDetailsViewModelProtocol>: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: ViewModel
    @State private var feedback = UINotificationFeedbackGenerator()
    @State private var showDeleteConfirmationAlert = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // MARK: - View
    
    var body: some View {
        ScrollView {
            VStack {
                navigationBarView
                taskBasicDetailsView
                SubTaskListView(viewModel: viewModel.subTaskListViewModel)
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationBarHidden(true)
        .alert(isPresented: $showDeleteConfirmationAlert, content: { deleteConfirmationAlert })
        .bottomSheet(isPresented: $viewModel.showCalendarView, height: 450) {
            CalendarView(viewModel: viewModel.calendarViewModel)
        }
        .onAppear {
            // TODO: find a better way to handle this
            UITextView.appearance().backgroundColor = .clear
        }
    }
    
    // MARK: - Events
    
    private func backButtonTapped() {
        presentationMode.wrappedValue.dismiss()
    }
    
    private func calendarButtonTapped() {
        viewModel.calendarButtonTapped()
    }
    
    private func deleteButtonTapped() {
        showDeleteConfirmationAlert = true
    }
}

extension TaskDetailsView {
    
    private var navigationBarView: some View {
        HStack {
            
            Button(action: backButtonTapped, label: {
                Image(systemName: Image.Icons.back)
            }).buttonStyle(ImageButtonStyle(buttonColor: .primary))
            
            Spacer()
            
            Button(action: deleteButtonTapped, label: {
                Text(viewModel.deleteButtonText)
            })
            .buttonStyle(TextNavigationButtonStyle(buttonColor: .t_red, textColor: .white))
            
        }.padding(.bottom, Layout.Spacing.compact)
    }
    
    private var taskBasicDetailsView: some View {
        VStack(spacing: Layout.Spacing.cozy) {
            VStack(spacing: Layout.Spacing.cozy) {
                
                HStack {
                    Toggle(isOn: $viewModel.isComplete) {}
                        .toggleStyle(CheckboxToggleStyle())
                        .onChange(of: viewModel.isComplete) { _ in
                            feedback.notificationOccurred(.success)
                        }
                    
                    TextField(viewModel.taskNamePlaceholderText, text: $viewModel.taskName)
                        .textFieldStyle(SimpleTextFieldStyle())
                }
                
                VStack(spacing: Layout.Spacing.compact) {
                    dueDateRow
                    timeRow
                    reminderRow
                }
                .padding(Layout.Spacing.cozy)
                .background(Color.t_input_background)
                .cornerRadius(10)
                
                TextBox(viewModel.taskNotesPlaceholderText, text: $viewModel.taskNotes)
            }
        }
    }

    private var dueDateRow: some View {
        VStack {
            HStack {
                Text(viewModel.taskDateText)
                Spacer()
                Toggle(isOn: $viewModel.isDateEnabled, label: {}).toggleStyle(SwitchToggleStyle())
                    .padding(Layout.Spacing.tight)
            }
            if viewModel.isDateEnabled {
                HStack {
                    Spacer()
                    Button(action: calendarButtonTapped, label: {
                        HStack {
                            Text(viewModel.formattedDueDate)
                                .foregroundColor(.primary)
                        }
                        .padding(Layout.Spacing.compact)
                        .background(Color.t_input_background_2)
                        .cornerRadius(10)
                    })
                }
            }
        }
    }
    
    private var timeRow: some View {
        VStack {
            HStack {
                Text(viewModel.timeText)
                Spacer()
                Toggle(isOn: $viewModel.isTimeEnabled, label: {}).toggleStyle(SwitchToggleStyle())
                    .padding(Layout.Spacing.tight)
            }
            if viewModel.isTimeEnabled {
                HStack {
                    Spacer()
                    Button(action: calendarButtonTapped, label: {
                        HStack {
                            Text("14:00")
                                .foregroundColor(.primary)
                        }
                        .padding(Layout.Spacing.compact)
                        .background(Color.t_input_background_2)
                        .cornerRadius(10)
                    })
                }
            }
        }
    }
    
    private var reminderRow: some View {
        VStack {
            HStack {
                Text(viewModel.reminderText)
                Spacer()
                Toggle(isOn: $viewModel.isReminderEnabled, label: {}).toggleStyle(SwitchToggleStyle())
                    .padding(Layout.Spacing.tight)
            }
            if viewModel.isReminderEnabled {
                HStack {
                    Spacer()
                    Button(action: {}, label: {
                        HStack {
                            Text("15 min before")
                                .foregroundColor(.primary)
                        }
                        .padding(Layout.Spacing.compact)
                        .background(Color.t_input_background_2)
                        .cornerRadius(10)
                    })
                }
            }
        }
    }
    
    var deleteConfirmationAlert: Alert {
        Alert(
            title: Text(viewModel.deleteAlertTitleText),
            message: Text(viewModel.deleteAlertMessageText),
            primaryButton: .destructive(Text(viewModel.deleteButtonText), action: {
                viewModel.deleteButtonTapped {
                    presentationMode.wrappedValue.dismiss()
                }
            }),
            secondaryButton: .cancel()
        )
    }
}

// MARK: - PreviewProvider -

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailsView(viewModel: FakeTaskDetailsViewModel())
    }
}
