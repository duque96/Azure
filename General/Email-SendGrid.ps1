# Email-SendGrid.ps1
# Sends an email using secure credentials stored in then Azure Automation Account, to the Azure SendGrid service.
# Used for sending alerts/reports generated by Azure Automation Runbooks

# By Jack Rudlin
# 05/06/2019

[CmdletBinding()]
Param(
    [parameter(Mandatory=$True)]
    [ValidateNotNullOrEmpty()]
    $EmailBody,
    [parameter(Mandatory=$True)]
    [ValidateNotNullOrEmpty()]
    $EmailAddress,
    [parameter(Mandatory=$True)]
    [ValidateNotNullOrEmpty()]
    $EmailSubject
)

# Global variables
$SendGridAdminAccount = "SendGridAlertsProd"

# Get secure admin creds from the AA creds vault
try{
    Write-output -inputobject "Getting account creds for: [$SendGridAdminAccount]"
    $Creds = Get-AutomationPSCredential -Name $SendGridAdminAccount
} Catch {
    write-error -Message "Could not get creds for account: [$SendGridAdminAccount] $_"
    return
}

$SMTPServer = "smtp.sendgrid.net"
$EmailFrom = "AzureAlerts@jrudlin.org.uk"
$EmailTo = $EmailAddress
$Subject = $EmailSubject
$Body = $EmailBody

Try{
Send-MailMessage -smtpServer $SMTPServer `
    -Credential $Creds `
    -Usessl `
    -Port 587 `
    -from $EmailFrom `
    -to $EmailTo `
    -subject $Subject `
    -BodyAsHtml `
    -Body $Body
    #-Attachments $file

    Write-output -inputobject "Email sent to SendGrid mail server: [$SMTPServer] for processing."

} Catch {
    Write-Error -Message "Error sending email to SendGrid. $_"
}
