# run_as_system_powershell_gui
A modern PowerShell GUI tool to create, manage, and run SYSTEM-level scheduled tasks — a clean alternative to PsExec. Created by Nazim Hassani.


Run As System Manager

Author: Nazim Hassani

A modern and intuitive PowerShell GUI tool that lets you easily create, run, and manage SYSTEM-account scheduled tasks — acting as a compliant and secure replacement for PsExec, which is no longer allowed in many organizations.

Run As System Manager provides a polished WPF interface that allows administrators to test scripts exactly as they will run under the SYSTEM context (e.g., Intune deployments, device provisioning, automation).

🚀 Features
✔️ Create SYSTEM tasks

Define any PowerShell script

Automatically configures the task to run as NT AUTHORITY\SYSTEM

Highest privileges enabled

No trigger added — tasks run manually on demand

✔️ Run tasks instantly

Execute a SYSTEM-context script with one click

Useful for testing Intune installation behavior, environment variables, and SYSTEM-level permissions

✔️ Delete tasks easily

Cleanly remove tasks created by the tool

Confirmation dialogs for safety

✔️ Automatic task tracking

Tasks created through the app are automatically tagged with:
Author = RunAsSystem

The tool shows only its own tasks, keeping your Task Scheduler clean

✔️ Modern WPF interface

Styled buttons

Clean layout

Professional GUI feel

Fully standalone PowerShell script

📂 How It Works

The tool uses:

WPF XAML for modern UI

Scheduled Tasks for SYSTEM execution

Automatic XML manipulation to inject a custom Author field

PsExec-like behavior without external executables

No dependencies beyond PowerShell and Windows.

🛠 Requirements

Windows 10/11

PowerShell 5.1 or higher

Administrative privileges

Execution Policy allowing script execution (Bypass is used internally)

▶️ Usage
Open a powershell console as Administrator

Launch the script:

git clone https://github.com/zimzimax/run_as_system_powershell_gui.git

cd run_as_system_powershell_gui

.\RunAsSystemGUI.ps1

Go to Create Task

Enter a task name

Browse for your .ps1 file

Click Create Task

Switch to Manage Tasks

Select a task → Run or Delete it

That’s it — you’re running PowerShell as SYSTEM with a GUI.

<img width="667" height="445" alt="image" src="https://github.com/user-attachments/assets/02a7375c-d4fb-49d5-93e4-1b77059d3418" />

<img width="667" height="445" alt="image" src="https://github.com/user-attachments/assets/262037b8-9cf4-4904-9aad-447a4d854732" />



