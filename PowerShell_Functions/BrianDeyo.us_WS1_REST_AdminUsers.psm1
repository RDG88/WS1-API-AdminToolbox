

#####
### ADMIN USERS
#####

function find-ws1AdminUser {
    param (
        [Parameter(Mandatory=$false, Position=5)][string]$UserName,
        [Parameter(Mandatory=$false, Position=0)][string]$FirstName,
        [Parameter(Mandatory=$false, Position=1)][string]$LastName,
        [Parameter(Mandatory=$false, Position=2)][string]$Email,
        [Parameter(Mandatory=$false, Position=2)][string]$LocationGroup,
        [Parameter(Mandatory=$false, Position=3)][int]$LocationGroupId,
        [Parameter(Mandatory=$false, Position=2)][string]$OrganizationGroupUuid,
        [Parameter(Mandatory=$false, Position=2)][string]$TimeZone,
        [Parameter(Mandatory=$false, Position=2)][string]$TimeZoneIdentifier,
        [Parameter(Mandatory=$false, Position=2)][string]$Locale,
        [Parameter(Mandatory=$false, Position=5)][string]$InitialLandingPage,
        [Parameter(Mandatory=$false, Position=5)][string]$LastLoginTimeStamp,
        [Parameter(Mandatory=$false, Position=4)][string]$Roles,    
        [Parameter(Mandatory=$false, Position=6)][int]$page,
        [Parameter(Mandatory=$false, Position=7)][int]$pagesize,
        [Parameter(Mandatory=$false, Position=8)][string]$orderBy,
        [Parameter(Mandatory=$false, Position=9)][ValidateSet("ASC","DESC")][string]$sortOrder,
        [Parameter(Mandatory=$true, Position=10,ValueFromPipelineByPropertyName=$true)][Hashtable]$headers
        )
      
        [hashtable] $stringBuild =@{}
        if ($UserName) {$stringBuild.add("Username",$UserName)}
        if ($FirstName) {$stringBuild.add("Firstname",$FirstName)}
        if ($LastName) {$stringBuild.add("LastName",$LastName)}
        if ($Email) {$stringBuild.add("Email",$Email)}
        if ($LocationGroup) {$stringBuild.add("LocationGroup",$LocationGroup)}
        if ($LocationGroupId) {$stringBuild.add("LocationGroupId",$LocationGroupId)}
        if ($OrganizationGroupUuid) {$stringBuild.add("OrganizationGroupUuid",$OrganizationGroupUuid)}
        if ($TimeZone) {$stringBuild.add("TimeZone",$TimeZone)}
        if ($TimeZoneIdentifier) {$stringBuild.add("TimeZoneIdentifier",$TimeZoneIdentifier)}
        if ($Locale) {$stringBuild.add("Locale",$Locale)}
        if ($InitialLandingPage) {$stringBuild.add("InitialLandingPage",$InitialLandingPage)}
        if ($LastLoginTimeStamp) {$stringBuild.add("LastLoginTimeStamp",$LastLoginTimeStamp)}
        if ($Roles) {$stringBuild.add("Roles",$roles)}
        if ($page) {$stringBuild.add("page",$page)}
        if ($pagesize) {$stringBuild.add("pagesize",$pagesize)}
        if ($orderBy) {$stringBuild.add("orderBy",$orderBy)}
        if ($sortOrder) {$stringBuild.add("sortOrder",$sortOrder)}

        
        $searchUri = "https://$($headers.ws1ApiUri)/api/system/admins/search"
        $uri = New-HttpQueryString -Uri $searchUri -QueryParameter $stringBuild

        $userSearch = Invoke-WebRequest -method GET -Uri $uri -Headers $headers
        return $userSearch
}

