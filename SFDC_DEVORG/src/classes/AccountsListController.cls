public class AccountsListController{

public List<Account> accList = new List<Account>();

    public void accountContactOpties(){
        for(Account acc:[select id,Name,(select id,Name from Account.Contacts),(Select id,Name from Account.Opportunities) from Account]){
        
            accList.add(acc);
        }
    }
    
    public List<Account> getAccList(){
        return accList; 
    }
}