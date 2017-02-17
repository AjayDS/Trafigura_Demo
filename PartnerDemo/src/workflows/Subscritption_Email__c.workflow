<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Subscription_For_Email</fullName>
        <description>Subscription For Email</description>
        <protected>false</protected>
        <recipients>
            <field>Subscription_Email_id__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Thanks_for_subscription</template>
    </alerts>
    <alerts>
        <fullName>email_alert_for_subscriptions</fullName>
        <description>email alert for subscriptions</description>
        <protected>false</protected>
        <recipients>
            <recipient>insightssecurity@00d36000000zfyeeas.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Harman_Product_confirm</template>
    </alerts>
</Workflow>
