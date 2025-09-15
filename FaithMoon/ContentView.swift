import SwiftUI

struct ContentView: View {
  @State private var isSortMenuOnScreen = false

  @Environment(KeyValueStore.self)
  private var dataStore

  @Environment(\.modelContext)
  private var modelContext

  @Environment(\.accessibilityReduceTransparency)
  private var isReduceTransparencyEnabled

  @State private var sortDescriptors = [SortDescriptor(\Prayer.intrinsicOrder)]

  var body: some View {
    NavigationStack {
      ZStack {
        if
          isiOS || isRunningOnWatch,
          !isiOSAppRunningOnMac,
          !isReduceTransparencyEnabled {
          RandomShapeView()
            .edgesIgnoringSafeArea(.all)
        }

        PrayersListView(sort: sortDescriptors)
          .environment(\.isEnabled, !isSortMenuOnScreen)
      }
      .onTapGesture {
        isSortMenuOnScreen = false
      }
      .toolbar {
        toolbar
      }
      .navigationTitle("Qadha Tracker")
    }
    .onChange(of: dataStore.sortType, initial: true) { _, newValue in
      if !isRunningOnWatch {
        isSortMenuOnScreen = false
      }

      withAnimation(.bouncySpring) {
        sortDescriptors = switch newValue {
        case .ascending:
          [
            SortDescriptor(\.count, order: .forward),
            SortDescriptor(\.intrinsicOrder, order: .forward)
          ]
        case .descending:
          [
            SortDescriptor(\.count, order: .reverse),
            SortDescriptor(\.intrinsicOrder, order: .forward)
          ]
        case .default:
          [
            SortDescriptor(\.intrinsicOrder, order: .forward)
          ]
        }
      }
    }
  }

  private var historyNavigation: some View {
    NavigationLink(destination: LogView()) {
      Label("History", systemImage: "clock")
    }
  }

  @ToolbarContentBuilder private var toolbar: some ToolbarContent {
    #if !os(watchOS)
    ToolbarItem(placement: .navigation) {
      historyNavigation
    }
    #else
    ToolbarItem(placement: .automatic) {
      historyNavigation
    }
    #endif

    ToolbarItem(placement: isRunningOnWatch ? .bottomBar : .automatic) {
      #if os(iOS) || os(visionOS)
      Menu {
        sortPicker
          .pickerStyle(.inline)
      } label: {
        Label(
          "Sort",
          systemImage: "arrow.up.arrow.down"
        )
      }
      .onTapGesture {
        isSortMenuOnScreen = true
      }
      #else
      HStack {
        Button {
          isSortMenuOnScreen = true
        } label: {
          Label(
            "Sort",
            systemImage: "arrow.up.arrow.down"
          )
          .labelStyle(.iconOnly)
        }
        .sheet(isPresented: $isSortMenuOnScreen) {
          sortPicker
        }

        Spacer()
      }
      #endif
    }
  }

  @ViewBuilder private var sortPicker: some View {
    @Bindable var store = dataStore

    Picker(
      "Sort",
      selection: $store.sortType
    ) {
      Label(
        "Default",
        systemImage: "arrow.triangle.2.circlepath"
      )
      .tag(SortType.default)

      Label(
        "Ascending",
        systemImage: "text.line.last.and.arrowtriangle.forward"
      )
      .tag(SortType.ascending)

      Label(
        "Descending",
        systemImage: "text.line.first.and.arrowtriangle.forward"
      )
      .tag(SortType.descending)
    }
    .preferredLevelChangeSensoryFeedback(trigger: dataStore.sortType)
  }
}

#Preview {
  let container = DataController().previewContainer
  let store = KeyValueStore()

  return GeometryReader { proxy in
    ContentView()
      .environment(store)
      .environment(\.mainWindowSize, proxy.size)
      .modelContainer(container)
  }
}