Function New-WS1AdminUser {
    <#
        .SYNOPSIS
            Create a new BASIC or DIRECTORY Admin User
        .DESCRIPTION
            Creates a new Admin user account.
        .EXAMPLE
            New-WS1AdminUser -
        .PARAMETER headers
            Generated from the select-ws1Config cmdlet
   
        .PARAMETER IsActiveDirectoryUser
        .PARAMETER UserName
        .PARAMETER Password
        .PARAMETER FirstName
        .PARAMETER LastName
        .PARAMETER Status
        .PARAMETER Email        
        .PARAMETER IsActiveDIrectoryUser
        .PARAMETER TimeZone
        .PARAMETER LocationGroupId
        .PARAMETER Locale
        .PARAMETER InitialLandingPage
        .PARAMETER Roles
        .PARAMETER RoleID
        .PARAMETER LocationGroupId
        .PARAMETER RequiresPasswordChange

  #>
    
    param (
        
        [Parameter(Mandatory=$true, Position=0)][string]$UserName,
        [Parameter(Mandatory=$true, Position=1)][string]$Password,
        [Parameter(Mandatory=$true, Position=2)][string]$FirstName,
        [Parameter(Mandatory=$true, Position=3)][string]$LastName,
        [Parameter(Mandatory=$true, Position=4)][string]$Email,
        [Parameter(Mandatory=$true, Position=5)][bool]$IsActiveDirectoryUser, 
        [Parameter(Mandatory=$false, Position=6)][string]$TimeZone,
        [Parameter(Mandatory=$false, Position=7)][int]$LocationGroupId,
        [Parameter(Mandatory=$false, Position=8)][string]$Locale,
        [Parameter(Mandatory=$false, Position=9)][string]$InitialLandingPage,      
        [Parameter(Mandatory=$true, Position=10)][array]$Roles,
        [Parameter(Mandatory=$false, Position=11)][bool]$RequiresPasswordChange,
        [Parameter(Mandatory=$false, Position=12)][string]$MessageType,
        [Parameter(Mandatory=$false, Position=13)][int]$MessageTemplateId,
        [Parameter(Mandatory=$true, Position=14,ValueFromPipelineByPropertyName=$true)][Hashtable]$headers
    )

    
    ### Creation of JSON payload
    $body = @{}
    $body.Add("IsActiveDirectoryUser", $IsActiveDirectoryUser)
    
###LDAP users should already have this information populated 
    if ($IsActiveDirectoryUser -eq $false) {
        if ($UserName -ne $null) {$body.Add("UserName", $UserName)}
        if ($Password -ne $null) {$body.Add("Password", $Password)}
        if ($FirstName -ne $null) {$body.Add("FirstName", $FirstName)}
        if ($LastName -ne $null) {$body.Add("LastName", $LastName)}
        if ($Email -ne $null) {$body.Add("Email", $Email)}        
        if ($TimeZone -ne $null) {$body.Add("TimeZone", $TimeZone)}
        if ($LocationGroupId -ne $null) {$body.Add("LocationGroupId", $LocationGroupId)}
        if ($Locale -ne $null) {$body.Add("Locale", $Locale)}
        if ($Roles -ne $null) {$body.Add("Roles",$roles)}
        if ($MessageType -ne $null) {$body.Add("MessageType", $MessageType)}
        if ($MessageTemplateId -ne $null) {$body.Add("MessageTemplateId", $MessageTemplateId)}
    }

    $ws1AdminAdd = Invoke-Restmethod -Method POST -Uri https://$($headers.ws1ApiUri)/api/system/admins/addadminuser -Body (ConvertTo-Json $body) -Headers $Headers
    return $ws1AdminAdd
}

