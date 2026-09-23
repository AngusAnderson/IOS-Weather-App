import SwiftUI

struct WeatherSearchOverlay: View {
    @Bindable var viewModel: WeatherViewModel
    let onDismiss: () -> Void

    @FocusState private var searchFieldFocused: Bool

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                searchField

                resultsList
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .top
                    )
            }
            .frame(
                maxWidth: 620,
                minHeight: 430,
                maxHeight: 430,
                alignment: .top
            )
            .background(
                Color(
                    red: 0.16,
                    green: 0.16,
                    blue: 0.16
                )
                .opacity(0.97)
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 18,
                    style: .continuous
                )
            )
            .overlay {
                RoundedRectangle(
                    cornerRadius: 18,
                    style: .continuous
                )
                .stroke(
                    Color.white.opacity(0.13),
                    lineWidth: 1
                )
            }
            .shadow(
                color: .black.opacity(0.45),
                radius: 30,
                y: 12
            )
            .padding(.horizontal, 24)
        }
        .onAppear {
            searchFieldFocused = true
        }
        .task(id: viewModel.searchText) {
            let trimmedQuery = viewModel.searchText.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

            guard trimmedQuery.count >= 2,
                trimmedQuery.count <= 100 else {
                viewModel.searchResults = []
                viewModel.isSearching = false
                return
            }

            // Prevents a network request happening on every bloody keystroke.
            // Found out the hard way on that one :(.
            do {
                try await Task.sleep(
                    nanoseconds: 300_000_000
                )
            } catch is CancellationError {
                return
            } catch {
                return
            }

            guard !Task.isCancelled else {
                return
            }

            await viewModel.searchLocations()
        }
    }

    private var searchField: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(
                    Color.white.opacity(0.65)
                )

            TextField(
                "Search for a city",
                text: $viewModel.searchText
            )
            .font(.system(size: 20))
            .foregroundStyle(.white)
            .tint(.white)
            .focused($searchFieldFocused)
            .submitLabel(.search)
            .onSubmit {
                Task {
                    await viewModel.searchLocations()
                }
            }

            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.clearSearch()
                    searchFieldFocused = true
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(
                            Color.white.opacity(0.45)
                        )
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Clear search")
            }

            Button {
                onDismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(
                        Color.white.opacity(0.55)
                    )
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Close search")
        }
        .padding(.horizontal, 20)
        .frame(height: 64)
        .background(
            Color.white.opacity(0.08)
        )
    }

    @ViewBuilder
    private var resultsList: some View {
        if viewModel.isSearching {
            HStack(spacing: 10) {
                ProgressView()
                    .tint(.white)

                Text("Searching locations...")
                    .font(.system(size: 15))
                    .foregroundStyle(
                        Color.white.opacity(0.60)
                    )
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )

        } else if viewModel.searchText.count >= 2 &&
                    viewModel.searchResults.isEmpty {
            Text("No locations found")
                .font(.system(size: 15))
                .foregroundStyle(
                    Color.white.opacity(0.55)
                )
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )

        } else if viewModel.searchText.count < 2 {
            Text("Search for a city")
                .font(.system(size: 15))
                .foregroundStyle(
                    Color.white.opacity(0.55)
                )
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )

        } else {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.searchResults) { location in
                        locationRow(location)
                    }
                }
            }
        }
    }

    private func locationRow(
        _ location: LocationSearchResult
    ) -> some View {
        Button {
            Task {
                await viewModel.selectLocation(location)
                onDismiss()
            }
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "mappin")
                    .font(.system(size: 17))
                    .foregroundStyle(
                        Color.white.opacity(0.55)
                    )
                    .frame(width: 24)

                VStack(alignment: .leading, spacing: 3) {
                    Text(location.name)
                        .font(
                            .system(
                                size: 17,
                                weight: .medium
                            )
                        )
                        .foregroundStyle(.white)

                    Text(locationSubtitle(for: location))
                        .font(.system(size: 14))
                        .foregroundStyle(
                            Color.white.opacity(0.55)
                        )
                }

                Spacer()

                Image(systemName: "arrow.up.left")
                    .font(.system(size: 14))
                    .foregroundStyle(
                        Color.white.opacity(0.35)
                    )
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func locationSubtitle(
        for location: LocationSearchResult
    ) -> String {
        [location.admin1, location.country]
            .compactMap { $0 }
            .joined(separator: ", ")
    }
}