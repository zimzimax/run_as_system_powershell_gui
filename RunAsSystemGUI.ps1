#Run As System Manager is a modern PowerShell-based GUI utility that allows administrators to create, manage, run, and delete scheduled tasks that execute under the SYSTEM account.
#Designed as a secure and compliant alternative to PsExec, this tool provides a fully graphical interface to run scripts exactly as they would execute during Intune deployments or SYSTEM-context automation.
#This project was created by Nazim Hassani to replace deprecated tooling while maintaining ease of use, reliability, and enterprise compatibility.



# Import necessary assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName PresentationFramework

$xaml = @"
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Run As System Manager" Height="600" Width="900"
        WindowStartupLocation="CenterScreen"
        Background="#F3F3F3"
        ResizeMode="CanMinimize">
    <Window.Resources>
        <!-- Modern Button Style -->
        <Style x:Key="ModernButton" TargetType="Button">
            <Setter Property="Background" Value="#0078D4"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Padding" Value="16,8"/>
            <Setter Property="FontSize" Value="14"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" 
                                CornerRadius="4"
                                Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#005A9E"/>
                </Trigger>
                <Trigger Property="IsPressed" Value="True">
                    <Setter Property="Background" Value="#004578"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <!-- Secondary Button Style -->
        <Style x:Key="SecondaryButton" TargetType="Button">
            <Setter Property="Background" Value="White"/>
            <Setter Property="Foreground" Value="#0078D4"/>
            <Setter Property="BorderBrush" Value="#0078D4"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Padding" Value="16,8"/>
            <Setter Property="FontSize" Value="14"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" 
                                BorderBrush="{TemplateBinding BorderBrush}"
                                BorderThickness="{TemplateBinding BorderThickness}"
                                CornerRadius="4"
                                Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#F0F0F0"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <!-- Delete Button Style -->
        <Style x:Key="DeleteButton" TargetType="Button">
            <Setter Property="Background" Value="#D13438"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Padding" Value="16,8"/>
            <Setter Property="FontSize" Value="14"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" 
                                CornerRadius="4"
                                Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#A52A2D"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <!-- Modern TextBox Style -->
        <Style x:Key="ModernTextBox" TargetType="TextBox">
            <Setter Property="Padding" Value="10,8"/>
            <Setter Property="FontSize" Value="14"/>
            <Setter Property="BorderBrush" Value="#8A8A8A"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Background" Value="White"/>
            <Setter Property="VerticalContentAlignment" Value="Center"/>
            <Style.Triggers>
                <Trigger Property="IsFocused" Value="True">
                    <Setter Property="BorderBrush" Value="#0078D4"/>
                    <Setter Property="BorderThickness" Value="2"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <!-- Modern ListBox Style -->
        <Style x:Key="ModernListBox" TargetType="ListBox">
            <Setter Property="BorderBrush" Value="#D1D1D1"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Background" Value="White"/>
            <Setter Property="FontSize" Value="14"/>
            <Setter Property="Padding" Value="5"/>
        </Style>

        <!-- Modern TabControl Style -->
        <Style TargetType="TabControl">
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="BorderThickness" Value="0"/>
        </Style>

        <Style TargetType="TabItem">
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="TabItem">
                        <Border Name="Border" 
                                Background="Transparent" 
                                BorderThickness="0,0,0,3"
                                BorderBrush="Transparent"
                                Padding="20,12">
                            <ContentPresenter x:Name="ContentSite"
                                            ContentSource="Header"
                                            VerticalAlignment="Center"
                                            HorizontalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsSelected" Value="True">
                                <Setter TargetName="Border" Property="BorderBrush" Value="#0078D4"/>
                                <Setter TargetName="ContentSite" Property="TextElement.Foreground" Value="#0078D4"/>
                                <Setter TargetName="ContentSite" Property="TextElement.FontWeight" Value="SemiBold"/>
                            </Trigger>
                            <Trigger Property="IsSelected" Value="False">
                                <Setter TargetName="ContentSite" Property="TextElement.Foreground" Value="#605E5C"/>
                            </Trigger>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="Border" Property="Background" Value="#F3F3F3"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>

    <Grid>
        <!-- Header Section -->
        <Border Background="White" Height="70" VerticalAlignment="Top" 
                BorderThickness="0,0,0,1" BorderBrush="#E1E1E1">
            <Border.Effect>
                <DropShadowEffect BlurRadius="5" ShadowDepth="2" Opacity="0.1" Color="Black"/>
            </Border.Effect>
            <StackPanel VerticalAlignment="Center" Margin="30,0">
                <TextBlock Text="Run As System Manager" 
                          FontSize="24" 
                          FontWeight="SemiBold" 
                          Foreground="#323130"/>
                <TextBlock Text="Create and manage scheduled tasks that run with SYSTEM privileges" 
                          FontSize="12" 
                          Foreground="#605E5C" 
                          Margin="0,4,0,0"/>
            </StackPanel>
        </Border>

        <!-- Main Content Area -->
        <TabControl Name="TabControl" Margin="0,70,0,0" Background="#F3F3F3">
            <TabItem Name="CreateTaskTab" Header="CREATE TASK" FontSize="13">
                <Grid Background="White" Margin="1">
                    <Border Background="White" CornerRadius="8" Margin="40,30,40,40">
                        <Border.Effect>
                            <DropShadowEffect BlurRadius="10" ShadowDepth="2" Opacity="0.08" Color="Black"/>
                        </Border.Effect>
                        
                        <StackPanel Margin="40">
                            <!-- Task Name Section -->
                            <TextBlock Text="Task Name" 
                                      FontSize="14" 
                                      FontWeight="SemiBold" 
                                      Foreground="#323130" 
                                      Margin="0,0,0,8"/>
                            <TextBox Name="TaskNameText" 
                                    Style="{StaticResource ModernTextBox}"
                                    Height="40"
                                    Margin="0,0,0,25"/>

                            <!-- Script Path Section -->
                            <TextBlock Text="Script Path" 
                                      FontSize="14" 
                                      FontWeight="SemiBold" 
                                      Foreground="#323130" 
                                      Margin="0,0,0,8"/>
                            <Grid Margin="0,0,0,30">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="10"/>
                                    <ColumnDefinition Width="Auto"/>
                                </Grid.ColumnDefinitions>
                                
                                <TextBox Name="ScriptPath" 
                                        Grid.Column="0"
                                        Style="{StaticResource ModernTextBox}"
                                        Height="40"/>
                                
                                <Button Name="BrowseScript" 
                                       Grid.Column="2"
                                       Content="Browse..." 
                                       Style="{StaticResource SecondaryButton}"
                                       Height="40"
                                       Width="120"/>
                            </Grid>

                            <!-- Create Button -->
                            <Button Name="CreateTask" 
                                   Content="Create Task" 
                                   Style="{StaticResource ModernButton}"
                                   Height="44"
                                   Width="160"
                                   HorizontalAlignment="Center"
                                   Margin="0,10,0,0"/>
                        </StackPanel>
                    </Border>
                </Grid>
            </TabItem>

            <TabItem Name="ManageTaskTab" Header="MANAGE TASKS" FontSize="13">
                <Grid Background="White" Margin="1">
                    <Border Background="White" CornerRadius="8" Margin="40,30,40,30">
                        <Border.Effect>
                            <DropShadowEffect BlurRadius="10" ShadowDepth="2" Opacity="0.08" Color="Black"/>
                        </Border.Effect>
                        
                        <Grid Margin="40">
                            <Grid.RowDefinitions>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="Auto"/>
                            </Grid.RowDefinitions>

                            <!-- Task List Label -->
                            <TextBlock Grid.Row="0"
                                      Text="Available Tasks" 
                                      FontSize="14" 
                                      FontWeight="SemiBold" 
                                      Foreground="#323130" 
                                      Margin="0,0,0,12"/>

                            <!-- Task List -->
                            <ListBox Name="TaskList" 
                                    Grid.Row="1"
                                    Style="{StaticResource ModernListBox}"
                                    Margin="0,0,0,20"
                                    MinHeight="180"/>

                            <!-- Action Buttons -->
                            <StackPanel Grid.Row="2" 
                                       Orientation="Horizontal" 
                                       HorizontalAlignment="Center"
                                       Margin="0,10,0,0">
                                <Button Name="RunTask" 
                                       Content="Run Task" 
                                       Style="{StaticResource ModernButton}"
                                       Height="44"
                                       Width="140"
                                       Margin="0,0,15,0"/>
                                <Button Name="DeleteTask" 
                                       Content="Delete Task" 
                                       Style="{StaticResource DeleteButton}"
                                       Height="44"
                                       Width="140"/>
                            </StackPanel>
                        </Grid>
                    </Border>
                </Grid>
            </TabItem>
        </TabControl>
    </Grid>
