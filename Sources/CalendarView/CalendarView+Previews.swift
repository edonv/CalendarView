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
//    private var selection = Set<DateComponents>()
    
    @State
    private var buffer: DateComponents? = nil
    
    @State
    private var toggle = false
    
    @State
    private var visibleDateComponents: DateComponents? = nil
//    private var visibleDateComponents: Binding<DateComponents> {
//        .init {
//            toggle ? .init() : .init(year: 1996, month: 4, day: 10)
//        } set: { newValue/*, transaction*/ in
//            
//        }
//    }
    
    var body: some View {
        VStack {
            Text("Test")
            
            Toggle("Change Visible Date Components", isOn: $toggle)
            
            Button("Add") {
//                guard let buffer,
//                      !selection.contains(buffer) else { return }
//                print(buffer)
                withAnimation {
//                    NotificationCenter.default.post(name: Notification.Name("test"), object: nil)
                    
//                    selection.insert(buffer)
//                    selection.formUnion([
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
            
            CalendarView(
                $selection
//                visibleDateComponents: $visibleDateComponents,
//                availableDateRange: .init(.now...)
            )
                .fontDesign(.default)
                .decorations { dateComponents in
                    Text(dateComponents.day ?? 0, format: .number)
                }
//                .decorations { dateComponents in
//                    return .image("star.fill", color: .orange)
//                }
                .fixedSize()
        }
        .padding()
//        .onChange(of: visibleDateComponents, initial: true) {
//            print("visibleComponents:", visibleDateComponents)
//        }
        .onChange(of: selection, initial: true) {
            print("onChange:", selection.compactMap(\.day))
            if buffer == nil,
               let toBuffer = selection.first {
                buffer = toBuffer
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
