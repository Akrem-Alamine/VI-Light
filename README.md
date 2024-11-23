# Smart Lighting Control System

This repository contains the **Smart Lighting Control System**, a project aimed at enhancing energy efficiency and simplifying the management of outdoor lighting for a corporate building. The system combines modern technologies such as Flutter for mobile applications, ESP8266 microcontrollers for hardware control, and WebSocket protocol for seamless communication.

---

## 🚀 Features

- **Manual and Automatic Modes**: 
  - Manually control lights via the app.
  - Automatic lighting adjustment based on calculated sunrise and sunset times.
- **Wireless Communication**: Real-time communication between the app and the ESP8266 using WebSocket over a local network.
- **User-Friendly Interface**: An intuitive Flutter-based application designed for simplicity and ease of use.
- **Standalone Solution**: Operates without requiring an internet connection, using an RTC module for timekeeping.

---

## 🛠️ Technologies Used

- **Flutter**: Cross-platform mobile development framework for the application.
- **ESP8266**: Microcontroller for hardware control of relays connected to the lights.
- **WebSocket**: Protocol for efficient two-way communication.
- **RTC Module**: Maintains accurate time for automatic mode functionality.

---

## 📁 Project Structure

```
├── app/                    # Flutter application code
│   ├── lib/                # Main Flutter application files
│   ├── assets/             # Application assets
│   └── pubspec.yaml        # Dependencies and configuration
├── esp8266/                # ESP8266 firmware code
│   ├── src/                # Source files for microcontroller
│   ├── include/            # Header files
│   └── platformio.ini      # PlatformIO configuration
├── docs/                   # Documentation
└── README.md               # Project overview
```

---

## 📲 How to Use

### **Flutter Application**

1. Install Flutter from the [official site](https://flutter.dev/docs/get-started/install).
2. Clone the repository and navigate to the `app/` directory:
   ```bash
   git clone https://github.com/username/repository-name.git
   cd app/
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app on an emulator or a connected device:
   ```bash
   flutter run
   ```

### **ESP8266 Firmware**

1. Install PlatformIO for VS Code or another IDE from [PlatformIO](https://platformio.org/).
2. Navigate to the `esp8266/` directory:
   ```bash
   cd esp8266/
   ```
3. Build and upload the firmware to your ESP8266 device:
   ```bash
   pio run --target upload
   ```

---

## 🤝 Collaboration

We welcome contributions to improve this project! Here’s how you can help:

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature-name`.
3. Commit changes: `git commit -m 'Add some feature'`.
4. Push the branch: `git push origin feature-name`.
5. Open a pull request.

---

## 📝 License

This project is licensed under the MIT License. See the `LICENSE` file for details.

---

## 📧 Contact

For any inquiries, suggestions, or feedback, please reach out to:
- **Author**: Akrem Alamine  
- **Email**: [akrem.alamine@gmail.com](mailto:akrem.alamine@gmail.com)  
- **LinkedIn**: [[Your LinkedIn Profile](https://www.linkedin.com/in/akrem-alamine/)](https://www.linkedin.com/in/your-profile)

---

Let’s build a smarter and more energy-efficient future together! 🌟
