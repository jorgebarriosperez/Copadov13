<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Apex_Test_Result_Summary</fullName>
        <description>Email Apex Test Result Summary</description>
        <protected>false</protected>
        <recipients>
            <recipient>jbarrios@v13.prod.copa.do</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>copado__Copado_Deployer/copado__Apex_Test_Result_Summary</template>
    </alerts>
    <rules>
        <fullName>Apex Test Results Summary</fullName>
        <active>true</active>
        <formula>copado__Org__r.Name =&apos;Dev1&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_Apex_Test_Result_Summary</name>
                <type>Alert</type>
            </actions>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
