# LAB 0 — Check prerequisites & Clone the Workshop Repository

*Before diving into the technical labs, we’ll make sure that all workshop prerequisites are met and that you have your own working copy of the lab materials. This lab consists of two parts:*

✅ *Verifying that all required software, services, and environments are set up*

🧬 *Forking and cloning the GitHub repository with lab instructions and resources*

## ✅ Part 1: Check prerequisites

Review the checklist below. You should have completed these steps **before the workshop**. If something is missing, please fix it now or contact your tutor during the break.

### 💻 Laptop

- [ ] Windows 10/11 or macOS
- [ ] Admin rights to install software

### ⚙️ Installed Software

- [ ] Azure CLI ([Windows](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?view=azure-cli-latest&pivots=msi) | [macOS](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-macos?view=azure-cli-latest))
- [ ] API Playground ([Postman](https://www.postman.com/downloads) | [Insomnia](https://insomnia.rest/))
- [ ] [Visual Studio Code](https://code.visualstudio.com/)
- [ ] VS Code Extensions:

  - [ ] Bicep
  - [ ] Azure CLI Tools
    
    ![VS Code Extensions](../../assets/prerequisites-vsc.png)

### 🌐 Azure Subscription

- [ ] Access to a dedicated Azure subscription
- [ ] Owner role assigned at subscription level ([instructions](https://learn.microsoft.com/en-us/azure/role-based-access-control/role-assignments-portal-subscription-admin))
- [ ] Machine Learning quota available (at least 6 **D-** or **E-series** VM cores in **Sweden Central**)
  ![Quota](../../assets/ml-quotas.png)

  > If needed, register resource providers: `Microsoft.Quota` and `Microsoft.Compute`, and request a quota increase

### 🛡️ Power Platform

- [ ] Microsoft 365 tenant ([sign up here](https://signup.microsoft.com/get-started/signup?products=91dcd8b1-3b1b-444d-9cdb-0bc0da3eb40d&mproducts=CFQ7TTC0LH18:0002&fmproducts=CFQ7TTC0LH18:0002&culture=en-us&country=us&ali=1))
- [ ] Power Platform Developer Plan ([get started](https://www.microsoft.com/en-us/power-platform/products/power-apps))
- [ ] Dataverse-enabled environment ([guide](https://learn.microsoft.com/en-us/power-platform/admin/create-environment#create-an-environment-with-a-database))
- [ ] System Administrator role assigned ([guide](https://learn.microsoft.com/en-us/power-platform/admin/assign-security-roles))
- [ ] Access to Copilot Studio ([trial guide](https://learn.microsoft.com/en-us/microsoft-copilot-studio/sign-up-individual))

***

## 🧬 Part 2: Fork and Clone the Workshop Repository

*Now let’s fork the repository and clone it locally so you can work with lab files in your own environment.*

- Create a folder on your laptop where you'll clone the repository. For example, you can create a folder named `nordic-summit-agent` on your C: drive.
1. Open the **GitHub repo** in your browser: [https://github.com/Katerina-Chernevskaya/collabdays-oslo-2025](https://github.com/Katerina-Chernevskaya/collabdays-oslo-2025)
2. Click the **Fork** button in the top right corner and create a copy in your own GitHub account.
3. In your forked repository, click the **Code** button and copy the **Clone URL** (HTTPS).
![Clone URL](../../assets/0-clone-url.png)
4. Open **PowerShell** or any terminal of your choice.
5. Navigate to a working directory where you want to clone the labs using `cd` command. For example:
   ```
   cd c:\collabdays-oslo-agent
   ```
6. Clone your forked repo (replace with the URL you copied before):
   ```
   git clone https://github.com/<YOUR_CLONE_URL>
   ```
7. Once cloned, open the project in Visual Studio Code:
   ```
   code .
   ```

***

✅ You’re now ready to start the workshop!


