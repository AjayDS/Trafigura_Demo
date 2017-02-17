<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>Account_ORA</fullName>
        <apiVersion>36.0</apiVersion>
        <endpointUrl>https://app2.informaticacloud.com/saas/api/1/salesforceoutboundmessage/Qj53q5mHasRm1gv9ngfk8GMs0oRp8B7K</endpointUrl>
        <fields>Id</fields>
        <fields>Name</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>vinay.singh@harman.com.partner</integrationUser>
        <name>Account ORA</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Email_Address</fullName>
        <apiVersion>37.0</apiVersion>
        <endpointUrl>http://www.gmail.com</endpointUrl>
        <fields>AccountNumber</fields>
        <fields>BillingCity</fields>
        <fields>Id</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>sudheshna.tuppada@harman.com.demo</integrationUser>
        <name>Email_Address</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Account ORA</fullName>
        <actions>
            <name>Account_ORA</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
