//
//  SettingsView.swift
//  SunburstDiagramDemo
//
//  Created by Ludovic Landry  on 6/17/19.
//  Copyright © 2019 Ludovic Landry. All rights reserved.
//

import SunburstDiagram
import SwiftUI

struct SettingsView : View {

    @ObjectBinding var configuration: SunburstConfiguration
    
    @State private var parentTotalValue: Double? = nil
    @State private var arcAngleShownIfLessThan: Double = 0.0
    
    var body: some View {
        NavigationView {
            Form {
                Section(header:Text("Content").font(.subheadline)) {
                    NavigationButton(destination: SettingsNodesView(nodes: configuration.nodes)) {
                        Text("nodes")
                        Spacer()
                        Text(configuration.nodes.count == 0 ? "[No nodes]" : "[\(configuration.nodes.count) root nodes]").color(Color.secondary)
                    }
                    Picker(selection: $configuration.nodesSort, label: Text("nodesSort")) {
                        Text(".none").tag(NodesSort.none)
                        Text(".asc").tag(NodesSort.asc)
                        Text(".desc").tag(NodesSort.desc)
                    }
                    Picker(selection: $configuration.calculationMode, label: Text("calculationMode")) {
                        Text(".ordinalFromLeaves").tag(CalculationMode.ordinalFromLeaves)
                        Text(".ordinalFromRoot").tag(CalculationMode.ordinalFromRoot)
                        Text(".parentDependent(totalValue:)").tag(CalculationMode.parentDependent(totalValue: parentTotalValue))
                        Text(".parentIndependent(totalValue:)").tag(CalculationMode.parentIndependent(totalValue: parentTotalValue))
                    }
//                    if case .parentDependent(let totalValue) = configuration.calculationMode {
//                        Stepper(value: $parentTotalValue, in: 0 ... 250) { Text(".parentDependent(totalValue:)") }
//                    } else if case .parentInependent(let totalValue) = configuration.calculationMode {
//                        Stepper(value: $parentTotalValue, in: 0 ... 250) { Text(".parentIndependent(totalValue:)") }
//                    }
                }
                Section(header:Text("Dimentions").font(.subheadline)) {
                    VStack(alignment: .leading) {
                        Text("marginBetweenArcs = \(configuration.marginBetweenArcs)")
                        Slider(value: $configuration.marginBetweenArcs, from: CGFloat(0), through: CGFloat(6), by: CGFloat(0.1))
                    }
                    VStack(alignment: .leading) {
                        Text("innerRadius = \(configuration.innerRadius)")
                        Slider(value: $configuration.innerRadius, from: CGFloat(0), through: CGFloat(200))
                    }
                    VStack(alignment: .leading) {
                        Text("expandedArcThickness = \(configuration.expandedArcThickness)")
                        Slider(value: $configuration.expandedArcThickness, from: CGFloat(30), through: CGFloat(120))
                    }
                    VStack(alignment: .leading) {
                        Text("collapsedArcThickness = \(configuration.collapsedArcThickness)")
                        Slider(value: $configuration.collapsedArcThickness, from: CGFloat(2), through: CGFloat(12))
                    }
                }
                Section(header:Text("More").font(.subheadline)) {
                    VStack(alignment: .leading) {
                        Text("startingAngle = \(configuration.startingAngle)")
                        Slider(value: $configuration.startingAngle, from: Double(-180), through: Double(180))
                    }
                    Toggle(isOn: configuration.maximumRingsShownCountToggleBinding) {
                        Text("maximumRingsShownCount")
                    }
                    if configuration.maximumRingsShownCount != nil {
                        IfLet(configuration.maximumRingsShownCount) { maximumRingsShownCount in
                            VStack(alignment: .leading) {
                                Text("maximumRingsShownCount = \(maximumRingsShownCount)")
                                Slider(value: self.configuration.maximumRingsShownCountSliderBinding, from: 1, through: 10)
                            }
                        }
                    }
                    Toggle(isOn: configuration.maximumExpandedRingsShownCountToggleBinding) {
                        Text("maximumExpandedRingsShownCount")
                    }
                    if configuration.maximumExpandedRingsShownCount != nil {
                        IfLet(configuration.maximumExpandedRingsShownCount) { maximumExpandedRingsShownCount in
                            VStack(alignment: .leading) {
                                Text("maximumExpandedRingsShownCount = \(maximumExpandedRingsShownCount)")
                                Slider(value: self.configuration.maximumExpandedRingsShownCountSliderBinding, from: 0, through: 8)
                            }
                        }
                    }
                    Picker(selection: $configuration.minimumArcAngleShown, label: Text("minimumArcAngleShown")) {
                        Text(".showAll").tag(ArcMinimumAngle.showAll)
                        Text(".group(ifLessThan:)").tag(ArcMinimumAngle.group(ifLessThan: arcAngleShownIfLessThan))
                        Text(".hide(ifLessThan:)").tag(ArcMinimumAngle.hide(ifLessThan: arcAngleShownIfLessThan))
                    }.disabled(true)
//                    if configuration.calculationMode == .group {
//                        Stepper(value: $parentTotalValue, in: 0.0 ... .pi) { Text(".group(ifLessThan:)") }
//                    } else if configuration.calculationMode == .hide {
//                        Stepper(value: $parentTotalValue, in: 0.0 ... .pi) { Text(".hide(ifLessThan:)") }
//                    }
                }
            }.navigationBarTitle(Text("Configuration"))
        }
    }
}

extension SunburstConfiguration {

    static let defaultMaximumExpandedRingsShownCount: UInt = 2
    static let defaultMaximumRingsShownCount: UInt = 4

    // MARK: maximumExpandedRingsShownCount bindings

    var maximumExpandedRingsShownCountSliderBinding: Binding<Double> {
        return Binding<Double>(getValue: { () -> Double in
            return Double(self.maximumExpandedRingsShownCount ?? SunburstConfiguration.defaultMaximumExpandedRingsShownCount)
        }, setValue: { (value) in
            self.maximumExpandedRingsShownCount = UInt(value)
        })
    }

    var maximumExpandedRingsShownCountToggleBinding: Binding<Bool> {
        return Binding<Bool>(getValue: { () -> Bool in
            return self.maximumExpandedRingsShownCount != nil
        }, setValue: { (value) in
            self.maximumExpandedRingsShownCount = value ? SunburstConfiguration.defaultMaximumExpandedRingsShownCount : nil
        })
    }

    // MARK: maximumRingsShownCount bindings

    var maximumRingsShownCountSliderBinding: Binding<Double> {
        return Binding<Double>(getValue: { () -> Double in
            return Double(self.maximumRingsShownCount ?? SunburstConfiguration.defaultMaximumRingsShownCount)
        }, setValue: { (value) in
            self.maximumRingsShownCount = UInt(value)
        })
    }

    var maximumRingsShownCountToggleBinding: Binding<Bool> {
        return Binding<Bool>(getValue: { () -> Bool in
            return self.maximumRingsShownCount != nil
        }, setValue: { (value) in
            self.maximumRingsShownCount = value ? SunburstConfiguration.defaultMaximumRingsShownCount : nil
        })
    }
}

#if DEBUG
struct SettingsView_Previews : PreviewProvider {
    static var previews: some View {
        let configuration = SunburstConfiguration(nodes: [])
        return SettingsView(configuration: configuration)
    }
}
#endif
