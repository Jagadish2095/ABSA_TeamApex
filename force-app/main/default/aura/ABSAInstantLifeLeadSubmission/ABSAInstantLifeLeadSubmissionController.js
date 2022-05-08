({
	 init : function(component, event, helper) {
        helper.fetchAccountRecord(component, event, helper);
       },
     checkValidity :  function(component, event, helper) {
         var today = new Date();        
        var dd = today.getDate();
        var mm = today.getMonth() + 1; //January is 0!
        var yyyy = today.getFullYear();
         var userSelectedDate=component.find("callbackdate").get("v.value");
          // if date is less then 10, then append 0 before date   
        if(dd < 10){
            dd = '0' + dd;
        } 
    	// if month is less then 10, then append 0 before date    
        if(mm < 10){
            mm = '0' + mm;
        }
        var ed = today.getDate() + 4;
        if(ed < 10){
            ed = '0' + ed;
        } 
        var todayFormattedDate = yyyy+'-'+mm+'-'+dd;
        var validateFormattedDate = yyyy+'-'+mm+'-'+ed;
        if(userSelectedDate != '' && userSelectedDate < todayFormattedDate){
            component.set("v.dateValidationError" , true);
            component.set("v.dateValidationError2" , false);
        }else if(userSelectedDate != '' && userSelectedDate > validateFormattedDate){
            component.set("v.dateValidationError2" , true);
            component.set("v.dateValidationError" , false);
            var toastEvent = $A.get("e.force:showToast"); 
                        toastEvent.setParams({
                   		 "title": "Error!",
                     	 "type":"Error",
                    	 "duration" : '5000',
                    	 "mode" : 'pester',
                    	"message": "Selected Date should be within 5 days."
                		});
                		toastEvent.fire();
           				 return;
        		}else{
           		 component.set("v.dateValidationError" , false);
                    component.set("v.dateValidationError2" , false);
       			}
    },
     checktimeValidity :  function(component, event, helper) {
        var today = new Date(); 
        var dd = today.getDate();
        var mm = today.getMonth() + 1; //January is 0!
        var yyyy = today.getFullYear();
        if(dd < 10){
            dd = '0' + dd;
        } 
        if(mm < 10){
            mm = '0' + mm;
        }
         var todayFormattedDate = yyyy+'-'+mm+'-'+dd;
         var userSelectedDate=component.find("callbackdate").get("v.value");
         var userSelectedTime=component.find("callbacktime").get("v.value");
        var time = today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds();
         if(userSelectedDate == todayFormattedDate && userSelectedTime < time){
             console.log('time must be in future');
              component.set("v.timeValidationError" , true);
         }else{ component.set("v.timeValidationError" , false);}
    },       
	onSelectOption: function(component, event) {
        var alternateOptionSelected = event.getSource().get("v.text");
    },
     handleNavigate: function(component, event, helper) { 
        var navigate = component.get("v.navigateFlow");
        var actionClicked = event.getParam("action");
        var globalId = component.getGlobalId();
        switch(actionClicked)
        {               
            case 'NEXT': 
            case 'FINISH':
                {
                  
                    if(component.find("callbackdate").get("v.value") == undefined || component.find("callbackdate").get("v.value") == '' || component.find("callbacktime").get("v.value") == undefined || component.find("callbacktime").get("v.value") == ''){
                        var toastEvent = $A.get("e.force:showToast"); 
                        toastEvent.setParams({
                   		 "title": "Error!",
                     	 "type":"Error",
                    	 "duration" : '5000',
                    	 "mode" : 'pester',
                    	"message": "Please Fill in Mandatory fields Call Back Date and Time."
                		});
                		toastEvent.fire();
               			 return;
                      }else if(component.get("v.dateValidationError")== true || component.get("v.timeValidationError")== true || component.get("v.dateValidationError2")== true){
                          console.log('date must be in future');
                       }else{
                          // component.set("v.showSpinner", true);
                           component.set("v.isOpen", true); 
                       // helper.fetchLeadSubmitservice(component);
                    }
                 
                       break;
                }
            case 'BACK':
                {
                    navigate(actionClicked);
                    break;
                }
            case 'PAUSE':
                {
                    navigate(actionClicked);
                    break;
                }
        }
    },
    closeAndLeadServiceModel: function(component, event, helper) {
        component.set("v.showSpinner", true);
           helper.fetchLeadSubmitservice(component);
        component.set("v.isOpen", false);
       },  
    
})