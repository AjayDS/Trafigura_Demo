trigger updateImageURL on Attachment (after insert,after update) {

    List<Product2> prdList = new List<Product2>();
    List<Account_Setting__c> asList = new List<Account_Setting__c>();
    public Map<string,Hard_Coded_Labels__c> mapLabels = new Map<string,Hard_Coded_Labels__c>();
    mapLabels = Hard_Coded_Labels__c.getAll();
    for(Attachment objAttch : Trigger.New){
      
     if('DisplayImage'.equals(objAttch.Name) && String.valueOf(objAttch.ParentId).Contains('01t')){
        Product2 ob = new Product2();
        ob.Id = objAttch.ParentId;
        ob.Image_URL__c = 'https://c.na30.content.force.com/servlet/servlet.FileDownload?file='+objAttch.id;
        prdList.add(ob);
     }else if('DisplayImage'.equals(objAttch.Name) && String.valueOf(objAttch.ParentId).Contains('a0H')){
        Account_Setting__c asObj = new Account_Setting__c();
        asObj.Id = objAttch.ParentId;
        asObj.Image_URL__c =mapLabels.get('Domain_URL').Value__c+'/servlet/servlet.FileDownload?file='+objAttch.id;
        asList.add(asObj);
     }
     
    }
    update prdList;
    update asList;

}