<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Cart Deletion</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Shopping_Cart__c.Deletion_Date__c</field>
            <operation>equals</operation>
            <value>6/20/2016 12:30 PM</value>
        </criteriaItems>
        <description>Delete the cart details based on the deletion date.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
