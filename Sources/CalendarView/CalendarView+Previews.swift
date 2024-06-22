//
//  CalendarView+Previews.swift
//
//
//  Created by Edon Valdman on 6/22/24.
//

import SwiftUI

@available(iOS 17.0, *)
private struct CalendarView_Preview: View {
    @State
    private var selection = Set<DateComponents>()
    
    @State
    private var buffer: DateComponents? = nil
    
    var body: some View {
        VStack {
            Text("Test")
            
            Button("Add") {
                guard let buffer,
                      !selection.contains(buffer) else { return }
                selection.insert(buffer)
            }
            
            CalendarView($selection)
                .fontDesign(.default)
                .decorations { dateComponents in
                    return .image("star.fill", color: .orange)
                }
                .fixedSize()
        }
        .onChange(of: selection, initial: true) {
            //            print(selection)
            if buffer == nil,
               let toBuffer = selection.first {
                withAnimation {
                    buffer = toBuffer
                }
            }
        }
        //    .locale(.init(identifier: "he"))
        //    .environment(\.layoutDirection, .rightToLeft)
    }
}

@available(iOS 17, *)
#Preview {
    CalendarView_Preview()
}

@available(iOS 17, *)
#Preview {
    UICalendarView(frame: .zero)
}
