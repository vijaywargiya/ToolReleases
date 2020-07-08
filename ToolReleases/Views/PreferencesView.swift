//
//  PreferencesView.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 10/06/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

import Sparkle
import SwiftUI
import ToolReleasesCore

struct PreferencesView: View {
    
    @EnvironmentObject private var toolManager: ToolManager
    
    var body: some View {
        MenuButton(label: menuButton) {
            
            
            CheckboxField(
                id: "beta",
                label: "Include Beta Tools",
                isMarked: toolManager.showBeta,
                callback: checkboxSelected
            )
            
            CheckboxField(
                id: "release",
                label: "Include Release Tools",
                isMarked: toolManager.showRelease,
                callback: checkboxSelected
            )
            
            VStack{
                Divider()
            }
            
            Button(action: showAbout) {
                Text("About")
            }
            Button(action: checkForUpdates) {
                Text("Check for Updates")
            }
            Button(action: quit) {
                Text("Quit")
            }
        }
        .menuButtonStyle(BorderlessButtonMenuButtonStyle())
        .frame(width: 16, height: 16)
    }
    
    var menuButton: some View {
        Button(action: {
        }) {
            Image("gear")
                .resizable()
                .frame(width: 16, height: 16)
        }
        .buttonStyle(BorderlessButtonStyle())
    }
    
    func checkboxSelected(id: String, isMarked: Bool) {
        switch id {
        case "beta":
            toolManager.showBeta = isMarked
        case "release":
            toolManager.showRelease = isMarked
        default:
            print("invalid")
        }
    }
    
    func quit() {
        NSApp.terminate(nil)
    }
    
    func showAbout() {
        let view = AboutView()
        let controller = AboutWindowController(aboutView: view)
        
        if let window = controller.window {
            if let delegate = NSApp.delegate as? AppDelegate {
                delegate.closePopover(sender: nil)
            }
            NSApp.runModal(for: window)
        }
    }
    
    func checkForUpdates() {
        SUUpdater.shared()?.checkForUpdates(nil)
    }
}

//MARK:- Checkbox Field
struct CheckboxField: View {
    let id: String
    let label: String
    let callback: (String, Bool)->()
    
    init(
        id: String,
        label:String,
        isMarked: Bool,
        callback: @escaping (String, Bool)->()
    ) {
        self.id = id
        self.label = label
        self.callback = callback
        self._isMarked = State(initialValue: isMarked)
    }
    
    @State var isMarked:Bool
    
    var body: some View {
        
        Button(label, action: {
                    self.isMarked.toggle()
                    self.callback(self.id, self.isMarked)
                })
        .buttonStyle(CheckboxButtonStyle(isMarked: self.$isMarked))
    }
}


struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}

struct CheckboxButtonStyle: ButtonStyle {
    @Binding var isMarked: Bool
    
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            Image(self.isMarked ? "checkmark" : "square")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.primary)
                .frame(width: 12, height: 12)
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.95: 1)
                .foregroundColor(.primary)
        }
    }
}
