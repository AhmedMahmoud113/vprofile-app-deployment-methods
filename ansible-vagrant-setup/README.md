# vProfile Project - Automated Setup with Ansible and Vagrant

## Overview

The **vProfile** project is a multi-tier web application that integrates technologies such as Nginx, Tomcat, MongoDB, MySQL, RabbitMQ, and Memcached. This project uses **Ansible roles** for configuration management and **Vagrant** for provisioning virtual machines, automating the setup process.

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

- **Vagrantfile**: Defines VM configurations (e.g., CPU, memory) and network settings.
- **ansible/**: Contains Ansible playbooks and roles:
  - `site.yml`: Main playbook that runs all the roles.
  - `roles/`: Directory with individual roles for setting up each service:
    - **nginx**: Installs and configures Nginx.
    - **tomcat**: Configures Tomcat for application deployment.
    - **mysql**: Installs MySQL and sets up the database.
    - **rabbitmq**: Installs RabbitMQ as the message broker.
    - **memcached**: Sets up Memcached for caching.
- **scripts/**: Additional shell scripts for any manual setup or configuration tasks.

## Prerequisites

Ensure you have the following software installed on your machine:

- **Vagrant** 
- **VirtualBox** 
- **Git** 
- **Ansible** 

## Installation

Follow these steps to set up the environment:

1. **Clone the Repository**

   ```ruby
   git clone https://github.com/AhmedMahmoud113/vprofile-app-deployment-methods.git
   ```

2. **Navigate to the Automated Setup Directory**

   ```ruby
   cd vprofile-app-deployment-methods/ansible-vagrant-setup
   ```

3. **Start Vagrant**

   ```ruby
   vagrant up
   ```

   Vagrant will provision and configure the virtual machines automatically by running the Ansible playbooks to set up each service.

## How It Works

The setup uses **Ansible** for configuration management and **Vagrant** for creating virtual machines.

- **Vagrant**: Defines multiple virtual machines, allocates resources (CPU, memory), and sets up networking.
- **Ansible**: Ansible roles are used to automate the installation and configuration of each service on the respective VMs.
  - The `site.yml` playbook includes all the roles that install and configure Nginx, Tomcat, MySQL, RabbitMQ, and Memcached.
  - Each role is defined under the `roles/` directory and includes tasks, handlers, templates, and variables.

## Accessing the Application

After running `vagrant up`, access the vProfile application through your browser:

- **URL**:

  ```ruby
  http://app01:8080
  ```

  Replace the IP address with the one configured in your **Vagrantfile** if different.

## Troubleshooting

### Common Issues

#### Vagrant Up Errors

- **Version Compatibility**: Ensure compatible versions of Vagrant, VirtualBox, and Ansible are installed.
- **Networking**: Check if other virtual machines are running on conflicting network interfaces.
- **VM Status**: Run **vagrant status** to verify the state of your VMs.

#### Ansible Playbook Failures

- **Check Ansible Logs**: Use the `--verbose` flag to see detailed output from Ansible playbooks.

  ```ruby
  vagrant provision --provision-with ansible
  ```

- **SSH into VM**: If there’s an issue with a specific role, SSH into the machine and manually check the service:

  ```ruby
  vagrant ssh <vm-name>
  ```

  For example, check the status of Nginx:

  ```ruby
  systemctl status nginx
  ```

### Debugging Tips

- **Provisioning Errors**: Re-run the Ansible provisioning with detailed output for debugging:

  ```ruby
  vagrant provision
  ```

- **Destroy and Recreate VM**: If issues persist, you can destroy and recreate the VM:

  ```ruby
  vagrant destroy <vm-name>
  vagrant up <vm-name>
  ```

## Final Result

The following screenshots demonstrate the final deployment of the **vProfile** application, showcasing the integration of multiple services.

1. **Login Page**: Users authenticate to access the system.
   
![msedge_kBb1vFaQJJ](https://github.com/user-attachments/assets/3c229de9-7e2a-458d-91ac-b68faba3507a)

2. **User Dashboard**: Shows account details and activities.

![msedge_gifbbyCgIF](https://github.com/user-attachments/assets/4010e941-f026-412c-8466-d9e2868eb145)

3. **User Data Before and After Cache**: Demonstrates the caching functionality using Memcached.

Before
![msedge_2BwcpFPRDA](https://github.com/user-attachments/assets/c6ee1c74-c100-47d1-b992-3eafe279f700)

After
![msedge_tjNekIUceu](https://github.com/user-attachments/assets/96dcfec5-005f-469f-a881-14bf77a3f7cd)

## Contact

For any questions or suggestions, feel free to reach out:

- **Email**: [ahmedmahmoud0131@gmail.com](mailto:ahmedmahmoud0131@gmail.com)
- **GitHub**: [AhmedMahmoud113](https://github.com/AhmedMahmoud113)
- **LinkedIn**: [Ahmed Mahmoud](https://www.linkedin.com/in/ahmed-mahmoud-03b938238/)
