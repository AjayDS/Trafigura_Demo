global with sharing class SearchController1 {

    public String productName { get; set; }
    public static Account account { get; set; }
    public SearchController1 () { } // empty constructor
    
    @RemoteAction
    global static Account getAccount(String accountName) {
        account = [SELECT Id, Name, Phone, Type 
                   FROM Account WHERE Name like '%accountName%'];
        return account;
    }
}