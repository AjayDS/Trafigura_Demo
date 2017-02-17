public class mySecondController {

  public Shopping_Cart__c getAccount() {
    return [SELECT Account__c,Description__c,Id,Name,OwnerId,Price__c,Product_Id__c,Quantity__c,Shipping_Details__c,SubTotal__c,User_Id__c FROM Shopping_Cart__c where id =
             :System.currentPageReference()
             .getParameters().get('id')];
  }
}