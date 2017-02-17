public with sharing class AccountSettings {
public Account_Setting__c AccSet{get;set;}
//public string Account__c{get;set;}
public AccountSettings(){
 AccSet= new Account_Setting__c();
 }
 
}