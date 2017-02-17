public with sharing class ContactsController {

    @RemoteAction
    public static Map<String, Object> retrieveContacts(String type, List<String> fields, Map<String, Object> criteria) {
        
        // Retrieve using the standard retrieve
       /* Map<String, Object> result = RemoteObjectController.retrieve(type, fields, criteria);
        system.debug('type:--->'+type);
        system.debug('fields:--->'+fields);
        system.debug('criteria:--->'+criteria);
        system.debug('result:--->'+result);*/
        
        // Add in the total record count for the current user. 
        // This is needed to know when to stop scrolling.
        Integer totalContacts = [SELECT Count() FROM Product2];
        
        // Create a new map since the result map is read-only
        Map<String, Object> customResult = 
            new Map<String, Object> {'totalContacts'=> totalContacts};
        //customResult.putAll(result);
        
        return customResult;
    }
}