</Window>
"@

$XmlReader = [System.Xml.XmlReader]::Create([System.IO.StringReader]::new($xaml))
$Window = [Windows.Markup.XamlReader]::Load($XmlReader)

$TabControl = $Window.FindName("TabControl")
$CreateTaskTab = $Window.FindName("CreateTaskTab")
$ManageTaskTab = $Window.FindName("ManageTaskTab")
$TaskList = $Window.FindName("TaskList")
$TaskNameText = $Window.FindName("TaskNameText")
$ScriptPath = $Window.FindName("ScriptPath")
$BrowseScript = $Window.FindName("BrowseScript")
$CreateTask = $Window.FindName("CreateTask")
$RunTask = $Window.FindName("RunTask")
$DeleteTask = $Window.FindName("DeleteTask")

# Function to refresh task list
function Refresh-TaskList {
    $TaskList.Items.Clear()
    $TaskOnSystem = Get-ScheduledTask -TaskPath "\" -ErrorAction SilentlyContinue | Where-Object {$_.Author -eq "RunAsSystem"}
    
    if($TaskOnSystem){
        foreach($Task in $TaskOnSystem){
            $TaskList.Items.Add($Task.TaskName) | Out-Null
        }
    }
}

# Track current tab to prevent duplicate refreshes
$script:CurrentTab = $null

