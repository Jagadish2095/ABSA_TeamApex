({
    doInit : function(component, event, helper) {
        
        //Change made for Client Review Process
        var recordType = component.get("v.recordTypeName");
        console.log("---------- RECORD TYPE " + recordType);
        
        if(recordType != 'Client_Review' && recordType != 'Maturity')
        {
            var caseId=component.get("v.recordId");
            var action = component.get("c.updateStatustoNew");
            
            action.setParams({"CaseId":caseId});
            
            action.setCallback(this, function(result){
                var state = result.getState();
                if (component.isValid() && state === "SUCCESS"){
                    console.log(" result.getReturnValue(): "+result.getReturnValue());
                }
            });
            $A.enqueueAction(action); 
        }
    },
    
    closeModal : function(component, event, helper) {
        component.set("v.showFilterModal",false);
    },
    
    onfocus : function(component,event,helper){
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC  
        var getInputkeyWord = '';
        
        helper.searchHelper(component,event,getInputkeyWord);
    },
    onblur : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    keyPressController : function(component, event, helper){
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        if( getInputkeyWord.length > 0 ){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    //Vikaschand Balusu added Begin
    onfocus2 : function(component,event,helper){
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRess");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        var getInputkeyWord = '';
        helper.searchHelper2(component,event,getInputkeyWord);
    },
    onblur2 : function(component,event,helper){ 
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRess");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    
    keyPressController2 : function(component, event, helper){
        var getInputkeyWord = component.get("v.SearchKeyWord2");
        if( getInputkeyWord.length > 0 ){
            var forOpen = component.find("searchRess");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper2(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchRecords2", null ); 
            var forclose = component.find("searchRess");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    
    //Vikaschand Balusu added End
    // function for clear the Record Selaction 
    clear :function(component,event,heplper){
        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );
        component.set("v.selectedRecord", {} );   
    },
    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
        
        // get the selected Account record from the COMPONETN event 	 
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        console.log(JSON.stringify(selectedAccountGetFromEvent))
        component.set("v.selectedRecord" , selectedAccountGetFromEvent); 
        component.set("v.dsblbtn",false);
        //  alert(component.get("v.selectedRecord.Id"));
        //  alert(component.get("v.SearchKeyWord"));
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show'); 
         if(component.get("v.selectedRecord.Id").substring(0,3) != '005')
        {
            console.log('branch selected');
      
        let selectedValueRecId=component.get("v.selectedRecord.Branch_Site_Name__c");
        let selectedValueRecId2= component.get("v.selectedRecord.Site__r.Branch_Site_Name__c");
        let mycity= component.get("v.selectedRecord.Site__r.Cities_PickList__c");
        console.log("value2= "+selectedValueRecId);
        let getInputkeyWord = mycity;//component.get("v.SearchKeyWord");
        //let getInputkeyWord = "Bethal";
        let searchKey=component.find("searchKey").get("v.value");
        // alert("searchKey===>"+searchKey)
        //alert('keys==>+'+getInputkeyWord)
        
        console.log(getInputkeyWord)
        // get branch details
        helper.getBranchDetails(component,event,helper,getInputkeyWord);
        component.set("v.showBranchdetails",true);
        component.set("v.showUserdetails",false);        
        }
        else
        {  
            console.log('user selected');
            let getInputkeyWord = component.get("v.selectedRecord.Id");
            helper.getBranchDetails(component,event,helper,getInputkeyWord);            
            component.set("v.showUserdetails",true);
            component.set("v.showBranchdetails",false);             
        }

        
        
    },
    
})