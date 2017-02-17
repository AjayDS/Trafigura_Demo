public with sharing class productFilter {

    public productFilter() {

    }

    public String familyValue {get;set;}    
    public List<SelectOption> familyOptions {get;set;}
    public List<product2> filteredproducts {get;set;}
    
    public productFilter(ApexPages.StandardController controller) {
        familyOptions = new List<SelectOption>();
        familyOptions.add(new SelectOption('Headphones','Headphones'));
        familyOptions.add(new SelectOption('Car Audio','Car Audio'));
    }
    
    public void updateFilteredproducts() {
        filteredproducts = [SELECT Brand__c,Category__c,Family,Id,Image_URL__c,Image__c FROM Product2 WHERE Family = 'Headphones'];
    }

}