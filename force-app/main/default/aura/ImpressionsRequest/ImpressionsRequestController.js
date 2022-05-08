({
    refreshPage : function(component, event, helper) {
        var wfid = component.get('v.recordId');
        console.log(wfid);
        var action = component.get('c.track2');
        action.setParams({'wfid': wfid});
        action.setCallback(this, function(response) {
            if(response.getReturnValue()!=null){
            var ls = JSON.parse(response.getReturnValue());
            component.set('v.fileName',ls.filename);
            component.set('v.fileId',ls.filename);
            console.log(ls.items);
            component.set('v.listOfSteps',ls.items);
            }
        });
        $A.enqueueAction(action);
    },
	init : function(component, event, helper) {
		var wfid = component.get('v.recordId');
        var action = component.get('c.track');
        action.setParams({'wfid': wfid});
        action.setCallback(this, function(response) {
            var ls = JSON.parse(response.getReturnValue());
            console.log('ls retuened ' + ls);
            component.set('v.fileName',ls.filename);
            component.set('v.fileId',ls.filename);
            console.log(ls.items);
            component.set('v.listOfSteps',ls.items);
        });
        $A.enqueueAction(action);
        
        component.set('v.myColumns', [
            { label: 'Event', fieldName: 'EventStatus', type: 'text'},
            { label: 'Updated', fieldName: 'LastUpdated',type: 'text'},
        ]);
	},
    isRefreshed : function(component, event, helper) {
    	console.log('refreshed');        
    },
    sendR : function(component, event, helper) {
        var requestId = event.currentTarget.dataset.value;
        console.log("Request id = " + requestId);
        var action = component.get('c.sendReminder');
        action.setParams({'requestId': requestId});
        action.setCallback(this, function(resp) {
        	alert('Reminder has been sent');
        });
        $A.enqueueAction(action);
   	},
    viewDoc : function(component, event, helper) {
    	/** downloads document as signed by this signatory */
        var requestId = event.currentTarget.dataset.value;
        var docName = component.get("v.fileName");
        console.log("Request id = " + requestId);
        var action = component.get('c.downloadDocument');
        action.setParams({'requestId': requestId});
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                var element = document.createElement('a');
                element.setAttribute('href', 'data:application/octet-stream;content-disposition:attachment;base64,' + data);
                element.setAttribute('download', docName);
                element.style.display = 'none';
                document.body.appendChild(element);		
                element.click();		
                document.body.removeChild(element);
            }
        }));
        $A.enqueueAction(action);        
	},
	signN : function(component, event, helper) {
        helper.signN(component, event, helper);
   	},
})