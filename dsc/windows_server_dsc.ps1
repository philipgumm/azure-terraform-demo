# Define the DSC Configuration
Configuration TestConfiguration {
    
    # Import the required DSC resources
    
    Find-Module PSDesiredStateConfiguration | Install-Module -Force
    
    Import-DSCResource -ModuleName PSDesiredStateConfiguration

    # Node to configure (can use 'localhost' for testing locally)
    Node localhost {
        # Ensure a folder exists
        File ExampleFolder {
            Ensure = "Present"               # Ensure the folder exists
            Type = "Directory"               # Specify that it's a directory
            DestinationPath = "C:\ExampleFolder"
        }

        # Ensure a Windows feature is installed
        WindowsFeature IIS {
            Ensure = "Present"                # Ensure the feature is installed
            Name = "Web-Server"               # Name of the IIS feature
        }
    }
}

# Generate the MOF file
TestConfiguration