Function Set-ws1AdminUser {

    <#
        .SYNOPSIS
            Create a new BASIC or DIRECTORY Admin User
        .DESCRIPTION
            Creates a new Admin user account.
        .EXAMPLE
            Set-WS1AdminUser -
        .PARAMETER ws1adminId
        .PARAMETER IsActiveDirectoryUser
        .PARAMETER UserName
        .PARAMETER Password
        .PARAMETER FirstName
        .PARAMETER LastName
        .PARAMETER Status
        .PARAMETER Email        
        .PARAMETER TimeZone
        .PARAMETER LocationGroupId
        .PARAMETER Locale
        .PARAMETER InitialLandingPage
        .PARAMETER Roles
        .PARAMETER RoleID
        .PARAMETER LocationGroupId
        .PARAMETER RequiresPasswordChange

  #>
    
  param (
    
    [Parameter(Mandatory=$true, Position=0)][int]$ws1adminId,
    [Parameter(Mandatory=$false, Position=1)][string]$UserName,
    [Parameter(Mandatory=$false, Position=2)][string]$Password,
    [Parameter(Mandatory=$false, Position=3)][string]$FirstName,
    [Parameter(Mandatory=$false, Position=4)][string]$LastName,
    [Parameter(Mandatory=$false, Position=5)][string]$Email,
    [Parameter(Mandatory=$false, Position=6)][bool]$IsActiveDirectoryUser, 
    [Parameter(Mandatory=$false, Position=7)][string]$TimeZone,
    [Parameter(Mandatory=$false, Position=8)][int]$LocationGroupId,
    [Parameter(Mandatory=$false, Position=9)][string]$Locale,
    [Parameter(Mandatory=$false, Position=10)][string]$InitialLandingPage,      
    [Parameter(Mandatory=$false, Position=11)][array]$Roles,
    [Parameter(Mandatory=$false, Position=12)][bool]$RequiresPasswordChange,
    [Parameter(Mandatory=$false, Position=13)][string]$MessageType,
    [Parameter(Mandatory=$false, Position=14)][int]$MessageTemplateId,
    [Parameter(Mandatory=$true, Position=15,ValueFromPipelineByPropertyName=$true)][Hashtable]$headers
    )

    $ws1Envuri = $headers.ws1ApiUri
    ### Creation of JSON payload
    $body = @{}
    $body.Add("IsActiveDirectoryUser", $IsActiveDirectoryUser)


    if ($IsActiveDirectoryUser -eq $false) {
        if ($UserName -ne $null) {$body.Add("UserName", $UserName)}
        if ($Password -ne $null) {$body.Add("Password", $Password)}
        if ($FirstName -ne $null) {$body.Add("FirstName", $FirstName)}
        if ($LastName -ne $null) {$body.Add("LastName", $LastName)}
        if ($Email -ne $null) {$body.Add("Email", $Email)}        
        if ($LocationGroupId -ne $null) {$body.Add("LocationGroupId", $LocationGroupId)}
        if ($TimeZone -ne $null) {$body.Add("TimeZone", $TimeZone)}
        if ($Locale -ne $null) {$body.Add("Locale", $Locale)}
        if ($InitialLandingPage -ne $null) {$body.Add("InitialLandingPage", $InitialLandingPage)}
        if ($Roles -ne $null) {$body.Add("Roles",$roles)}
        if ($MessageType -ne $null) {$body.Add("MessageType", $MessageType)}
        if ($MessageTemplateId -ne $null) {$body.Add("MessageTemplateId", $MessageTemplateId)}
    }
    $ws1AdminUpdate = Invoke-RestMethod -Method POST https://$ws1Envuri/api/system/admins/$ws1adminId/update -Body (ConvertTo-Json $body) -Headers $headers

    return $ws1AdminUpdate
}

function remove-ws1AdminUser {
    <#
        .SYNOPSIS
            Delete an Admin account
        .DESCRIPTION
            Deletes and Admin account using the V2 API
            https://censusuat.awfed.com/api/help/#!/apis/10007?!/AdminsV2/AdminsV2_Delete
        .EXAMPLE
            Remove-ws1AdminUser -userUuid test1234 -headers $headers
        .PARAMETER userUuid
        .PARAMETER headers

  #>
    param (
        [Parameter(Mandatory=$true, Position=0)]
            $userUuid,
        [Parameter(Mandatory=$true, Position=1)]
            [Hashtable]$headers
    )
    
    $headers = convertTo-ws1HeaderVersion -ws1APIVersion 2 -headers $headers
    $ws1EnvUri = $headers.ws1ApiUri
    Try{
        $ws1AdminUser = invoke-webrequest -Method DELETE -Uri https://$ws1EnvUri/api/system/admins/$userUuid -Headers $headers
        
    }
    catch [Exception]{
        $ws1AdminUser = $_.exception
    }
    return $ws1AdminUser

}




function get-ws1AdminUser {
    <#
        .SYNOPSIS
            Get an Admin account
        .DESCRIPTION
            Get an Admin account using the V2 API
            https://$($headers.ws1ApiUri)/api/help/#!/apis/10007?!/AdminsV2/AdminsV2_Get
        .EXAMPLE
            get-ws1AdminUser -userUuid test1234 -headers $headers
        .PARAMETER userUuid
        .PARAMETER headers

  #>
    param (
        [Parameter(Mandatory=$true, Position=0)]
            $userUuid,
        [Parameter(Mandatory=$true, Position=1)]
            [Hashtable]$headers
    )
    
    $headers = convertTo-ws1HeaderVersion -ws1APIVersion 2 -headers $headers
    $ws1EnvUri = $headers.ws1ApiUri
    Try{
        $ws1AdminUser = invoke-webrequest -Method GET -Uri https://$ws1EnvUri/api/system/admins/$userUuid -Headers $headers
        
    }
    catch [Exception]{
        $ws1AdminUser = $_.exception
    }
    return $ws1AdminUser
}