Description of the Topology
![network_diagram_complete](https://user-images.githubusercontent.com/100797437/159629946-4e238edc-cdf3-4a06-a448-8b1ee32b03d5.png)

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will be highly available, in addition to restricting access to the network.

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the log files and system metrics.

The configuration details of each machine may be found below.

Name	Function	Private IP Address	Public IP Address	Operating System
JumpBox	Gateway	10.0.0.7	104.40.58.240	Ubuntu LTS 18.04
Web-1	Application Server	10.0.0.5	N/A	Ubuntu LTS 18.04
Web-2	Application Server	10.0.0.6	N/A	Ubuntu LTS 18.04
Web-3	Application Server	10.0.0.9	N/A	Ubuntu LTS 18.04
elk-stack	ELK Stack	10.1.0.4	20.228.160.225	Ubuntu LTS 18.04
Access Policies
The machines on the internal network are not exposed to the public Internet.

Only the JumpBox and ELK Stack (Kibana) machines can accept connections from the Internet. Access to this machine is only allowed from the following IP addresses:

My Home IP Address
Machines within the network can only be accessed by JumpBox (104.40.58.240)

A summary of the access policies in place can be found in the table below.

Name	Publicly Accessible	Allowed IP Addresses
JumpBox	Yes	My Home IP Addr
elk-stack	Yes	My Home IP Addr
Web-1	No	10.0.0.5
Web-2	No	10.0.0.6
Web-3	No	10.0.0.9

Elk Configuration
Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because it allows a consistent and predictable configuration. In addition to consistency, with an automated setup, the ELK stack can be created and configured very quickly.

The playbook implements the following tasks:

Configure maximum mapped memory with sysctl module
Install docker.io and python3-pip packages with apt module
Install docker python package with pip
Enable systemd docker service
Run ELK docker container
The following screenshot displays the result of running docker ps -a after successfully configuring the ELK instance.
![image](https://user-images.githubusercontent.com/100797437/159628735-e3f0db4d-46e7-42e2-9626-c89810717472.png)

Target Machines & Beats
This ELK server is configured to monitor the following machines:

Web-1: 10.0.0.5
Web-2: 10.0.0.6
Web-3: 10.0.0.9
We have installed the following Beats on these machines:

Filebeat
Metricbeat
These Beats allow us to collect the following information from each machine:

Filebeat parses and forwards system logs from the Web VMs to the ELK Stack in an easy to read format.
Metricbeat reports system and service statistics about the Web VMs to the ELK stack VM.
Using the ELK Stack Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned:

SSH into the control node and follow the steps below:

Copy the elk-stack-playbook.yml playbook file to /etc/ansible/roles/ directory inside the ansible container.

$ sudo docker cp elk-stack-playbook.yml <container.name>:/etc/ansible/roles/elk-stack-playbook.yml
Optional: Copy the whole directory for the Metricbeat and Filebeat playbooks and configuration files.

$ sudo docker cp Ansible/*COMPASSIONATE_YALOW:/etc/ansible
Attach to the ansible docker with $ sudo docker attach <container.name>

Update the /etc/ansible/hosts file to include the ELK stack VM IP address.

Append ansible_python_interpreter=/usr/bin/python3 to ensure that the correct version of python is used.

Example configuration of /etc/ansible/hosts
[elk]
<internal.ip>      ansible_python_interpreter=/usr/bin/python3
<external.ip>      ansible_python_interpreter=/usr/bin/python3
alpha.example.org  ansible_python_interpreter=/usr/bin/python3
Run the playbook, and navigate to http://20.228.160.125:5601/app/kibana. to check that the installation worked as expected.

$ ansible-playbook /etc/ansible/install-elk.yml
![image](https://user-images.githubusercontent.com/100797437/159628983-b3b13621-d867-41bb-8ef7-19d8410fcaf3.png)

Using the Metricbeat and Filebeat Playbooks
Filebeat
Edit /etc/ansible/files/filebeat-config.yml in the ansible container on the control node to include the ELK Stack IP address. You should also change the default login credentials.
output.elasticsearch:
hosts: "20.228.160.125:9200"
username: "elastic"
password: "changeme"
setup.kibana:
host: "20.228.160.125:5601"
Then run the playbook
$ ansible-playbook /etc/ansible/filebeat-playbook.yml
Metricbeat
Edit /etc/ansible/files/metricbeat-config.yml in the ansible on the control node to include the ELK Stack IP address. You should also change the default login credentials.
output.elasticsearch:
hosts: ["20.228.160.125:9200"]
username: "elastic"
password: "changeme"
setup.kibana:
host: "20.228.160.125:5601"
Then run the playbook
$ ansible-playbook /etc/ansible/metricbeat-playbook.yml
