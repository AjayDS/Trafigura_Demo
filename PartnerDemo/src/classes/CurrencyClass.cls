public class CurrencyClass{

    public  CurrencyClass(){}
    public CurrencyClass (ApexPages.StandardController ctr){
    }

    public List<SelectOption> getCurrencyValues()
    {
      List<SelectOption> options = new List<SelectOption>();

       Schema.DescribeFieldResult fieldResult = Opportunity.CurrencyIsoCode.getDescribe();

       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

       for( Schema.PicklistEntry f : ple)
       {
          //Concatinating currency values like  ( value "USD" label "U.S. Dollar" ) 

          string finalvalue= f.getValue() + ' - ' + f.getLabel() ;

          options.add(new SelectOption(finalvalue, finalvalue));
       }       
       return options;
    }

}