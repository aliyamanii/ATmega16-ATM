/*******************************************************
This program was created by the
CodeWizardAVR V3.14 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : ATM System
Version : 1.5
Date    : 5/24/2025
Author  : Grok 3
Company : xAI
Comments: ATM system with 10 users, transfer, and transaction history

Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <mega16.h>
#include <delay.h>
#include <string.h>
#include <stdio.h>

// LCD definitions
#define LCD_RS PORTA.0
#define LCD_RW PORTA.1
#define LCD_EN PORTA.2
#define LCD_D7 PORTA.4
#define LCD_D6 PORTA.5
#define LCD_D5 PORTA.6
#define LCD_D4 PORTA.7

// LED definitions
#define LED_OK PORTC.0
#define LED_ERROR PORTC.1

// Keypad definitions
#define ROWS 4
#define COLS 4

// User structure
typedef struct {
    char username[6]; // 5 chars + null terminator
    char password[6]; // 5 chars + null terminator
    unsigned int balance;
} User;

// Transaction structure
typedef struct {
    int sender_index;
    int recipient_index;
    unsigned int amount;
} Transaction;

// Global variables
char keypad[ROWS][COLS] = {
    {'1', '4', '7', '*'}, // Row 0 (PD0)
    {'2', '5', '8', '0'}, // Row 1 (PD1)
    {'3', '6', '9', '#'}, // Row 2 (PD2)
    {'*', '0', '#', 'D'}  // Row 3 (not used, PD3 not connected)
};

// Array of 10 users
User users[10] = {
    {"12345", "67890", 1000},
    {"23456", "78901", 1500},
    {"34567", "89012", 2000},
    {"45678", "90123", 1200},
    {"56789", "01234", 1800},
    {"67890", "12345", 900},
    {"78901", "23456", 2200},
    {"89012", "34567", 1300},
    {"90123", "45678", 1700},
    {"01234", "56789", 1100}
};

// Transaction history (stores last 2 transactions)
Transaction transactions[2];
unsigned char transaction_count = 0;
unsigned char transaction_index = 0;

char input_username[6] = "";
char input_password[6] = "";
char recipient_username[6] = "";
char input_amount[5] = "";
int current_user_index = -1;

// Function prototypes
void lcd_init(void);
void lcd_cmd(unsigned char);
void lcd_data(unsigned char);
void lcd_string(char*);
char keypad_scan(void);
void clear_input(char*, unsigned char);
int find_user(char*);
int find_recipient(char*);
void wait_for_hash(void);
void add_transaction(int sender_index, int recipient_index, unsigned int amount);

// LCD initialization
void lcd_init(void) {
    LCD_RW = 0; // Ensure RW is always low (write mode)
    lcd_cmd(0x02); // Initialize LCD in 4-bit mode
    lcd_cmd(0x28); // 2 lines, 5x7 matrix
    lcd_cmd(0x0C); // Display on, cursor off
    lcd_cmd(0x06); // Increment cursor
    lcd_cmd(0x01); // Clear display
    delay_ms(2);
}

// Send command to LCD
void lcd_cmd(unsigned char cmd) {
    LCD_D4 = (cmd >> 4) & 0x01;
    LCD_D5 = (cmd >> 5) & 0x01;
    LCD_D6 = (cmd >> 6) & 0x01;
    LCD_D7 = (cmd >> 7) & 0x01;
    LCD_RS = 0;
    LCD_EN = 1;
    delay_ms(1);
    LCD_EN = 0;

    LCD_D4 = cmd & 0x01;
    LCD_D5 = (cmd >> 1) & 0x01;
    LCD_D6 = (cmd >> 2) & 0x01;
    LCD_D7 = (cmd >> 3) & 0x01;
    LCD_RS = 0;
    LCD_EN = 1;
    delay_ms(1);
    LCD_EN = 0;
    delay_ms(2);
}

// Send data to LCD
void lcd_data(unsigned char data) {
    LCD_D4 = (data >> 4) & 0x01;
    LCD_D5 = (data >> 5) & 0x01;
    LCD_D6 = (data >> 6) & 0x01;
    LCD_D7 = (data >> 7) & 0x01;
    LCD_RS = 1;
    LCD_EN = 1;
    delay_ms(1);
    LCD_EN = 0;

    LCD_D4 = data & 0x01;
    LCD_D5 = (data >> 1) & 0x01;
    LCD_D6 = (data >> 2) & 0x01;
    LCD_D7 = (data >> 3) & 0x01;
    LCD_RS = 1;
    LCD_EN = 1;
    delay_ms(1);
    LCD_EN = 0;
    delay_ms(2);
}

// Display string on LCD
void lcd_string(char *str) {
    char *ptr = str;
    while (*ptr) {
        lcd_data(*ptr++);
    }
}

// Scan keypad for key press
char keypad_scan(void) {
    unsigned char row;
    unsigned char col;
    PORTD = 0xF0; // Set rows high, columns as inputs with pull-ups

    for (row = 0; row < ROWS; row++) {
        if (row == 3) continue; // Skip unused row (PD3 not connected)
        PORTD = ~(1 << row); // Set one row low at a time (PD0-PD2)
        delay_ms(10);
        for (col = 0; col < COLS; col++) {
            if (!(PIND & (1 << (col + 4)))) { // Check columns PD4-PD7
                while (!(PIND & (1 << (col + 4)))); // Wait for key release
                return keypad[row][col];
            }
        }
    }
    return 0; // No key pressed
}

// Clear input buffer
void clear_input(char *buffer, unsigned char size) {
    unsigned char i = 0;
    for (; i < size; i++) {
        buffer[i] = '\0';
    }
}

// Find user by username
int find_user(char *username) {
    int i = 0;
    for (; i < 10; i++) {
        if (strcmp(users[i].username, username) == 0) {
            return i;
        }
    }
    return -1; // User not found
}

// Find recipient by username
int find_recipient(char *username) {
    int i = 0;
    for (; i < 10; i++) {
        if (strcmp(users[i].username, username) == 0 && i != current_user_index) {
            return i;
        }
    }
    return -1; // Recipient not found or same as current user
}

// Wait for '#' key to return to menu
void wait_for_hash(void) {
    char key;
    while (1) {
        key = keypad_scan();
        if (key == '#') break;
    }
}

// Add a transaction to the history
void add_transaction(int sender_index, int recipient_index, unsigned int amount) {
    transactions[transaction_index].sender_index = sender_index;
    transactions[transaction_index].recipient_index = recipient_index;
    transactions[transaction_index].amount = amount;
    transaction_index = (transaction_index + 1) % 2; // Circular buffer for 2 transactions
    if (transaction_count < 2) transaction_count++;
}

void main(void) {
    unsigned char i;
    char key;
    char buffer[16];
    unsigned char authenticated = 0;
    int recipient_index;
    unsigned int amount;
    int j;

    // Port A initialization (LCD)
    DDRA = (1<<DDA0) | (1<<DDA1) | (1<<DDA2) | (1<<DDA4) | (1<<DDA5) | (1<<DDA6) | (1<<DDA7); // PA0, PA1, PA2, PA4-PA7 as outputs
    PORTA = 0x00; // Initial state

    // Port C initialization (LEDs)
    DDRC = (1<<DDC0) | (1<<DDC1); // PC0, PC1 as outputs for LEDs
    PORTC = 0x00; // LEDs off initially

    // Port D initialization (Keypad)
    DDRD = 0x0F;  // Rows (PD0-PD3) as outputs, Columns (PD4-PD7) as inputs
    PORTD = 0xF0; // Enable pull-ups on columns

    // Timer/Counter 0 initialization
    TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
    TCNT0=0x00;
    OCR0=0x00;

    // Timer/Counter 1 initialization
    TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
    TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
    TCNT1H=0x00;
    TCNT1L=0x00;
    ICR1H=0x00;
    ICR1L=0x00;
    OCR1AH=0x00;
    OCR1AL=0x00;
    OCR1BH=0x00;
    OCR1BL=0x00;

    // Timer/Counter 2 initialization
    ASSR=0<<AS2;
    TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
    TCNT2=0x00;
    OCR2=0x00;

    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

    // External Interrupt(s) initialization
    MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
    MCUCSR=(0<<ISC2);

    // USART initialization
    UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

    // Analog Comparator initialization
    ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
    SFIOR=(0<<ACME);

    // ADC initialization
    ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

    // SPI initialization
    SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

    // TWI initialization
    TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

    // Initialize LCD
    lcd_init();

    while (1) {
        // Prompt for username
        lcd_cmd(0x01); // Clear display
        lcd_string("Enter UName:");
        lcd_cmd(0xC0); // Move to second line
        i = 0;
        clear_input(input_username, 6);
        while (i < 5) {
            key = keypad_scan();
            if (key && key != '#' && key != '*') {
                input_username[i] = key;
                lcd_data(key);
                i++;
            }
            if (key == '#') break; // Enter key
        }
        input_username[i] = '\0';

        // Prompt for password
        lcd_cmd(0x01); // Clear display
        lcd_string("Enter Pass:");
        lcd_cmd(0xC0); // Move to second line
        i = 0;
        clear_input(input_password, 6);
        while (i < 5) {
            key = keypad_scan();
            if (key && key != '#' && key != '*') {
                input_password[i] = key;
                lcd_data('*'); // Mask password
                i++;
            }
            if (key == '#') break; // Enter key
        }
        input_password[i] = '\0';

        // Validate credentials
        current_user_index = find_user(input_username);
        if (current_user_index != -1 && strcmp(users[current_user_index].password, input_password) == 0) {
            LED_OK = 1;
            LED_ERROR = 0;
            authenticated = 1;
        } else {
            LED_OK = 0;
            LED_ERROR = 1;
            lcd_cmd(0x01);
            lcd_string("Wrong Credentials");
            delay_ms(2000);
            continue;
        }

        // Show menu if authenticated
        while (authenticated) {
            lcd_cmd(0x01);
            lcd_string("1.Bal 2.Transf");
            lcd_cmd(0xC0);
            lcd_string("3.Trsc 4.Oth?");

            key = keypad_scan();
            if (key) {
                lcd_cmd(0x01);
                switch (key) {
                    case '1': // Balance
                        sprintf(buffer, "Acc:%d", current_user_index + 1); // Simplified account number
                        lcd_string(buffer);
                        lcd_cmd(0xC0);
                        sprintf(buffer, "Bal:%d", users[current_user_index].balance);
                        lcd_string(buffer);
                        wait_for_hash(); // Wait for '#' to return to menu
                        break;
                    case '2': // Transfer
                        // Prompt for recipient username
                        lcd_string("Send to:");
                        lcd_cmd(0xC0);
                        i = 0;
                        clear_input(recipient_username, 6);
                        while (i < 5) {
                            key = keypad_scan();
                            if (key && key != '#' && key != '*') {
                                recipient_username[i] = key;
                                lcd_data(key);
                                i++;
                            }
                            if (key == '#') break;
                        }
                        recipient_username[i] = '\0';

                        // Find recipient
                        recipient_index = find_recipient(recipient_username);
                        if (recipient_index == -1) {
                            lcd_cmd(0x01);
                            lcd_string("Recipient Not");
                            lcd_cmd(0xC0);
                            lcd_string("Found");
                            wait_for_hash();
                            break;
                        }

                        // Prompt for amount
                        lcd_cmd(0x01);
                        lcd_string("Enter Amount:");
                        lcd_cmd(0xC0);
                        i = 0;
                        clear_input(input_amount, 5);
                        while (i < 4) {
                            key = keypad_scan();
                            if (key && key != '#' && key != '*' && (key >= '0' && key <= '9')) {
                                input_amount[i] = key;
                                lcd_data(key);
                                i++;
                            }
                            if (key == '#') break;
                        }
                        input_amount[i] = '\0';

                        // Convert amount to integer
                        amount = 0;
                        for (i = 0; i < strlen(input_amount); i++) {
                            amount = amount * 10 + (input_amount[i] - '0');
                        }

                        // Perform transfer
                        if (users[current_user_index].balance >= amount) {
                            users[current_user_index].balance -= amount;
                            users[recipient_index].balance += amount;
                            add_transaction(current_user_index, recipient_index, amount);
                            lcd_cmd(0x01);
                            lcd_string("Transfer");
                            lcd_cmd(0xC0);
                            lcd_string("Complete");
                        } else {
                            lcd_cmd(0x01);
                            lcd_string("Transfer");
                            lcd_cmd(0xC0);
                            lcd_string("Failed");
                        }
                        wait_for_hash();
                        break;
                    case '3': // Transaction
                        if (transaction_count == 0) {
                            lcd_string("No Transactions");
                            lcd_cmd(0xC0);
                            lcd_string("Yet");
                        } else {
                            for (j = 0; j < transaction_count; j++) {
                                int idx = (transaction_index - 1 - j + 2) % 2; // Most recent first
                                sprintf(buffer, "%d-%s-%d", j + 1, users[transactions[idx].recipient_index].username, transactions[idx].amount);
                                if (j == 0) {
                                    lcd_string(buffer);
                                    lcd_cmd(0xC0);
                                } else {
                                    lcd_string(buffer);
                                }
                            }
                        }
                        wait_for_hash();
                        break;
                    case '4': // Other
                        lcd_string("Other Not");
                        lcd_cmd(0xC0);
                        lcd_string("Implemented");
                        wait_for_hash();
                        break;
                    case '*': // Exit
                        authenticated = 0;
                        LED_OK = 0;
                        LED_ERROR = 0;
                        current_user_index = -1;
                        break;
                }
            }
        }
    }
}