## Requirements

The following requirements are needed by this module:

- terraform (>= 0.13)
- azurerm (~> 2.19)
- shell (~>1.7)

As this module uses the Az PowerShell commands it requires you set the azurerm provider config using environment variables so it can authenticate.

Additional PowerShell Requirements:

- PowerShell Core (~>7.0)
- PS Module: Az (~>4.5)
- PS Module: Az.Accounts (~>1.9)
- PS Module: Az.Subscription (~>0.7)

```powershell
Install-Module @("Az", "Az.Accounts", "Az.Subscription")
```

## Providers

The following providers are used by this module:

- azurerm (~> 2.19)
- shell (~>1.7)

## Required Inputs

The following input variables are required:

### name

Description: Subscription name

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### type

Description: Prod or DevTest

Type: `string`

Default: `"Prod"`

## Outputs

No output.

