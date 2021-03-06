<#
 # This example is allowing storage of credentials in plain text by setting PSDscAllowPlainTextPassword to $true.
 # Storing passwords in plain text is not a good practice and is presented only for simplicity and demonstration purposes.
 # To learn how to securely store credentials through the use of certificates, 
 # please refer to the following TechNet topic: https://technet.microsoft.com/en-us/library/dn781430.aspx
 #>
configuration SSL
{
    param (
        [Parameter(Mandatory=$true)] 
        [ValidateNotNullorEmpty()] 
        [PsCredential] $Credential 
        )
    Import-DscResource -ModuleName xCertificate
    Node 'localhost'
    {
        xCertReq SSLCert
        {
            CARootName                = 'test-dc01-ca'
            CAServerFQDN              = 'dc01.test.pha'
            Subject                   = 'foodomain.test.net'
            AutoRenew                 = $true
            Credential                = $Credential
        }
    }
}
$configData = @{
    AllNodes = @(
        @{
            NodeName                    = 'localhost';
            PSDscAllowPlainTextPassword = $true
            }
        )
    }
SSL -ConfigurationData $configData -Credential (get-credential) -OutputPath 'c:\SSLConfig'
Start-DscConfiguration -Wait -Force -Verbose -Path 'c:\SSLConfig'

# Validate results
Get-ChildItem Cert:\LocalMachine\My