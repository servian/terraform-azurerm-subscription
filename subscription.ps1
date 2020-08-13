#
# CRUD an Azure Subscription
# 
# Requires the following environment variables:
# - $env:name
# - $env:type - string, either "MS-AZR-0148P" (dev/test) or "MS-AZR-0017P" (normal/prod)
#

$credential = New-Object System.Management.Automation.PSCredential ($env:azsub_client_id, (ConvertTo-SecureString $env:azsub_client_secret -AsPlainText -Force))
Connect-AzAccount -Credential $credential -Tenant $env:azsub_tenant_id -ServicePrincipal

$ErrorActionPreference = 'Stop'
$old_state = [System.IO.File]::OpenText("/dev/stdin").ReadToEnd() | ConvertFrom-Json
if ($null -ne $old_state) {
    Write-Output "Old state:"
    $old_state | ConvertTo-Json | Write-Output
}

function Create {

    # Check if subscription name already used in this tenant
    Write-Output "Checking for existing subscription with name $env:name..."
    $subscription = Get-AzSubscription -TenantId $env:azsub_tenant_id -SubscriptionName $env:name -ErrorAction SilentlyContinue
    $subscription | ConvertTo-Json | Write-Output

    # Create new subscription
    if ($null -eq $subscription) {
        $account = Get-AzEnrollmentAccount
        Write-Output "Enrolment account:"
        $account | ConvertTo-Json | Write-Output
        Write-Output "Creating subscription..."
        try {
            $subscription = New-AzSubscription -OfferType $env:type -Name $env:name -EnrollmentAccountObjectId $account[0].ObjectId -ErrorAction Stop
        }
        catch {
            Write-Error "Error: Error when attempting to update subscription name: $($_.Exception.Response)"
            exit 1
        }
        Write-Output "New subscription:"
        $subscription | ConvertTo-Json | Write-Output
    }
    else {
        Write-Error "Error: Subscription with the specified name already exists."
        exit 1
    }

    # Emit refreshed state
    @{ id = $subscription.Id; name = $subscription.Name } | ConvertTo-Json | Write-Output

    
}

function Read {
    $subscription = Get-AzSubscription -TenantId $env:azsub_tenant_id -SubscriptionId $old_state.id -ErrorAction Stop

    # Emit refreshed state
    @{ id = $subscription.Id; name = $subscription.Name } | ConvertTo-Json | Write-Output
}

function Update {
    # The only thing that will get updated is the subscription name
    Write-Output "Changing subscription name to $env:name..."
    
    # Pending a Powershell cmdlet to rename subscriptions or make authenticated
    $resource = "https://management.azure.com/"
    $url = "https://management.azure.com/subscriptions/$($old_state.id)/providers/Microsoft.Subscription/rename?api-version=2019-03-01-preview"
    $context = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile.DefaultContext
    $token = [Microsoft.Azure.Commands.Common.Authentication.AzureSession]::Instance.AuthenticationFactory.Authenticate($context.Account, $context.Environment, $context.Tenant.Id.ToString(), $null, [Microsoft.Azure.Commands.Common.Authentication.ShowDialog]::Never, $null, $resource).AccessToken
    $secure_token = ConvertTo-SecureString $token -AsPlainText -Force
    $body = $(@{ SubscriptionName = $env:name } | ConvertTo-Json)

    try { 
        Invoke-RestMethod -Method POST -Uri $url -Authentication Bearer -Token $secure_token -Body $body -ContentType 'application/json'
    }
    catch { 
        Write-Error "Error: Error when attempting to update subscription name: $($_.Exception.Response)"
        exit 1 
    }

    # Renaming takes a while to take effect, so rather than wait for it to happen we
    # return immediately with artificial state.
    
    # Get revised subscription details
    # $subscription = Get-AzSubscription -SubscriptionId $old_state.id -ErrorAction Stop
     
    # Emit refreshed state
    Write-Host "New state:"
    @{ id = $old_state.id; name = $env:name } | ConvertTo-Json | Write-Output
}

function Delete {
    Write-Output "NOTE: The subscription cannot be programmatically deleted, it is just removed from Terraform's state file"
}
