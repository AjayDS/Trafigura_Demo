/*public class greetingController{
    public final Account accnt;
    public greetingController(){
        accnt = (accnt.id==null)?new Account():[select id,name from Account where id =: apexPages.CurrentPage().getParameters().get('id')];
    }
    
    public String getDisplay(){
        if(accnt!=null){
            String str= 'Hello Ajay..Your Acc Name is: ' + accnt.Name + ' Id is: '+ accnt.id;
            return str;                    
        }        
        return null;
    }
}*/

public class ExampleController {

    DateTime t1;
    transient DateTime t2;

    public String getT1() {
        if (t1 == null) t1 = System.now();
        return '' + t1;
    }

    public String getT2() {
        if (t2 == null) t2 = System.now();
        return '' + t2;
    }
}