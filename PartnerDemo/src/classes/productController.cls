public class productController {

    @AuraEnabled
    public static List<SObject> serverEcho(String ObjectName,string Fields,Integer totalRecord) {
		List<sObject> sobjList = Database.query('Select Id,Name from '+ObjectName+' limit '+totalRecord+'');
		return sobjList;
	}
}