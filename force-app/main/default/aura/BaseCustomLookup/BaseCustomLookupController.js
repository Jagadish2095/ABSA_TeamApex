({
	onfocus : function(component,event,helper) {
        
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        
        //Get the default 5 records ORDER BY CreatedDate DESC  
        var getInputkeyWord = '';
        helper.searchHelper(component,event,getInputkeyWord);
        
    },
    
    onblur : function(component,event,helper) {  
        
        component.set("v.listOfSearchRecords", null );
        var forClose = component.find("searchRes");
        $A.util.addClass(forClose, 'slds-is-close');
        $A.util.removeClass(forClose, 'slds-is-open');
        
    },
    
    keyPressController : function(component, event, helper) {
        
        //Get the search input keyword   
        var getInputkeyWord = component.get("v.searchKeyWord");
        /**
         * Check if getInputKeyWord size is more than 0, then open the lookup result list and 
         * call the helper
         * else close the lookup result List part. 
         **/  
        if (getInputkeyWord.length > 0) {
            
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
            
        } else { 
            
            component.set("v.listOfSearchRecords", null ); 
            var forClose = component.find("searchRes");
            $A.util.addClass(forClose, 'slds-is-close');
            $A.util.removeClass(forClose, 'slds-is-open');
            
        }
	},
    
  	//Function to clear record selection
    clear : function(component,event,heplper) {
        
         var pillTarget = component.find("lookup-pill");
         var lookUpTarget = component.find("lookupField"); 
        
         $A.util.addClass(pillTarget, 'slds-hide');
         $A.util.removeClass(pillTarget, 'slds-show');
        
         $A.util.addClass(lookUpTarget, 'slds-show');
         $A.util.removeClass(lookUpTarget, 'slds-hide');
      
         component.set("v.searchKeyWord",null);
         component.set("v.listOfSearchRecords", null);
         component.set("v.selectedRecord", {}); 
        
    },
    
  	//Function call when the user selects any record from the results list   
    handleComponentEvent : function(component, event, helper) {
        
        //Get the selected sObject record from the component event 	 
        var selectedsObjectGetFromEvent = event.getParam("recordByEvent");
        component.set("v.selectedRecord" , selectedsObjectGetFromEvent); 
        
        var forClose = component.find("lookup-pill");
        $A.util.addClass(forClose, 'slds-show');
        $A.util.removeClass(forClose, 'slds-hide');
        
        var forClose = component.find("searchRes");
        $A.util.addClass(forClose, 'slds-is-close');
        $A.util.removeClass(forClose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');  
        
	}
    
})