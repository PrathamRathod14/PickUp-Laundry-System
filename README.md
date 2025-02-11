# PickupLaundry Web Application

## Overview
PickupLaundry is a web-based application designed to facilitate online laundry service management. This project provides features for both administrators and users, streamlining the process of placing, managing, and tracking laundry orders.

## Features
### Admin Features
- User management: View, register, and manage users.
- Order management: View and update laundry orders.
- Reporting: Generate and view reports related to orders.

### User Features
- Account registration and login.
- Place and track laundry orders.
- View order history.

## Project Structure
```
PickupLaundry/
├── build.xml                  # Apache Ant build configuration
├── build/
│   └── web/
│       ├── index.html          # Main entry point for the web application
│       └── Admin/              # Admin-related JSP files
│           ├── Homepage.jsp
│           ├── Login.jsp
│           ├── Registration.jsp
│           └── Reports.jsp
└── PL_PracticalList.pdf        # Project documentation 
```

## Technologies Used
- **Frontend:** HTML, JSP
- **Backend:** Java Servlets, JSP
- **Build Tool:** Apache Ant
- **Database:** (Assumed) JDBC-compatible database

## Prerequisites
To set up and run this project, you need:
- JDK (Java Development Kit) installed
- Apache Tomcat or any other Java web server
- Apache Ant for building the project

## Setup Instructions
1. Clone the project or extract the ZIP file:
   ```bash
   git clone <repository-url>
   ```

2. Navigate to the project directory:
   ```bash
   cd PickupLaundry
   ```

3. Build the project using Apache Ant:
   ```bash
   ant build
   ```

4. Deploy the project to Apache Tomcat:
   - Copy the `build/web` directory to the `webapps` directory of your Tomcat server.

5. Start the Tomcat server and access the application at:
   ```
   http://localhost:8080/PickupLaundry
   ```

## Usage
1. **Admin Login:**
   - Navigate to the Admin login page: `/Admin/Login.jsp`
2. **User Registration and Login:**
   - Access the registration page and create a user account.
3. **Managing Orders:**
   - Admin can view and manage orders via the dashboard.

## License
This project is licensed under [MIT License](LICENSE).

