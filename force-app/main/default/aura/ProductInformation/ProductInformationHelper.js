({
	updateCase : function(component) {
        
        var notifyBankerCheck = component.find("notifyBankerCheck").get("v.checked");
		var action = component.get('c.updateCase');
        
        var caseId = component.get('v.caseRecordId');
        
        var notes = component.find("notes").get("v.value");
        
        var table = document.getElementById("myTable");
        var rows = table.getElementsByTagName("tr");
       
        var str="";
 
        for(var i = 0 ; i < rows.length; i++){
            var cells  = rows[i].getElementsByTagName("td"); 
            for(var j = 0; j < 1 ; j++){
                var value = cells[j].innerHTML;
                str = str + value + " , "; 
            }
            
        }
        
        console.log('Products --------> ' +  str);
        
        console.log('CaseI ' + caseId);
        console.log('products ' + str);
        console.log('notes ' + notes);
        
        action.setParams({
            "caseRecordId" : caseId,
            "productInterest" : str,
            "notes":notes,
            "notifyBanker":notifyBankerCheck
		});
		
        action.setCallback(this, $A.getCallback(function (response) {

			var state = response.getState();
			
            if (state === "SUCCESS") {
                var toast = this.getToast("Success", "Case closed successfully", "Success");
			
                toast.fire();
                 $A.get('e.force:refreshView').fire();
                
            } else if (state === "ERROR") {
                
				var toast = this.getToast("Error", "There was an error when updating case", "error");
			
                toast.fire();
            }
        }));

       
            $A.enqueueAction(action); 
    },
     getToast : function(title, msg, type) {
        
		 var toastEvent = $A.get("e.force:showToast");
        
            toastEvent.setParams({
                "title":title,
                "message":msg,
                "type":type,
                "duration":"15000ms"
         });
        
        return toastEvent;
    },
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    }
	
})