# Create required folder
New-Item -ItemType Directory -Path "C:\temp" -Force

# Ensure Microsoft.Graph module is installed
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
    Install-Module -Name Microsoft.Graph -Force -Scope AllUsers
}

# Import only the base Microsoft.Graph module (not submodules)
Import-Module Microsoft.Graph -NoClobber

# Connect to Microsoft Graph with required scopes
Connect-MgGraph -Scopes "Group.Read.All", "User.Read.All"

# Define group IDs
$groupIds = @(
    "4ccdc4f7-5136-4d15-b6e4-374f6784a6a7",  # TIES-Users
    "dffcd8e3-21c4-4d5d-8f36-37d437373039"   # TIES-Admins
)

# Collect all unique user principal names
$allMembers = @()
foreach ($groupId in $groupIds) {
    try {
        $members = Microsoft.Graph.Groups\Get-MgGroupMember -GroupId $groupId -All
        foreach ($member in $members) {
            # Filter only user objects
            if ($member.AdditionalProperties["@odata.type"] -eq "#microsoft.graph.user") {
                try {
                    $user = Microsoft.Graph.Users\Get-MgUser -UserId $member.Id
                    if ($user.UserPrincipalName -and ($allMembers -notcontains $user.UserPrincipalName)) {
                        $allMembers += $user.UserPrincipalName
                    }
                } catch {
                    Write-Warning "Failed to retrieve user info for member ID: $($member.Id)"
                }
            }
        }
    } catch {
        Write-Warning "Failed to retrieve members for group ID: $groupId"
    }
}

# Join UPNs into a semicolon-separated string
$allowedUsers = $allMembers -join ";"

# Create INF content
$infContent = @"
[Unicode]
Unicode=yes
[System Access]
[Event Audit]
[Registry Values]
[Version]
signature="\$CHICAGO\$"
Revision=1
[Profile Description]
Description="Restrict Logon Policy"
[Privilege Rights]
SeInteractiveLogonRight = *$allowedUsers
"@

# Write INF file
$infPath = "C:\temp\logon.inf"
$infContent | Out-File -FilePath $infPath -Encoding Unicode

# Apply the policy
secedit /configure /db C:\Windows\security\database\secedit.sdb /cfg $infPath /areas USER_RIGHTS

# Log the update
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$logPath = "C:\temp\logon_policy.log"
Add-Content -Path $logPath -Value "$timestamp - Updated logon policy for users: $allowedUsers"
 