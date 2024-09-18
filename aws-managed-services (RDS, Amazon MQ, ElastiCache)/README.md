# AWS Automated Setup for VProfile Application

## Overview
This section documents the automated deployment of the VProfile application using AWS services such as **RDS**, **ElastiCache (Memcached)**, **Amazon MQ (RabbitMQ)**, and **EC2** instances with an **AWS Load Balancer**. All services are configured to work together for a fully functional VProfile application.

## AWS Services Used

1. **Amazon RDS (MySQL)**:
   - **Multi-Zone Setup**: Created a **subnet group** for the RDS to ensure **multi-zone** availability and resilience.
   - **Configuration**: The RDS instance is a **MySQL** database connected directly to the application server (EC2 instance) for managing data storage.

2. **Amazon ElastiCache (Memcached)**:
   - **Memcached** was selected as the caching solution to improve performance.
   - **Connection**: The application server (running on Tomcat) connects to **Memcached** via the **ElastiCache** endpoint, which handles caching operations to reduce database load and improve application response time.
   - **Usage in Application**: The VProfile application uses **Memcached** to store frequently accessed data, ensuring faster retrieval without always querying the database.

3. **Amazon MQ (RabbitMQ)**:
   - **RabbitMQ** was selected as the message broker for handling messaging between various components of the application.
   - **Connection**: The application server is configured to communicate with **RabbitMQ** via **Amazon MQ**. Messages are exchanged between the application and other services (like background jobs) through the RabbitMQ queues.
   - **Usage in Application**: RabbitMQ helps decouple the components of the VProfile application by providing reliable message queuing for tasks such as notifications, job queues, and asynchronous processing.

4. **EC2 Instances**:
   - Created a dedicated **EC2 instance** for the VProfile application.
   - **Tomcat** was installed and configured to run the application, which connects to **RDS (MySQL)**, **ElastiCache (Memcached)**, and **Amazon MQ (RabbitMQ)** for backend services like database storage, caching, and messaging functionalities respectively.

5. **AWS Load Balancer**:
   - Used AWS's **Elastic Load Balancer** (ELB) to distribute traffic across instances.
   - Configured a health check for the load balancer on the `/login` path, ensuring only healthy instances receive traffic.

6. **Security Groups**:
   - Used the same **Security Groups** as previously defined:
     - **Load Balancer Security Group**: Opened port 80 for HTTP traffic.
     - **Application Security Group**: Opened port 8080 for the application, allowing traffic only from the load balancer.
     - **Database and Service Security Group**: Opened ports for MySQL, Memcached (ElastiCache), and RabbitMQ (Amazon MQ), allowing traffic from the application security group (port 8080).
     - Configured **All Traffic** within the security groups to allow free communication between services such as the application, database, cache, and message queue.

## Steps for Configuration

1. **RDS (MySQL) Setup**:
   - Created an RDS MySQL instance and a subnet group for multi-zone availability.
   - Configured the database to connect directly to the application instance.

2. **ElastiCache (Memcached) Setup**:
   - Set up **ElastiCache** with **Memcached** as the caching solution.
   - Connected ElastiCache to the application using the provided **ElastiCache endpoint** in the application’s configuration file.

3. **Amazon MQ (RabbitMQ) Setup**:
   - Configured **Amazon MQ** with **RabbitMQ** as the message broker.
   - Integrated RabbitMQ with the application by using the **Amazon MQ endpoint** to handle messaging tasks (such as job queues and notifications).

4. **EC2 Instance Setup**:
   - Deployed an EC2 instance for the VProfile application.
   - Installed **Tomcat** to run the application, which is connected to **RDS (MySQL)**, **ElastiCache (Memcached)**, and **Amazon MQ (RabbitMQ)** for backend services.

5. **Load Balancer Setup**:
   - Created an AWS Elastic Load Balancer (ELB) for handling incoming traffic to the EC2 instances.
   - Configured the health check to monitor the `/login` path, ensuring the load balancer only forwards traffic to healthy instances.

## Testing and Verification

- **Health Check**: Verified the load balancer's health check is functioning correctly by monitoring the `/login` path.
- **Database Connectivity**: Ensured the EC2 application instance can successfully connect to the RDS MySQL database.
- **Caching and Messaging**: Verified that **Memcached** (ElastiCache) and **RabbitMQ** (Amazon MQ) are integrated and working with the application instance.

---

## Notes and Reminders

### 1. RDS MySQL Configuration:
   - After creating the RDS instance, you will need to log in to complete the database configuration using the **RDS instance endpoint** (this IP or hostname can change based on the setup). Use the following command to log in:
     ```ruby
     mysql -h <RDS-Endpoint> -u admin -p
     ```
   - Once logged in, apply the database backup from the project repository:
     ```ruby
     mysql -h <RDS-Endpoint> -u admin -p mydatabase < /path/to/backup.sql
     ```
   - You can clone the project repository and navigate to the folder containing the SQL backup file:
     ```ruby
     sudo git clone -b main https://github.com/AhmedMahmoud113/vprofile-app-deployment-methods.git
     cd vprofile-app-deployment-methods
     mysql -h <RDS-Endpoint> -u admin -p accounts < src/main/resources/db_backup.sql
     ```

### 2. Java Version Compatibility on EC2 Instance:
   - If the Java version on the instance is **greater than 8**, you may face compatibility issues with Tomcat. To resolve this, follow these steps on your application instance:
     1. Navigate to the Tomcat `bin` directory:
        ```ruby
        cd /usr/local/tomcat/bin
        ```
     2. Edit or create the `setenv.sh` file:
        ```ruby
        sudo nano setenv.sh
        ```
     3. Add the following line to set the necessary environment variables:
        ```ruby
        export CATALINA_OPTS="$CATALINA_OPTS --add-opens java.base/java.lang.invoke=ALL-UNNAMED --add-opens java.base/java.lang=ALL-UNNAMED --add-opens java.base/java.util=ALL-UNNAMED"
        ```
     4. Save the file and restart Tomcat:
        ```ruby
        sudo systemctl restart tomcat
        ```

---

## Future Improvements

- Consider automating the entire setup using **Terraform** or **AWS CloudFormation** for fully automated deployments.
- Explore additional AWS managed services like **RDS Proxy** for improved database connection management.

---

## Contact

For any questions or further information, feel free to reach out:

- **Email**: [ahmedmahmoud0131@gmail.com](mailto:ahmedmahmoud0131@gmail.com)
- **LinkedIn**: [Ahmed Mahmoud](https://www.linkedin.com/in/ahmed-mahmoud-03b938238/)
- **GitHub**: [AhmedMahmoud113](https://github.com/AhmedMahmoud113)

