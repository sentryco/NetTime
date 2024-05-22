[![Tests](https://github.com/sentryco/NetTime/actions/workflows/tests.yml/badge.svg)](https://github.com/sentryco/NetTime/actions/workflows/tests.yml)  [![codebeat badge](https://codebeat.co/badges/5d08d45f-5080-479c-88a5-d2621eac1eb6)](https://codebeat.co/projects/github-com-sentryco-nettime-main)

# 🕑 NetTime

Network-time-synchronization in swift

## Features

- Network Time Protocol (NTP) support for accurate time synchronization.
- Easy to use API for fetching and using network time.
- Caching of server time for quick access.
- Compatible with iOS and macOS.

## Requirements

- iOS 17 and later
- macOS 14 and later

## Installation

To add the NetTime package to your Swift project, add the following line to the `dependencies` value of your `Package.swift`.

```swift
.package(url: "https://github.com/sentryco/NetTime", branch: "main")
```

Then include `"NetTime"` in the `dependencies` value of any Target in which you want to use NetTime.

## Usage

Here's an example of how to use NetTime:

```swift
import NetTime

Date.updateTime { // Call when app launches etc
    print("☀️ Current Date: \(Date().formatted())")
    print("☎️ Server time: \(Date.serverTime.formatted())")
}
Date.serverTime // Returns the cached server date
```

## Competitors:
There are several libraries available for network time synchronization in Swift. Here are a few:

1. [TrueTime.swift](https://github.com/instacart/TrueTime.swift): An NTP client for Swift. This library allows you to get the "true" network time, and not rely on the device's system clock.

2. [Kronos](https://github.com/lyft/Kronos): Another NTP based time synchronization library developed by Lyft.

3. [NetClock](https://github.com/troligtvis/NetClock): A simple NTP client to get internet time in Swift.

4. [SwiftNTP](https://github.com/DoubleSymmetry/SwiftNTP): A simple Network Time Protocol client written in Swift.

> [!TIP]
> Remember to check the documentation and the community around these libraries to ensure they fit your needs and are actively maintained.

## Contributing

Contributions are welcome! Please read our [contributing guidelines](CONTRIBUTING.md) for details.

## License

NetTime is released under the MIT License. See [LICENSE](LICENSE) for details.

## Todo:
- Do more exploration into side-effects
- Comb the competitors for ways to improve
