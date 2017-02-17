({
	myAction : function(component, event, helper) {
		var action = cmp.get("c.serverEcho");
        action.setParams({ ObjectName : cmp.get("v.ObjectName") });
        action.setParams({ Fields : cmp.get("v.Fields") });
        action.setParams({ totalRecord : cmp.get("v.TotalRecord") });
        
        action.setCallback(this, function(response) {
        var state = response.getState();
		$A.enqueueAction(action);
        }
	}
})