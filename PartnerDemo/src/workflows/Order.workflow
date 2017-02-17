<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Order_Confirmation</fullName>
        <description>Order Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>User_Id__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Product_Order_Confirmation</template>
    </alerts>
    <rules>
        <fullName>Order Confirmation</fullName>
        <actions>
            <name>Order_Confirmation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order.Status</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
