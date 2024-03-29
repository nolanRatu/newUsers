########################################################################################
# Powershell Script: Create Bulk Active Directory Users from CSV 
# Editor: Nolan Ratu
# IN719
########################################################################################

#Get AD Cmdlets
Import-Module ActiveDirectory

#Get CSV file path
$Users = Import-Csv -Delimiter "," -Path "C:\Windows\System32\bin\user.csv"

#Loop through file and get data
foreach ($User in $Users) 
{   
    #Set data variables   
    $Password = $User.Password
    $DetailedName = $User.FirstName + " " + $User.LastName
    $FirstName = $User.FirstName
    $Surname = $User.LastName
    $SAM = $User.LoginAccount
    $userPrinc = $User.LoginAccount + "@groupe.sqrawler.com"
    $Password = $User.Password
    
    #Check if user exists
    $Check = Get-ADUser -LDAPFilter "{Name=$DetailedName}"
    if($Check -eq $Null){
    
        #Create the user if it doesn't exists    
        New-ADUser -SamAccountName $SAM -Name $DetailedName -GivenName $FirstName -UserPrincipalName $userPrinc -Surname $Surname -DisplayName $DetailedName -AccountPassword(ConvertTo-SecureString $Password -AsPlainText -Force) -Enabled $True -ChangePasswordAtLogon $True -PassThru
    }
    else {
        
        #if user does exists show message
        Write-Host "User Already exist:$DetailedName"
    }      
}