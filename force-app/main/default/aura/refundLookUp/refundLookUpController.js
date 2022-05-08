({
    /*@ Author: Danie Booysen
 	**@ Date: 03/04/2020
 	**@ Description: Method that gets the Branch Name value from the parent cmp to set the value*/
    setSelectedName : function(component, event, helper) {
        
        var params = event.getParam('arguments');
        component.set("v.selectedRecord" , params.selectedName);
        
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show'); 
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    
    onfocus : function(component,event,helper){
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
       
        var getReasonGroup= component.get("v.dselectedReasonGroup");

        
        var getInputkeyWord = '';
    
        helper.searchHelper(component,event,getInputkeyWord,getReasonGroup);
    },
    
    onblur : function(component,event,helper){       
        // component.set("v.listOfBranchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open'); 
    },
    
    keyPressController : function(component, event, helper) {
        
        //get Bank name
        var getReasonGroup= component.get("v.dselectedReasonGroup");
       /* var jsonstrbank=JSON.stringify(getbank);   Bank name is only passing
        var jsonparbank=JSON.parse(jsonstrbank);
        var bankname= jsonparbank.Name; */
        
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWord");
        
        
        if( getInputkeyWord.length > 0 ){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord,getReasonGroup);
        }
        else{  
            component.set("v.listOfBranchRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
            
        } 
        
        if( getReasonGroup ==''){
            
            component.set("v.Message", 'Please select the reason First ...'); 
        }
        
    },
    
    clearBranchName :function(component,event,helper){ 
        
        var recordToBeclear = event.getParam("clearBranchName");
        component.set("v.dselectedReasonGroup",null);
        //call clear function of same js controller
        $A.enqueueAction(component.get('c.clear'));
        
    },
    
    // function for clear the Record Selection 
    clear :function(component,event,helper){
        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        //component.set("v.searchbyBankName",null);
        component.set("v.listOfBranchRecords", null );
        component.set("v.selectedRecord", {} );  
        component.set("v.branchCodeSelected",null);
    },
    
    // This function call when the end user select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
        
        // Get the selected dependent branch record and Branch code from the COMPONENT event 	 
        var selectedNameGetFromEvent = event.getParam("recordByEvent");
        //var selectedReasonFromEvent = event.getParam("recordReasonGroupEvent");
        
        component.set("v.selectedRecord" , selectedNameGetFromEvent); 
       // component.set("v.branchCodeSelected" , selectedReasonFromEvent); 
        
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show'); 
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        
        
    },
})