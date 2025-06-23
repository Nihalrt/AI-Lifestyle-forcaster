# AI Weather App

## Screenshots
<img width="300" alt="Image" src="https://github.com/user-attachments/assets/25710671-ce29-4e1d-9c7e-0474782748d3" />
<img width="300" alt="Image" src="https://github.com/user-attachments/assets/88db133e-fb7b-4667-bb8d-a36dc61ceaf8" />

*(Note: Replace the placeholder images above with actual screenshots of the app by updating the URLs.)*

**Nimbus** is a modern, SwiftUI-based iOS application designed to reinvent the way we interact with weather data. Moving beyond simple forecasts, Nimbus acts as a personal, proactive assistant that translates complex environmental data into meaningful, personalized advice for your life, activities, and well-being.

---

## Core Concept

The problem with traditional weather apps is that they give you data, not answers. They tell you it's `19°C` with `75% humidity`, but leave it up to you to figure out what that *means* for your plans.

Nimbus is built on a different philosophy. Our core goal is to answer the questions you actually care about:
- **"What does today *feel* like?"**
- **"How will the weather affect my plans?"**
- **"Is there anything in the environment today that could impact my health?"**

To achieve this, we leverage the **Google Gemini AI** as our core reasoning engine, creating a seamless, conversational, and intelligent user experience.

---

## Features

Our feature set is organized into a clean, intuitive Tab Bar interface.

### Implemented Features

* **The "Now" Tab (Home Screen):**
    * Displays the current temperature and weather conditions for the user's primary location.
    * Features a unique, AI-generated greeting that provides a creative, one-sentence summary of the day's feel and suggests a simple activity.
    * Showcases a beautiful, dynamic background theme that changes based on the live weather conditions (e.g., clear day, cloudy night, rain).

* **The "Planner" Tab:**
    * A fully interactive, conversational chat interface for planning activities.
    * Powered by a "smart" AI that has contextual knowledge of the user's current location and weather.
    * Features a modern, futuristic UI with a "frosted glass" input bar and tappable suggestion chips.

* **The "Health" Tab (UI Shell):**
    * A clean, modular dashboard built with a card-based layout.
    * Displays live "Feels Like" and "Humidity" data.
    * Includes placeholder cards for UV Index and Air Quality, ready for future data integration.

### Future Roadmap

* **Full Planner Integration:** Feed the Planner AI with multi-day and hourly forecast data to enable complex questions like, "Find a 3-hour window on Saturday with no rain."
* **Live Health Data:** Integrate new APIs to populate the UV Index and Air Quality cards with live data and generate AI-driven health insights.
* **Personalized Allergy Hub:** Allow users to specify their sensitivities (e.g., grass pollen) for targeted alerts.
* **Supabase Backend Integration:**
    * **User Accounts:** Implement secure user sign-up and login.
    * **Saved Locations:** Allow users to save and manage a list of multiple locations.
    * **Synced Preferences:** Save user preferences (like temperature units and health alerts) to the cloud, synced across their devices.

---

##  Tech Stack & Architecture

This project is built using a modern, scalable, and state-driven architecture.

* **UI Framework:** **SwiftUI**. We use a declarative, component-based approach.
* **State Management:** The app is driven by a centralized state management system using `ObservableObject` and `@EnvironmentObject`.
    * `ThemeManager`: A shared manager that controls the app-wide visual theme based on live weather, ensuring a seamless UX.
    * `WeatherViewModel`: A shared manager that holds the current weather data, ensuring all views have access to a single source of truth.
* **Asynchronous Operations:** We use modern Swift Concurrency (`async`/`await`) and `Task` for all network calls to ensure the UI remains smooth and responsive.
* **API Services:**
    * **Weather Data:** [**OpenWeatherMap API**](https://openweathermap.org/api) for real-time and forecasted weather data.
    * **AI Engine:** [**Google Gemini API**](https://ai.google.dev/) for all natural language processing, summarization, and conversational features.

### Architectural Principles

1.  **Separation of Concerns:** Each component has a single, clear responsibility.
    * **Views (`ContentView`, `PlannerView`, etc.):** Responsible only for displaying data and handling user input.
    * **Service Managers (`NetworkManager`, `AIManager`):** Responsible only for communicating with external APIs.
    * **View Models / State Managers (`WeatherViewModel`, `ThemeManager`):** Responsible for holding and managing the app's state.
2.  **Modularity & Reusability:** We build smaller, reusable components (like `ThemedBackgroundView` and `HealthCardView`) to maintain a clean codebase and ensure design consistency.
3.  **Secure Key Management:** All API keys are stored securely in a `Secrets.plist` file, which is excluded from version control via `.gitignore`. A `KeyManager` utility provides safe access to these keys.

---

## Getting Started

### Prerequisites

* macOS with Xcode installed.
* An Apple Developer account (for running on a physical device).
* API keys from [OpenWeatherMap](https://openweathermap.org/api) and [Google AI Studio](https://aistudio.google.com/).

### Setup Instructions

1.  Clone the repository:
    ```bash
    git clone [your-repository-url]
    ```
2.  Open the `.xcodeproj` file in Xcode.
3.  In the main project folder, create a new file named **`Secrets.plist`**. It's crucial to get the name exactly right.
4.  Open `Secrets.plist` as source code and add your API keys using the following XML structure:
    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "[http://www.apple.com/DTDs/PropertyList-1.0.dtd](http://www.apple.com/DTDs/PropertyList-1.0.dtd)">
    <plist version="1.0">
    <dict>
        <key>OPENWEATHER_API_KEY</key>
        <string>YOUR_OPENWEATHER_API_KEY_HERE</string>
        <key>GEMINI_API_KEY</key>
        <string>YOUR_GEMINI_API_KEY_HERE</string>
    </dict>
    </plist>
    ```
5.  Ensure that `Secrets.plist` is included in your project's `.gitignore` file to prevent your keys from being committed to source control.
6.  Build and run the project (Cmd + R).
