{
    "type": "VlocityStepCreator",
    "fileName": "VlocityStepCreator_INSUpgrade",
    "plan": {
        "Name": "INS Upgrade",
        "UniqueId": "INS Upgrade"
    },
    "steps": [
        {
            "ExternalId": "INSAddPickListValues",
            "UniqueId": "INSAddPickListValues",
            "Name": "Add Picklist Values",
            "Priority": "None",
            "Tags": "",
            "IsActive": true,
            "Type": "Group",
            "StepFrequency": "Upgrade",
            "Instruction": "These upgrade steps are adding new picklist values to existing objects/fields",
            "AllowCustomInput": false,
            "CustomInputLabel": "",
            "CustomInputValue": "",
            "ArgumentList": "",
            "StepCommand": "",
            "CheckResultUrl": "",
            "PrecursorStepUniqueId": "",
            "ParentStepUniqueId": "",
            "PreCheckMethod": "",
            "PostCheckMethod": "",
            "ExecutionMethod": ""
        },
        {
            "ExternalId": "INSAddPickListValueForBillingFrequency",
            "UniqueId": "INSAddPickListValueForBillingFrequency",
            "Name": "Add Picklist Value for Billing Frequency field in Billing Account Object",
            "Priority": "None",
            "Tags": "BillingAccount",
            "IsActive": true,
            "Type": "Manual",
            "StepFrequency": "Upgrade",
            "Instruction": "<p>Navigate to the field by pressing <b>Check Result</b> to access the Object Manager in a new tab. Then add the missing picklist field values shown below.</p>",
            "AllowCustomInput": false,
            "CustomInputLabel": "",
            "CustomInputValue": "",
            "Options": {
                "jsAction": {
                    "PostCheckMethod": "VlocityDiagnosticWizard_ToolingAPI.checkPicklistFieldValues",
                    "PreCheckMethod": "VlocityDiagnosticWizard_ToolingAPI.checkPicklistFieldValues"
                },
                "ToolingAPI": {
                    "fieldValues": [
                        "Semi-Monthly"
                    ],
                    "FieldName": "vlocity_ins__BillingFrequency__c",
                    "ObjectName": "vlocity_ins__BillingAccount__c"
                }
            },
            "ArgumentList": "",
            "StepCommand": "",
            "CheckResultUrl": "",
            "PrecursorStepUniqueId": "",
            "ParentStepUniqueId": "INSAddPickListValues",
            "PreCheckMethod": "VlocityDiagnosticWizardINSMethods.toolingQueryCustomField",
            "PostCheckMethod": "VlocityDiagnosticWizardINSMethods.toolingQueryCustomField",
            "ExecutionMethod": ""
        },
        {
            "ExternalId": "INSAddPickListValueForAssetTransactionType",
            "UniqueId": "INSAddPickListValueForAssetTransactionType",
            "Name": "Add Picklist Value for Type field in Asset Transaction object",
            "Priority": "None",
            "Tags": "AssetTransaction",
            "IsActive": true,
            "Type": "Manual",
            "StepFrequency": "Upgrade",
            "Instruction": "<p>Navigate to the field by pressing <b>Check Result</b> to access the Object Manager in a new tab. Then add the missing picklist field values shown below.</p>",
            "AllowCustomInput": false,
            "CustomInputLabel": "",
            "CustomInputValue": "",
            "Options": {
                "jsAction": {
                    "PostCheckMethod": "VlocityDiagnosticWizard_ToolingAPI.checkPicklistFieldValues",
                    "PreCheckMethod": "VlocityDiagnosticWizard_ToolingAPI.checkPicklistFieldValues"
                },
                "ToolingAPI": {
                    "fieldValues": [
                        "Initiate Grace Period"
                    ],
                    "FieldName": "vlocity_ins__Type__c",
                    "ObjectName": "vlocity_ins__AssetTransaction__c"
                }
            },
            "ArgumentList": "",
            "StepCommand": "",
            "CheckResultUrl": "",
            "PrecursorStepUniqueId": "",
            "ParentStepUniqueId": "INSAddPickListValues",
            "PreCheckMethod": "VlocityDiagnosticWizardINSMethods.toolingQueryCustomField",
            "PostCheckMethod": "VlocityDiagnosticWizardINSMethods.toolingQueryCustomField",
            "ExecutionMethod": ""
        },
        {
            "ExternalId": "INSAddPickListValueForAssetBillingFrequency",
            "UniqueId": "INSAddPickListValueForAssetBillingFrequency",
            "Name": "Add Picklist Value for Billing Frequency field in Asset object",
            "Priority": "None",
            "Tags": "Asset",
            "IsActive": true,
            "Type": "Manual",
            "StepFrequency": "Upgrade",
            "Instruction": "<p>Navigate to the field by pressing <b>Check Result</b> to access the Object Manager in a new tab. Then add the missing picklist field values shown below.</p>",
            "AllowCustomInput": false,
            "CustomInputLabel": "",
            "CustomInputValue": "",
            "Options": {
                "jsAction": {
                    "PostCheckMethod": "VlocityDiagnosticWizard_ToolingAPI.checkPicklistFieldValues",
                    "PreCheckMethod": "VlocityDiagnosticWizard_ToolingAPI.checkPicklistFieldValues"
                },
                "ToolingAPI": {
                    "fieldValues": [
                        "Semi-Monthly"
                    ],
                    "FieldName": "vlocity_ins__BillingFrequency__c",
                    "ObjectName": "Asset"
                }
            },
            "ArgumentList": "",
            "StepCommand": "",
            "CheckResultUrl": "",
            "PrecursorStepUniqueId": "",
            "ParentStepUniqueId": "INSAddPickListValues",
            "PreCheckMethod": "VlocityDiagnosticWizardINSMethods.toolingQueryCustomField",
            "PostCheckMethod": "VlocityDiagnosticWizardINSMethods.toolingQueryCustomField",
            "ExecutionMethod": ""
        }
    ]
}