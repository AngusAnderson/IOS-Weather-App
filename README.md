```text
▗▄▄▖  ▗▄▖ ▗▖ ▗▖  ▗▖    ▗▖ ▗▖▗▄▄▄▖ ▗▄▖▗▄▄▄▖▗▖ ▗▖▗▄▄▄▖▗▄▄▖ 
▐▌ ▐▌▐▌ ▐▌▐▌  ▝▚▞▘     ▐▌ ▐▌▐▌   ▐▌ ▐▌ █  ▐▌ ▐▌▐▌   ▐▌ ▐▌
▐▛▀▘ ▐▌ ▐▌▐▌   ▐▌      ▐▌ ▐▌▐▛▀▀▘▐▛▀▜▌ █  ▐▛▀▜▌▐▛▀▀▘▐▛▀▚▖
▐▌   ▝▚▄▞▘▐▙▄▄▖▐▌      ▐▙█▟▌▐▙▄▄▖▐▌ ▐▌ █  ▐▌ ▐▌▐▙▄▄▖▐▌ ▐▌
```                                              

# iOS Weather App

Weather application made using SwiftUI that provides live weather conditions, hourly forecasts, city search, and a colour based weather system that is powered by the Open-Meteo API.

## Features

- Live current weather for a searched location.
- Current temperature, condition, feels-like temperature, humidity, UV index, wind speed, wind direction, sunrise and sunset times.
- Six-hour forecast with upcoming hourly temperatures.
- City search powered by Open-Meteo Geocoding.
- Selected location is kept and restored when the app is reopened.
- First launch screen that optionally collects a preferred display name.
- Time-aware greeting: Good Morning, Good Afternoon, or Good Evening depending on the time - some advanced stuff in this thing.
- Interactive sheet that displays the weather data.
- Colour-coded weather conditions from the Open-Meteo WMO weather codes then put into groups.
- Weather-colour legend and name controls in the Help & Settings sheet.
- Refresh control for loading current weather data again.
- Native SwiftUI interface designed for iPhone.

## Tech Stack

- Swift
- SwiftUI
- Observation framework
- URLSession
- UserDefaults and `@AppStorage`
- Open-Meteo Forecast API
- Open-Meteo Geocoding API

## Architecture

The project separates interface code, data models, networking, visual styling, and screen state.

```text
IOS-Weather-App/
├── DesignSystem/
│   ├── Color+Hex.swift
│   └── WeatherConditionStyle.swift
├── Fonts/
|   ├── RobotoMono-Italic.ttf
|   └── RobotoMono-Regular.ttf
├── Models/
│   ├── LocationSearchResult.swift
│   ├── OpenMeteoResponse.swift
│   └── WeatherViewData.swift
├── Services/
│   ├── OpenMeteoService.swift
|   └── NetworkMonitor.swift
├── Utilities/
|   ├── GreetingProvider.swift
|   ├── HourlyForecastBuilder.swift
|   └── WindDirection.swift
├── ViewModels/
│   └── WeatherViewModel.swift
├── Views/
│   └── Home/
│       ├── ContentView.swift
│       ├── GreetingHeader.swift
│       ├── Hero.swift
│       ├── WeatherBottomSheet.swift
│       ├── WeatherSearchOverlay.swift
│       ├── NameSetupView.swift
│       ├── HelpSettingsView.swift
│       └── Buttons/
│           ├── ControlButtonStyle.swift
│           └── SearchButtonStyle.swift
└── WeatherApp.swift
```

## API Integration

The app uses Open-Meteo for weather and location-search data.

### Forecast data

The forecast request uses a selected location’s latitude and longitude to retrieve (because city or town name was too easy):

- Current temperature.
- 'Feels like' temperature.
- Humidity.
- Weather code (for colour codes).
- Wind speed and direction.
- Hourly temperatures and weather codes.
- Sunrise and sunset.
- UV index.

### Location search

The user searches for a city name, then that city name is passed to the Open-Meteo Geocoding API and the app then uses that location’s coordinates to retrieve forecast data.

No API key is required for the Open-Meteo endpoints used by this project.

## Weather colours

Open-Meteo provides WMO weather codes. The app maps them into a small set of reusable visual categories.

| Colour category | Conditions |
| --- | --- |
| Clear | Clear sky |
| Cloudy | Partly cloudy, or overcast |
| Fog | Fog or low visibility |
| Drizzle | Light to dense drizzle |
| Rain | Rain or rain showers |
| Snow | Snow, snow showers, or freezing rain |
| Thunderstorm | Thunderstorms, including hail |

The same colour mapping is used in the Hero temperature circle, the current-condition circle, the hourly forecast markers, and the Help & Settings legend.

## Getting Started

### Requirements

- macOS with Xcode installed.
- iOS 17 or later recommended.
- An Apple ID configured in Xcode for running on a physical device.
- Internet access for Open-Meteo requests.

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/AngusAnderson/IOS-Weather-App.git
   ```

2. Open the project:

   ```bash
   cd IOS-Weather-App
   open IOS-Weather-App.xcodeproj
   ```

3. In Xcode, choose an iPhone simulator or connected iPhone.

4. Select the `IOS-Weather-App` scheme.

5. Build and run with `Cmd + R`.

## Persistence

The app stores small preferences locally on the device:

- The last selected weather location.
- The user’s optional display name.
- Whether the first-launch name onboarding has been completed.

Weather data itself is fetched again from Open-Meteo when the app launches, ensuring that displayed conditions remain current.

## Roadmap

- [x] Create the core SwiftUI weather interface.
- [x] Integrate Open-Meteo live weather data.
- [x] Add hourly forecast data.
- [x] Add city search.
- [x] Persist the selected location.
- [x] Add first-launch name onboarding.
- [x] Add colour-coded weather conditions.
- [x] Add colour legend and name controls.
- [ ] Add saved/favourite locations.
- [ ] Add light, dark, and automatic appearance settings.

## Attribution

Weather data is provided by [Open-Meteo](https://open-meteo.com/).

Open-Meteo uses weather data from multiple national weather services and weather models. Review Open-Meteo’s terms and attribution requirements before distributing a production version of the app.

## License

Copyright © 2026 Angus Anderson. All rights reserved.

The source code is shared for portfolio and educational viewing purposes only.
It may not be copied, modified, distributed, or used without prior written
permission.