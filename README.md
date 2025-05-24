# ATM System Project

![image](https://github.com/user-attachments/assets/94ba38f4-3f48-429c-86c5-f413775d9c1b)


## Overview

This repository contains the source code for an ATM (Automated Teller Machine) system implemented on an ATmega16 microcontroller. The system features user authentication for up to 10 users, balance checking, money transfer between users, and a transaction history display. The project uses an LCD for user interface, a keypad for input, and LEDs for status indication.

## Features

- **User Management**: Supports 10 predefined users with unique usernames, passwords, and initial balances.
- **Authentication**: Users can log in using a 5-digit username and password.
- **Balance Check**: Displays the user's account number and current balance.
- **Transfer Functionality**: Allows users to transfer money to other registered users with validation for sufficient balance.
- **Transaction History**: Shows the last 2 transactions, including recipient username and amount.
- **Navigation**: Returns to the main menu after actions using the '#' key on the keypad.
- **Status Indicators**: Uses green LED for OK and red LED for ERROR states.

## Hardware Requirements

- **Microcontroller**: ATmega16
- **LCD**: LM016L (connected to PORTA: RS->PA0, RW->PA1, E->PA2, D4->PA7, D5->PA6, D6->PA5, D7->PA4)
- **Keypad**: 4x4 keypad (rows connected to PD0-PD2, columns to PD4-PD7)
- **LEDs**: Green LED (OK) on PC0, Red LED (ERROR) on PC1
- **Clock**: 8.000000 MHz

## Software Requirements

- **Compiler**: CodeVisionAVR V3.14 or compatible AVR compiler
- **Libraries**: Includes `<mega16.h>`, `<delay.h>`, `<string.h>`, `<stdio.h>`

## Installation

1. Clone the repository:
   ```
   git clone https://github.com/aliyamanii/ATmega16-ATM.git
   ```
2. Open the project in CodeVisionAVR or your preferred AVR development environment.
3. Compile the `ATM.c` file.
4. Flash the compiled hex file to the ATmega16 microcontroller using a programmer (e.g., AVRISP mkII).
5. Connect the hardware as per the schematic and power on the system.

## Usage

1. **Login**:

   - Enter a 5-digit username (e.g., "12345") and press '#'.
   - Enter the corresponding 5-digit password (e.g., "67890") and press '#'.
   - The green LED indicates successful login; red LED indicates failure.

2. **Main Menu**:

   - Options displayed: `1.Bal 2.Transf 3.Trsc 4.Oth?`
   - Press the corresponding key (1, 2, 3, 4, or \* to exit).

3. **Balance (1)**:

   - Displays `Acc:<number>` and `Bal:<amount>` (e.g., `Acc:1 Bal:1000`).
   - Press '#' to return to the menu.

4. **Transfer (2)**:

   - Enter recipient username (e.g., "23456") and press '#'.
   - Enter amount (e.g., "500") and press '#'.
   - Shows `Transfer Complete` or `Transfer Failed`. Press '#' to return.

5. **Transaction History (3)**:

   - Displays the last 2 transactions (e.g., `1-23456-500` and `2-34567-200`).
   - If no transactions, shows `No Transactions Yet`.
   - Press '#' to return.

6. **Other (4)**:

   - Displays `Other Not Implemented`.
   - Press '#' to return.

7. **Logout**:
   - Press '\*' to log out and return to the login screen.

## Code Structure

- **`ATM.c`**: Contains the main program logic, including LCD control, keypad input, user management, and menu options.
- **Functions**:
  - `lcd_init`, `lcd_cmd`, `lcd_data`, `lcd_string`: LCD operations.
  - `keypad_scan`: Reads keypad input.
  - `clear_input`: Clears input buffers.
  - `find_user`, `find_recipient`: Searches for users.
  - `wait_for_hash`: Waits for '#' key.
  - `add_transaction`: Stores transaction history.

## Known Issues

- Transaction history resets on power-off (stored in RAM).
- The keypad's 4th row (PD3) is not connected, limiting special keys (\*, 0, #) to 'A', 'B', 'C' mappings.

## Contributing

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Commit your changes and push to your branch.
4. Submit a pull request with a description of your changes.

## Version History

- **1.5 (May 24, 2025)**: Added transaction history, fixed balance display, added '#' key navigation.
- **1.4 (May 24, 2025)**: Implemented 10 users and transfer functionality.