$TabControl.add_SelectionChanged({
    $newTab = $TabControl.SelectedItem
    
    # Only refresh if we're switching TO the manage tab (not if already there)
    if ($newTab -eq $ManageTaskTab -and $script:CurrentTab -ne $ManageTaskTab) {
        Refresh-TaskList
    }
    
    $script:CurrentTab = $newTab
})

$BrowseScript.add_click({
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.Filter = "PowerShell Scripts (*.ps1)|*.ps1|All Files (*.*)|*.*"
    $OpenFileDialog.Title = "Select a PowerShell script"
    $OpenFileDialog.ShowDialog() | Out-Null
    $ScriptPath.Text = $OpenFileDialog.FileName
})

$CreateTask.add_click({
    if($TaskNameText.Text -ne $null -and $TaskNameText.Text.Trim() -ne ""){
        try {
            $TaskName = $TaskNameText.Text
            $scriptPath = $ScriptPath.Text
            
            if(-not (Test-Path $scriptPath)){
                [System.Windows.MessageBox]::Show("The specified script file does not exist.", "Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
                return
            }
            
            # Define the action to run the PowerShell script
            $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Normal -File `"$scriptPath`""

            # Define the principal to run the task as SYSTEM
            $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

            # Define the settings for the task
            $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

            # Create the task without a trigger
            $task = New-ScheduledTask -Action $action -Principal $principal -Settings $settings

            # Register the task
            Register-ScheduledTask -TaskName $taskName -InputObject $task -Force | Out-Null

            # Path to the XML file for exporting the task
            $xmlFilePath = "$env:TEMP\TaskExport_$([guid]::NewGuid().ToString()).xml"
            $newAuthor = "RunAsSystem"

            # Export the existing task to XML
            schtasks /Query /TN $taskName /XML > $xmlFilePath

            # Load and modify the XML file to add the Author tag
            (Get-Content $xmlFilePath).Replace("<RegistrationInfo>", "<RegistrationInfo>`n<Author>$newAuthor</Author>") | Out-File $xmlFilePath -Encoding Unicode

            # Unregister the existing task
            Unregister-ScheduledTask -TaskName $taskName -Confirm:$false

            # Re-register the task with updated XML
            Register-ScheduledTask -Xml (Get-Content $xmlFilePath | Out-String) -TaskName $taskName -Force | Out-Null
            Remove-Item $xmlFilePath -Force
            
            [System.Windows.MessageBox]::Show("Task '$taskName' has been created successfully.", "Success", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
        }
        catch {
            [System.Windows.MessageBox]::Show("An error occurred while creating the task:`n$($_.Exception.Message)", "Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
        }
    }
    else{
        [System.Windows.MessageBox]::Show("Task Name field cannot be empty.", "Validation Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
    }
})

$RunTask.add_click({
    if($TaskList.SelectedItem -ne $null){
        $selectedTask = $TaskList.SelectedItem.ToString()
        try {
            Start-ScheduledTask -TaskName $selectedTask -ErrorAction Stop
            [System.Windows.MessageBox]::Show("Task '$selectedTask' has been started.", "Success", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
        }
        catch {
            [System.Windows.MessageBox]::Show("An error occurred while running the task:`n`n$($_.Exception.Message)", "Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
        }
    }
    else{
        [System.Windows.MessageBox]::Show("Please select a task to run.", "No Selection", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
    }
})

$DeleteTask.add_click({
    if($TaskList.SelectedItem -ne $null){
        $selectedTask = $TaskList.SelectedItem.ToString()
        $result = [System.Windows.MessageBox]::Show("Are you sure you want to delete the task '$selectedTask'?", "Confirm Deletion", [System.Windows.MessageBoxButton]::YesNo, [System.Windows.MessageBoxImage]::Question)
        
        if($result -eq [System.Windows.MessageBoxResult]::Yes){
            try {
                Unregister-ScheduledTask -TaskName $selectedTask -Confirm:$false -ErrorAction Stop
                [System.Windows.MessageBox]::Show("Task '$selectedTask' has been deleted successfully.", "Success", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
                Refresh-TaskList
            }
            catch {
                [System.Windows.MessageBox]::Show("An error occurred while deleting the task:`n`n$($_.Exception.Message)", "Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
            }
        }
    }
    else{
        [System.Windows.MessageBox]::Show("Please select a task to delete.", "No Selection", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
    }
})

$Window.ShowDialog()