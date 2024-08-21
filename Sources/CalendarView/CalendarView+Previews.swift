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
    private var selection = Array<DateComponents>()
    
    @State
    private var buffer: DateComponents? = nil
    
    @State
    private var toggle = false
    
    @State
    private var visibleDateComponents: DateComponents? = nil
    
    var body: some View {
        VStack {
            Text("Test")
            
            Toggle("Change Visible Date Components", isOn: $toggle)
            
            Button("Add") {
                withAnimation {
                    var a = selection.first
                    a?.day = 10
                    var b = selection.first
                    b?.day = 12
                    var c = selection.first
                    c?.day = 27
                    selection.append(contentsOf: [
                        a, b, c
                    ].compactMap { $0 })
                }
            }
            
            CalendarView($selection)
                .fontDesign(.default)
                .decorations { _ in
                    .image("star.fill", color: .orange)
                }
                .fixedSize()
        }
        .padding()
        .onChange(of: selection, initial: true) {
            print("onChange:", selection.compactMap(\.day))
            if buffer == nil,
               let toBuffer = selection.first {
                buffer = toBuffer
            }
        }
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
