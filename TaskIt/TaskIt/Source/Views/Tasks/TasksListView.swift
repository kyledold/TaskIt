//
//  TasksListView.swift
//  TaskIt
//
//  Created by Kyle Dold on 02/02/2021.
//

import SwiftUI

struct TasksListView<ViewModel: TasksListViewModelProtocol>: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: ViewModel
    @ObservedObject var navigator: TasksNavigator
    @ObservedObject var toastPresenter: ToastPresenter
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            VStack {
                navigationHeaderView
                taskListBodyView
            }
            .backgroundOverlay()
            ButtonFooterView(
                buttonText: viewModel.createTaskButtonText,
                buttonColor: .t_orange,
                onButtonTap: {
                    navigator.sheetDestination = .taskDetails(onChange: {
                        viewModel.fetchTasks()
                    })
                }
            )
            .onNotification(.taskCreated) {
                toastPresenter.toast = .taskCreated
            }
        }
        VStack {
            // This was s workaround to get sheet and fullscreenCover working
            // https://www.hackingwithswift.com/forums/swiftui/using-sheet-and-fullscreencover-together/4258
        }
        .sheet(isPresented: $navigator.showSheet) {
            navigator.sheetView()
        }
        .present(isPresented: $toastPresenter.showToast) {
            toastPresenter.toastView()
        }
        .onAppear {
            viewModel.fetchTasks()
        }
    }
}

extension TasksListView {
    
    private var statusFilterView: some View {
        StatusSegmentView(selectedStatus: $viewModel.selectedStatusFilter)
            .onChange(of: viewModel.selectedStatusFilter) { viewModel.didChangeStatusFilter(status: $0) }
            .padding(.vertical, Layout.Padding.tight)
            .background(Color.t_background)
            .cornerRadius(25.0)
    }
    
    private var navigationHeaderView: some View {
        HStack(spacing: Layout.Padding.cozy) {
            Spacer()
            
            Button(action: {
                navigator.sheetDestination = .calendar
            }, label: {
                Image(systemName: Image.Icons.calendar).iconStyle()
            })
            
            Button(action: {
                navigator.sheetDestination = .settings
            }, label: {
                Image(systemName: Image.Icons.settings).iconStyle()
            })
        }
        .padding()
    }
    
    private var taskListBodyView: some View {
        ScrollView {
            statusFilterView.padding(.horizontal, Layout.Padding.compact)
            ForEach(viewModel.taskViewModels, id: \.id) { taskRowViewModel in
                TaskRowView(viewModel: taskRowViewModel)
                    .onTapGesture {
                        UIImpactFeedbackGenerator().impactOccurred()
                        /*navigator.fullScreenDestination = .viewTask(task: taskRowViewModel.task, onChange: {
                            viewModel.fetchTasks()
                        })*/
                    }
            }
        }
        .onNotification(.taskCompleted) {
            toastPresenter.toast = .taskCompleted
        }
        .onNotification(.taskDeleted) {
            toastPresenter.toast = .taskDeleted
        }
        .onNotification(.taskUpdated) {
            toastPresenter.toast = .taskUpdated
        }
    }
}

// MARK: - PreviewProvider -

struct TasksListView_Previews: PreviewProvider {
    static var previews: some View {
        TasksListView(viewModel: FakeTasksListViewModel(), navigator: TasksNavigator(), toastPresenter: ToastPresenter())
    }
}
