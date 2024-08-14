1) Open PowerShell as Administrator:
Right-click on the Start menu and select Windows PowerShell (Admin) or Windows Terminal (Admin).

2) Set Execution Policy:
By default, PowerShell may restrict script execution. To allow the script to run, you might need to change the execution policy. Run the following command:
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

If prompted, type Y and press Enter to confirm.

3) Navigate to the Script Location:
Use the cd command to navigate to the directory where you saved the script. For example:
cd C:\path\to\your\script

4) Run the Script:
Execute the script by typing:
.\install_tools.ps1

The script will then run and install Google Cloud SDK, Terraform, and Firebase CLI without any prompts.


1) Make the Script Executable:
Open a terminal.
Navigate to the directory where you saved the script using the cd command. For example:
cd /path/to/your/script

Make the script executable by running:
chmod +x install_tools.sh

2) Run the Script:
Execute the script by typing:
./install_tools.sh
