# AWS Automated Setup for vProfile Application

## Overview
This section outlines the automated deployment of the VProfile application on AWS. The setup includes the creation of a custom VPC, subnets, route tables, security groups, and EC2 instances for each service. Nginx is configured to run on a cloud load balancer (ALB), and each service is deployed on its own EC2 instance.

## VPC and Subnets

1. **VPC**:
   - CIDR Block: `10.0.0.0/16`
   - Created a custom VPC to isolate the network.

2. **Subnets**:
   - **Subnet 1**: `10.0.1.0/16` (Used for public instances)
   - **Subnet 2**: `10.0.2.0/16` (Used for private instances)

3. **Route Table**:
   - Created a route table and associated it with both subnets.
   - Added routes for internet access through the **Internet Gateway**.

4. **Internet Gateway**:
   - Created and attached an **Internet Gateway** to allow external access to public instances.

## Security Groups

1. **Load Balancer Security Group**:
   - Opened **Port 80** for HTTP traffic from the internet.

2. **Application Security Group**:
   - Opened **Port 8080** for the application, allowing traffic only from the **Load Balancer** security group.

3. **Database and Service Security Group**:
   - Opened ports for the following services, allowing traffic from the **Application Security Group** (port 8080):
     - **MySQL**: Port 3306 (Database)
     - **Memcached**: Port 11211 (Cache)
     - **RabbitMQ**: Port 5672 (Message Queue)
   - These services are configured to communicate only with the application server through the application security group.

4. **Internal Traffic** within Security Groups:
   - Configured **All Traffic** between instances within the same security group to allow free communication between the services (such as database, cache, and RabbitMQ).

## EC2 Instances

1. **Instances Created**:
   - Created 5 EC2 instances for the following services:
     - **Application Server**: Running on Tomcat (Port 8080)
     - **Database Server**: Running MySQL (Port 3306)
     - **Memcached Server**: Running Memcached (Port 11211)
     - **RabbitMQ Server**: Running RabbitMQ (Port 5672)
     - **Nginx**: Configured to run on the Load Balancer (Port 80)

2. **Nginx as a Cloud Load Balancer**:
   - Used AWS Load Balancer (ALB) to route incoming traffic to the application server via **Nginx**.

## Final Setup Verification

1. **Testing Nginx and Load Balancer**:
   - Verified that the Nginx load balancer is routing traffic correctly to the application on EC2 instances.

2. **Database Connectivity**:
   - Ensured that the application server can connect to the MySQL database and retrieve data.

3. **Memcached and RabbitMQ**:
   - Verified the correct functioning of caching and message queuing through Memcached and RabbitMQ respectively.

---

## Future Improvements

- Consider automating the entire setup using **Terraform** or **CloudFormation** for faster, repeatable deployments.
- Explore using **RDS** for database management to reduce administrative overhead.

## Contact

For any questions or further information, feel free to reach out:

- **Email**: [ahmedmahmoud0131@gmail.com](mailto:ahmedmahmoud0131@gmail.com)
- **LinkedIn**: [Ahmed Mahmoud](https://www.linkedin.com/in/ahmed-mahmoud-03b938238/)
- **GitHub**: [AhmedMahmoud113](https://github.com/AhmedMahmoud113)
