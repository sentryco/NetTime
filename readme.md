[![Tests](https://github.com/sentryco/NetTime/actions/workflows/tests.yml/badge.svg)](https://github.com/sentryco/NetTime/actions/workflows/tests.yml)  [![codebeat badge](https://codebeat.co/badges/5d08d45f-5080-479c-88a5-d2621eac1eb6)](https://codebeat.co/projects/github-com-sentryco-nettime-main)

# 🕑 NetTime

Network-time-synchronization in swift

## Problem

1. ⏰ **Inaccurate Device Time**: Device clocks drift or can be adjusted, leading to unreliable timestamps in time-sensitive apps.

2. 🔄 **Inconsistent Time Synchronization**: Synchronizing time across devices is challenging, causing inconsistencies in systems that rely on precise timing.

3. 🛠️ **Complex Implementation**: Accurate network time synchronization is complex, and existing solutions may lack user-friendly Swift interfaces.

## Solution

1. 🕒 **Reliable Time Sync**: NetTime uses NTP to synchronize device time with network servers, ensuring accuracy despite clock drift.

2. 🤝 **Consistent Time Across Devices**: By fetching standardized network time and adjusting for delays, NetTime synchronizes devices consistently.

3. 🎯 **Simple API**: NetTime offers a straightforward, user-friendly API for easy implementation in Swift applications.

## Features

- ⏰ **Accurate Time Synchronization**: Implements NTP protocol to synchronize device time with network time servers.
- 🛠️ **Simple API**: User-friendly interfaces for fetching and utilizing network time efficiently.
- 💾 **Time Caching**: Stores the server time locally to reduce network calls and improve performance.
- 🌐 **Customizable NTP Servers**: Ability to specify custom NTP servers for specialized requirements.

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

Date.updateTime { result in // Call when app launches etc
    switch result {
    case .success:
        print("☀️ Current Date: \(Date().formatted())")
        print("☎️ Server time: \(Date.serverTime.formatted())")
    case .failure(let error):
        print("Failed to update time: \(error.localizedDescription)")
    }
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


## Todo:
- Do more exploration into side-effects
- Go through the competitors for ways to improve
- add Troubleshooting or FAQ section: If there are common issues users run into, addressing them in the README can save time for both you and the users.
- add Versioning: If you're planning on maintaining this project long-term, it might be helpful to include information about the versioning system you're using.
- add Screenshots or GIFs: If applicable, visual aids can help users understand how your package works or what it looks like when it's running.
- Error Handling and Logging: The current implementation of network requests and error handling could be improved for better reliability and maintainability. For instance, in the updateTime function in Date+NetTime.swift, the error handling is minimal and does not provide detailed feedback for debugging. Action: Enhance error handling by using Result types or throwing errors that can be caught and handled appropriately. Also, improve logging to capture more detailed information about the state and errors.
- Unit Testing: The unit tests could be expanded to cover more scenarios and ensure robustness. For example, the NetTimeTests.swift file shows tests for time conversion and connectivity but could include more comprehensive tests for error cases and edge cases. Action: Add more comprehensive tests, particularly focusing on failure modes and network issues.
- Network Reliability The Reachability.swift utility checks for internet connectivity but could be enhanced to handle different network conditions more robustly. Action: Enhance the network reachability checks to handle various network conditions and provide fallbacks or retries.
- Remove Logger as a dependency. do logging in higher levels of the code etc. ✅