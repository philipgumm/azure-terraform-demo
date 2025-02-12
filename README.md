# azure-terraform-demo - Visualisation can be found at: https://lucid.app/lucidchart/b1fae0fb-4805-49e8-8126-033de262c441/edit?view_items=FR0Nbe_IY_x3&invitationId=inv_8ff1e61e-1786-41c4-8e69-a2e8592f9e09

Development Environment

Task List: 
1. Export root certificate and place into Azure Key Vault
2. Use Terraform to download the public cert 
3. Use the public cert on the azure virtual gateway
4. Export the client certificate and install on Fedora and Windows 

5. Egress Terraform logs to Azure Monitor
6. Write KQL queries 

Architecture:
Six Azure Virtual Machines - 3x Windows and 3x Linux
Tiers - Web, Application and Database

Feature List:
Automated Azure Resource Deployment
CSE Script deployment to allow Configuration Management
Azure Key Vault & GitHub Action Secret
VM Subnet Deployment based on naming convention


Improvement List:
Additional Subnets
Externally available DNS resolution
NSG Port Group lock down
Configuration Management via DSC and Ansible
Modulisation of Terraform configuration
Removal of hardcoded values
GH Actions workflow to extend functionality 
Azure Monitor integration
Dashboard JSON and KQL queries 
Podman/Docker testing
Kubernetes Containerisation Orchestration
Application Deployment
CI/CD scaling based on Azure Cost Management Analysis (Possible?)
Azure Policy and Azure Blueprints review
PowerShell, Shell and Python scripts 
Managed Identities and Azure AD Integration
On-Prem AD Integration
RHCE Ansible lab - to include RHCSA components

