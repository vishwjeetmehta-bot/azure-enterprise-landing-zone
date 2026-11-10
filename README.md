<div align="center">

# 🌐 Azure Enterprise Landing Zone (CAF Hub-and-Spoke)

[![Terraform](https://img.shields.io/badge/Terraform-v1.5%2B-844FBA?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/Azure-Cloud_Adoption_Framework-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)](https://azure.microsoft.com/)
[![Security: Checkov](https://img.shields.io/badge/Security-Checkov_Passed-success?style=for-the-badge&logo=bridgecrew&logoColor=white)](https://www.checkov.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](./LICENSE)

<p align="center">
  <b>Production-grade Terraform module implementing Microsoft Cloud Adoption Framework (CAF) Hub-and-Spoke Network Architecture with Azure Firewall, Private DNS integration, and Zero-Trust egress routing.</b>
</p>

</div>

---

## 🏛️ High-Level Network Topology

```
                         ┌─────────────────────────────────────────┐
                         │           On-Premises / WAN             │
                         └────────────────────┬────────────────────┘
                                              │ ExpressRoute / VPN
                                              ▼
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ Hub Virtual Network (10.100.0.0/16)                                                    │
│                                                                                        │
│  ┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────┐  │
│  │ GatewaySubnet            │    │ AzureFirewallSubnet      │    │ AzureBastion     │  │
│  │ (10.100.2.0/27)          │    │ (10.100.0.0/26)          │    │ (10.100.1.0/26)  │  │
│  └─────────────┬────────────┘    └────────────┬─────────────┘    └──────────────────┘  │
│                │                              │ (Next Hop 0.0.0.0/0)                   │
│                └──────────────────────────────┼────────────────────────────────────────┘
│                                               │
│                           VNet Peering Mesh   │ Next-Hop Inspection
│                    ┌──────────────────────────┴─────────────────────────┐
│                    │                                                    │
│                    ▼                                                    ▼
│  ┌─────────────────────────────────────┐      ┌─────────────────────────────────────┐
│  │ Spoke 1: Corp Workloads             │      │ Spoke 2: Data Platform              │
│  │ (10.101.0.0/16)                     │      │ (10.102.0.0/16)                     │
│  │  - App Subnet  (10.101.1.0/24)      │      │  - App Subnet  (10.102.1.0/24)      │
│  │  - Data Subnet (10.101.2.0/24)      │      │  - Data Subnet (10.102.2.0/24)      │
│  │  - Route Table -> Azure Firewall    │      │  - Route Table -> Azure Firewall    │
│  └─────────────────────────────────────┘      └─────────────────────────────────────┘
```

---

## 🚀 Key Architectural Features

- **Hub-and-Spoke Isolation**: Centralizes shared services, egress filtering, and hybrid cloud gateways while keeping application workloads strictly isolated.
- **Centralized Azure Firewall**: Every spoke route table forces default outbound traffic (`0.0.0.0/0`) through Azure Firewall for Deep Packet Inspection (DPI) and Threat Intelligence.
- **Private DNS Integration**: Automatic provisioning and VNet linking for Azure PaaS endpoints (`blob.core.windows.net`, `vaultcore.azure.net`, `database.windows.net`).
- **Policy-as-Code & Drift Resilient**: Validated against CIS Microsoft Azure Foundations Benchmarks.
- **FinOps & Governance Tagging**: Standardized tagging metadata enforced across all child modules.

---

## 📁 Repository Structure

```
azure-enterprise-landing-zone/
├── .github/workflows/
│   └── terraform-ci.yml        # Format, validate, and Checkov scan pipeline
├── modules/
│   ├── azure-firewall/         # Azure Firewall Standard & Policies
│   ├── hub-network/            # Central Hub VNet, subnets & gateway configuration
│   ├── private-dns/            # Centralized Azure Private DNS Zones & links
│   └── spoke-workload/         # Reusable Spoke module with UDR route tables & peering
├── main.tf                     # Root orchestrator
├── variables.tf                # Input configurations & schema
├── outputs.tf                  # Exported resource IDs & IPs
├── terraform.tfvars.example    # Sample production configuration
├── versions.tf                 # Provider pin definitions
└── LICENSE                     # MIT License
```

---

## ⚡ Quick Start

### 1. Prerequisites
- [Terraform CLI](https://developer.hashicorp.com/terraform/downloads) (>= 1.5.0)
- Azure CLI (`az`) authenticated with Contributor privileges on target subscription

### 2. Configuration
Copy the sample variables file:
```bash
cp terraform.tfvars.example terraform.tfvars
```

### 3. Initialize & Deploy
```bash
# Initialize plugins and backend
terraform init

# Validate configuration
terraform validate

# Review execution plan
terraform plan -out=tfplan

# Apply configuration
terraform apply tfplan
```

---

## 🔒 Security & Compliance Matrix

| Control | Implementation | Standard |
| :--- | :--- | :--- |
| **Egress Inspection** | Forced tunneling to Azure Firewall via UDR | CIS Azure 5.1 |
| **No Public IPs in Spokes** | Private Endpoints & Bastion only | Zero-Trust NIST 800-207 |
| **DNS Resolution** | Centralized Private DNS linked to Hub | Well-Architected Framework |
| **IaC Scanning** | Automated Checkov & TFLint in GitHub Actions | DevSecOps Shift-Left |

---

## 👤 Author & Architecture Inquiries

**Vishwjeet Kumar Mehta**  
Senior DevOps & DevSecOps Consultant | Cloud & Infrastructure Architect  
- **LinkedIn**: [linkedin.com/in/vishwjeet-mehta](https://www.linkedin.com/in/vishwjeet-mehta/)  
- **Email**: [vishwjeetmehta@gmail.com](mailto:vishwjeetmehta@gmail.com)  
- **GitHub**: [@vishwjeetmehta-bot](https://github.com/vishwjeetmehta-bot)
