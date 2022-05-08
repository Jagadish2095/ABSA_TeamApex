({
    /*@ Author: Danie Booysen
 	**@ Date: 03/04/2020
 	**@ Description: Method that gets the Branch Name value from the parent cmp to set the value*/
    setSelectedBranchName : function(component, event, helper) {
        console.log("setSelectedBranchName");
        var params = event.getParam('arguments');
        component.set("v.selectedRecord" , params.selectedBranchName);
        
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
       
        var getbank= component.get("v.dselectedBankName");
        /* var jsonstrbank=JSON.stringify(getbank);   Bank name is only passing
        var jsonparbank=JSON.parse(jsonstrbank);
        var bankname= jsonparbank.Name; */
        
        var getInputkeyWord = '';
    
        helper.searchHelper(component,event,getInputkeyWord,getbank);
    },
    
    onblur : function(component,event,helper){       
        // component.set("v.listOfBranchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open'); 
    },
    
    keyPressController : function(component, event, helper) {
        
        //get Bank name
        var getbank= component.get("v.dselectedBankName");
       /* var jsonstrbank=JSON.stringify(getbank);   Bank name is only passing
        var jsonparbank=JSON.parse(jsonstrbank);
        var bankname= jsonparbank.Name; */
        
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWord");
        
        
        if( getInputkeyWord.length > 0 ){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord,getbank);
        }
        else{  
            component.set("v.listOfBranchRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
            
        } 
        
        if( getbank ==''){
            
            component.set("v.Message", 'Please select the bank name First ...'); 
        }
        
    },
    
    clearBranchName :function(component,event,helper){ 
        
        var recordToBeclear = event.getParam("clearBranchName");
        //component.set("v.dselectedBankName", recordToBeclear);
        // clear attribute dselectedBankName which contain bankName
        component.set("v.dselectedBankName",null);
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
        var selectedBranchNameGetFromEvent = event.getParam("recordByEvent");
        var selectedBranchCodeGetFromEvent = event.getParam("recordBranchCodeEvent");
        
        component.set("v.selectedRecord" , selectedBranchNameGetFromEvent); 
        component.set("v.branchCodeSelected" , selectedBranchCodeGetFromEvent); 
        
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