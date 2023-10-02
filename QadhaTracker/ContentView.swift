import SwiftUI

struct ContentView: View {
  @State private var isSortMenuOnScreen = false

  @Environment(DataStore.self)
  private var dataStore

  @Environment(\.accessibilityReduceTransparency)
  private var isReduceTransparencyEnabled

  private var sortTypeBinding: Binding<SortType> {
    Binding {
      dataStore.sortType
    } set: { newValue in
      dataStore.sortType = newValue
    }
  }

  var body: some View {
    NavigationStack {
      GeometryReader { proxy in
        ZStack {
          if !isReduceTransparencyEnabled {
            RandomShapeView()
              .edgesIgnoringSafeArea(.all)
          }

          ScrollView {
            MasonryLayout(
              columns: dataStore.columnsCount(basedOn: proxy.size.width),
              spacing: 12.0
            ) {
              ForEach(dataStore.sortedData) { item in
                BubbleView(
                  scale: dataStore.scale(for: item.id),
                  count: dataStore.count(for: item.id)
                ) {
                  Label(
                    LocalizedStringKey(item.localizationKey),
                    systemImage: item.systemImage
                  )
                  .font(.system(.title3, design: .rounded, weight: .medium))
                }
                .environment(\.isEnabled, !isSortMenuOnScreen)
              }
            }
            .padding()
          }
        }
        .onTapGesture {
          isSortMenuOnScreen = false
        }
      }
      .toolbar {
        toolbar
      }
      .navigationTitle("Qadha Tracker")
      .onChange(of: dataStore.sortType) {
        #if os(iOS)
        isSortMenuOnScreen = false
        #endif
      }
    }
  }

  @ToolbarContentBuilder private var toolbar: some ToolbarContent {
    ToolbarItem(placement: isRunningOnWatch ? .bottomBar : .automatic) {
      #if os(iOS)
      Menu {
        sortPicker
          .pickerStyle(.inline)
      } label: {
        Label(
          "Sort",
          systemImage: "arrow.up.arrow.down.circle"
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

  private var sortPicker: some View {
    Picker(
      "Sort",
      selection: sortTypeBinding
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
    .sensoryFeedback(.levelChange, trigger: dataStore.sortType)
  }
}
