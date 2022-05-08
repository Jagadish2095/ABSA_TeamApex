({
	
    //Initiation of component
    initComp: function(component, event, helper) {
         helper.getAgentName(component,event, helper);
        component.set("v.displayLeads","showMe");
         component.set('v.columns',[         
             {label: 'Customer First Name', fieldName: 'customerFirstName', type: 'text' ,wrapText: 'true', hideDefaultActions: 'true'}
            ,{label: 'Customer Last Name', fieldName: 'customerLastName', type: 'text' ,wrapText: 'true', hideDefaultActions: 'true'}
            ,{label: 'Date Lead Sent', fieldName: 'dataLeadSent', type: 'text' ,wrapText: 'true', hideDefaultActions: 'true'}
            ,{label: 'Call Back Date', fieldName: 'callBackDate', type: 'text' ,wrapText: 'true', hideDefaultActions: 'true'}
            ,{label: 'Call Back Time', fieldName: 'callBackTime', type: 'text' ,wrapText: 'true', hideDefaultActions: 'true'}
            ,{label: 'Lead Status', fieldName: 'leadStatus', type: 'text' ,wrapText: 'true', hideDefaultActions: 'true'}            
        ]);
       component.set("v.displayLeads","showMe");
        helper.leadTrackerList(component,event, helper);
    },
    
     toggleSection : function(component, event, helper) {
        // dynamically get aura:id name from 'data-auraId' attribute
        var sectionAuraId = event.target.getAttribute("data-auraId");
        // get section Div element using aura:id
        var sectionDiv = component.find(sectionAuraId).getElement();
        /* The search() method searches for 'slds-is-open' class, and returns the position of the match.
         * This method returns -1 if no match is found.
        */
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open'); 
        
        // -1 if 'slds-is-open' class is missing...then set 'slds-is-open' class else set slds-is-close class to element
        if(sectionState == -1){
            sectionDiv.setAttribute('class' , 'slds-section slds-is-open');
        }else{
            sectionDiv.setAttribute('class' , 'slds-section slds-is-close');
        }
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
                    helper.navHome(component, event, helper);                    
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
})