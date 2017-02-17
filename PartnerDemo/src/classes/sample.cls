public class sample
{    
    public String text1 {get;set;}
      
    public sample()
    {
         
    }    
    public void parseJson()
    {
        String soql = 'SELECT Name FROM Account LIMIT 5';
        List<Account> acct = Database.Query(soql); 
        text1 = JSON.serialize(acct);
    }    
}