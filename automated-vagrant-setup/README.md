# vProfile Project - Automated Vagrant Setup

## Overview

The **vProfile** project is a multi-tier web application that integrates various technologies such as Nginx, Tomcat, MongoDB, MySQL, RabbitMQ, and Memcached. This automated setup uses Vagrant and custom scripts to provision and configure virtual machines, streamlining the deployment process.

## Table of Contents

- [Overview](#overview)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [How It Works](#how-it-works)
- [Accessing the Application](#accessing-the-application)
- [Troubleshooting](#troubleshooting)
- [Final Result](#final-result)
- [Contact](#contact)

## Project Structure

- **Vagrantfile**: The main configuration file for Vagrant, defining VM specifications and network settings.
- **scripts/**: Directory containing provisioning scripts for each service:
  - `nginx.sh`
  - `tomcat.sh`
  - `mysql.sh`
  - `rabbitmq.sh`
  - `memcache.sh`
- **resources/**: Contains additional configuration files and resources needed for provisioning.

## Prerequisites

Ensure you have the following software installed on your machine:

- **Vagrant** >= 2.x
- **VirtualBox** >= 6.x (or another compatible Vagrant provider)
- **Git** (for cloning the repository)
- **Ansible** (if using Ansible provisioning)

## Installation

Follow these steps to set up the development environment:

1. **Clone the Repository**

   ```ruby
   git clone -b main https://github.com/AhmedMahmoud113/vprofile-app-deployment-methods.git
   ```

2. **Navigate to the Automated Setup Directory**

   ```ruby
   cd vprofile-app-deployment-methods/automated-vagrant-setup
   ```

3. **Start Vagrant**

   ```ruby
   vagrant up
   ```

   This command will automatically create and configure the virtual machines, provisioning all required services.

## How It Works

The automated setup leverages Vagrant's provisioning capabilities along with custom shell scripts to automate the deployment process:

- **Vagrant**: Defines configurations for multiple virtual machines, including CPU, memory, and network settings.
- **Provisioning Scripts**: Each script installs and configures a specific service on its respective VM.
- **Networking**: Sets up private networks and host-only adapters to allow communication between VMs.

## Accessing the Application

Once the **vagrant up** process is complete, you can access the vProfile application through your web browser:

- **URL**:

  ```ruby
  http://app01:8080
  ```

  Replace the IP address with the one configured in your **Vagrantfile** if different.

## Troubleshooting

### Common Issues

#### Vagrant Up Errors

- **Version Compatibility**: Ensure compatible versions of Vagrant and VirtualBox are installed.
- **Network Conflicts**: Check for any running virtual machines that might conflict with network settings.
- **VM Status**: Run **vagrant status** to verify the state of your VMs.

#### Service-Specific Problems

- **SSH into VM**:

  ```ruby
  vagrant ssh <vm-name>
  ```

- **Check Service Status**:

  ```ruby
  systemctl status <service-name>
  ```

  Replace `<service-name>` with services like `nginx`, `tomcat`, `mysql`, etc.

- **View Logs**: Check log files in **/var/log/** for error details.

### Debugging Tips

- **Provisioning Errors**: If a provisioning script fails, you can re-run it:

  ```ruby
  vagrant provision <vm-name>
  ```

- **Destroy and Recreate VM**: As a last resort, you can destroy a VM and recreate it:

  ```ruby
  vagrant destroy <vm-name>
  vagrant up <vm-name>
  ```

## Final Result

The following screenshots showcase the final deployment of the **vProfile** application, demonstrating the integration of multiple services and the web application in action.

### 1. Login Page

![msedge_kBb1vFaQJJ](https://github.com/user-attachments/assets/3c229de9-7e2a-458d-91ac-b68faba3507a)

The login page allows users to authenticate into the vProfile system, featuring secure login functionality.

### 2. User Dashboard

![msedge_gifbbyCgIF](https://github.com/user-attachments/assets/4010e941-f026-412c-8466-d9e2868eb145)

Once logged in, users can access their dashboard to view and manage their account details, activities, and personal information.

### 3. User List

![msedge_KP2GNEEbGw](https://github.com/user-attachments/assets/924e6bee-80cb-4864-b627-35a35b79bcc1)

This page displays a list of all users registered in the system. Admins can view user details and IDs.

### 4. User Data Before Cache

![msedge_2BwcpFPRDA](https://github.com/user-attachments/assets/c6ee1c74-c100-47d1-b992-3eafe279f700)

This screenshot shows the user's primary and extra details fetched directly from the database before being cached.

### 5. User Data After Cache

![msedge_tjNekIUceu](https://github.com/user-attachments/assets/96dcfec5-005f-469f-a881-14bf77a3f7cd)

Here, the same user data is displayed, but now it's retrieved from the cache for faster access, showcasing the caching functionality.

## Contact

For any inquiries or suggestions, please feel free to reach out:

- **Email**: [ahmedmahmoud0131@gmail.com](mailto:ahmedmahmoud0131@gmail.com)
- **GitHub**: [AhmedMahmoud113](https://github.com/AhmedMahmoud113)
- **LinkedIn**: [Ahmed Mahmoud](https://www.linkedin.com/in/ahmed-mahmoud-03b938238/)
