({
    // code in the helper is reusable by both
    // the controller.js and helper.js files
    handleSearch: function( component, searchTerm ) {
        var action = component.get( "c.searchDealers" );
        action.setParams({
            "keywords": searchTerm
        });
        action.setCallback( this, function( response ) {
            var event = $A.get( "e.c:searchDealerEvent" );
            event.setParams({
                "accounts": response.getReturnValue()
            });
            event.fire();
        });
        $A.enqueueAction( action );
    },
    fatchDealers: function( component, event, helper ) {
        var action = component.get( "c.getDealers" );
        action.setCallback( this, function( response ) {
            //debugger;
            var accounts = response.getReturnValue();
            component.set("v.accounts",accounts);
       
        });
        $A.enqueueAction( action );
    },/*  */
   /* fatchDealer: function( component, selectedDealerId, helper ) {
        //alert(selectedDealerId);
        component.set("v.showSpinner",true);
        var action = component.get( "c.getDealer" );
        action.setParams({
            "selectedDealerId": selectedDealerId
        });
        action.setCallback( this, function( response ) {
            //debugger;
            var account = response.getReturnValue();
			//alert(account.Id);
            //component.set("v.Sales_person_full_name__c",account.PersonAssistantName);
            component.set("v.Contact_number__c",account.Phone);
            component.set("v.Dealer_Code__c",account.Franchise_Code__c);
            component.set("v.Dealer_Trading_name_or_code__c",account.Name +" - "+ account.Franchise_Code__c);
            
       
        });
        $A.enqueueAction( action );
        component.set("v.showSpinner",false);
    }*/
  
    
})