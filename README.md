# AI Weather App

An intelligent, SwiftUI-based iOS weather application designed to provide personalized, actionable insights by translating complex environmental data into clear, human-friendly advice.

---

## Core Concept

Traditional weather apps provide raw data, leaving the user to interpret what it means for their life. AI Weather Advisor is built on a different philosophy. It leverages a powerful generative AI to act as a personal assistant, answering the questions users actually care about: "What does this weather *feel* like?", "How will it affect my plans?", and "Is there anything in the environment today that could impact my well-being?".

---

## Features & Implementation Status

The application is architected around a central Tab Bar for a clear and intuitive user experience.

### Implemented Features

* **The "Now" Tab (Home Screen):**
    * Provides an at-a-glance summary of the current weather for the user's primary location.
    * Features a unique, AI-generated greeting that creatively describes the day's feel and suggests a relevant activity.
    * The entire app UI is driven by a dynamic, theme-aware system that changes the background and aesthetic based on live weather conditions (e.g., Clear Day, Cloudy Night, Rain).

* **The "Planner" Tab (Conversational AI):**
    * A fully interactive, message-based interface for planning activities.
    * The AI has conversational memory, allowing for follow-up questions.
    * It has access to the user's current weather context, enabling it to answer questions like "Is it good for a hike right now?" without needing the user to repeat their location.

* **The "Health" Hub (Data-Rich Dashboard):**
    * A modular, card-based dashboard displaying key environmental health metrics.
    * Successfully integrates three separate, free APIs to display live data for:
        1.  **UV Index** (from OpenUV)
        2.  **Air Quality Index (AQI)** (from World Air Quality Index Project)
        3.  **"Feels Like" Temperature & Humidity** (from OpenWeatherMap)
    * Each card features an AI-generated insight, providing actionable advice based on the live data.

### Future Development (Roadmap)

* **Enhanced Planner Intelligence:**
    * Integrate multi-day/hourly forecast data to allow the AI to answer complex future-planning questions (e.g., "What is the best 3-hour window on Saturday to go for a run?").
* **Personalized Health Hub:**
    * Integrate new data sources for allergens (pollen).
    * Allow users to set personal sensitivities and opt-in to proactive health alerts.
* **Backend & Settings Tab Integration:**
    * Implement a full-stack backend using **Supabase** for user accounts and data persistence.
    * Build out the Settings UI to allow users to manage a list of saved locations and personalize app preferences (e.g., temperature units), which will be synced to their account.

---

## Technical Architecture

The application is built using a modern, scalable, and state-driven architecture to ensure a seamless and robust user experience.

* **UI Framework:** **SwiftUI**. The UI is built declaratively, with an emphasis on creating small, reusable components (`ChatBubble`, `HealthCardView`, etc.).
* **State Management:** The app's state is managed centrally by shared `ObservableObject` classes (`WeatherViewModel`, `ThemeManager`). These objects are injected into the SwiftUI `Environment`, providing a single source of truth that all views can react to, eliminating data silos and ensuring consistency across tabs.
* **Concurrency:** All network operations utilize modern **Swift Concurrency** (`async`/`await`) and are kicked off within a `Task`, ensuring the main UI thread is never blocked and the app remains smooth and responsive.
* **API Services:**
    * **Weather:** OpenWeatherMap API
    * **UV Index:** OpenUV API
    * **Air Quality:** WAQI API
    * **AI Engine:** Google Gemini API
* **Security:** API keys are stored securely in a `Secrets.plist` file, which is explicitly excluded from version control via a `.gitignore` file to prevent secrets from being exposed in the public repository.

---

## Project Setup

### Prerequisites

* Xcode
* An Apple Developer Account
* API keys from:
    * [OpenWeatherMap](https://openweathermap.org/api)
    * [Google AI Studio (Gemini)](https://aistudio.google.com/)
    * [OpenUV](https://www.openuv.io/)
    * [World Air Quality Index Project](https://aqicn.org/data-platform/token/)

### Instructions

1.  Clone the repository to your local machine.
2.  Open the `.xcodeproj` file in Xcode.
3.  In the project's root directory, create a new file named `Secrets.plist`.
4.  Open `Secrets.plist` as Source Code and populate it with your keys using the following structure:
    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "[http://www.apple.com/DTDs/PropertyList-1.0.dtd](http://www.apple.com/DTDs/PropertyList-1.0.dtd)">
    <plist version="1.0">
    <dict>
        <key>OPENWEATHER_API_KEY</key>
        <string>YOUR_KEY_HERE</string>
        <key>GEMINI_API_KEY</key>
        <string>YOUR_KEY_HERE</string>
        <key>OPENUV_API_KEY</key>
        <string>YOUR_KEY_HERE</string>
        <key>WAQI_API_KEY</key>
        <string>YOUR_KEY_HERE</string>
    </dict>
    </plist>
    ```
5.  Ensure `Secrets.plist` is listed in your `.gitignore` file.
