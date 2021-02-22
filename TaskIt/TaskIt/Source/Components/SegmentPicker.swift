//
//  SegmentPicker.swift
//  TaskIt
//
//  Created by Kyle Dold on 20/02/2021.
//

import SwiftUI

struct SegmentPicker: View {
    
    private static let ActiveSegmentColor: Color = Color(.tertiarySystemBackground)
    private static let BackgroundColor: Color = Color(.secondarySystemBackground)
    private static let ShadowColor: Color = Color.black.opacity(0.2)
    private static let TextColor: Color = Color(.secondaryLabel)
    private static let SelectedTextColor: Color = Color(.label)
    private static let TextFont: Font = .system(size: 12)
    private static let SegmentCornerRadius: CGFloat = 25
    private static let ShadowRadius: CGFloat = 4
    private static let SegmentXPadding: CGFloat = 16
    private static let SegmentYPadding: CGFloat = 8
    private static let PickerPadding: CGFloat = 4
    private static let AnimationDuration: Double = 0.2
    
    private let items: [String]
    
    @State private var segmentSize: CGSize = .zero
    @Binding private var selection: Int
    
    // Rounded rectangle to denote active segment
    private var activeSegmentView: AnyView {
        // Don't show the active segment until we have initialized the view
        // This is required for `.animation()` to display properly, otherwise the animation will fire on init
        let isInitialized: Bool = segmentSize != .zero
        if !isInitialized { return EmptyView().eraseToAnyView() }
        return
            RoundedRectangle(cornerRadius: SegmentPicker.SegmentCornerRadius)
                .foregroundColor(SegmentPicker.ActiveSegmentColor)
                .shadow(color: SegmentPicker.ShadowColor, radius: SegmentPicker.ShadowRadius)
                .frame(width: segmentSize.width, height: segmentSize.height)
                .offset(x: computeActiveSegmentHorizontalOffset(), y: 0)
                .animation(Animation.linear(duration: SegmentPicker.AnimationDuration))
                .eraseToAnyView()
    }
    
    init(items: [String], selection: Binding<Int>) {
        self._selection = selection
        self.items = items
    }
    
    var body: some View {
        // Align the ZStack to the leading edge to make calculating offset on activeSegmentView easier
        ZStack(alignment: .leading) {
            // activeSegmentView indicates the current selection
            activeSegmentView
            HStack {
                ForEach(0..<items.count, id: \.self) { index in
                    getSegmentView(for: index)
                }
            }
        }
        .padding(SegmentPicker.PickerPadding)
        .background(SegmentPicker.BackgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: SegmentPicker.SegmentCornerRadius))
    }

    private func computeActiveSegmentHorizontalOffset() -> CGFloat {
        CGFloat(selection) * (segmentSize.width + SegmentPicker.SegmentXPadding / 2)
    }

    private func getSegmentView(for index: Int) -> some View {
        guard index < items.count else {
            return EmptyView().eraseToAnyView()
        }
        let isSelected = selection == index
        return
            Text(items[index])
                .foregroundColor(isSelected ? SegmentPicker.SelectedTextColor: SegmentPicker.TextColor)
                .lineLimit(1)
                .padding(.vertical, SegmentPicker.SegmentYPadding)
                .padding(.horizontal, SegmentPicker.SegmentXPadding)
                .frame(minWidth: 0, maxWidth: .infinity)
                .modifier(SizeAwareViewModifier(viewSize: $segmentSize))
                .onTapGesture { onItemTap(index: index) }
                .eraseToAnyView()
    }

    private func onItemTap(index: Int) {
        guard index < items.count else {
            return
        }
        selection = index
    }
}

struct PreviewView: View {
    @State var selection: Int = 0
    private let items: [String] = ["M", "T", "W", "T", "F"]
    
    var body: some View {
        SegmentPicker(items: items, selection: $selection)
            .padding()
    }
}

struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
struct BackgroundGeometryReader: View {
    var body: some View {
        GeometryReader { geometry in
            return Color
                    .clear
                    .preference(key: SizePreferenceKey.self, value: geometry.size)
        }
    }
}
struct SizeAwareViewModifier: ViewModifier {

    @Binding private var viewSize: CGSize

    init(viewSize: Binding<CGSize>) {
        _viewSize = viewSize
    }

    func body(content: Content) -> some View {
        content
            .background(BackgroundGeometryReader())
            .onPreferenceChange(SizePreferenceKey.self, perform: { if viewSize != $0 { viewSize = $0 }})
    }
}