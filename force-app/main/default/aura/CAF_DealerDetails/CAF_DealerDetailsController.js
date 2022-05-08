({
    onInit: function( component, event, helper ) {
        // proactively search on component initialization
        var searchTerm = component.get( "v.searchTerm" );
        //helper.handleSearch( component, searchTerm );
        helper.fatchDealers(component, event, helper);
    },
    onSearchTermChange: function( component, event, helper ) {
        // search anytime the term changes
        var searchTerm = component.get( "v.searchTerm" );
        // to improve performance, particularly for fast typers,
        // we wait a small delay to check when user is done typing
        var delayMillis = 500;
        // get timeout id of pending search action
        var timeoutId = component.get( "v.searchTimeoutId" );
        // cancel pending search action and reset timer
        clearTimeout( timeoutId );
        // delay doing search until user stops typing
        // this improves client-side and server-side performance
        timeoutId = setTimeout( $A.getCallback( function() {
            helper.handleSearch( component, searchTerm );
        }), delayMillis );
        component.set( "v.searchTimeoutId", timeoutId );
    },
    /*prepoputeDealer: function( component, event, helper ) {
        //debugger;
        var selectedDealerId  = component.get("v.selectedDealer");
        helper.fatchDealer(component, selectedDealerId, helper);
    },*/
    handleAccountChange: function( component, event, helper ) {
        var selectedLookUpRecord = component.get("v.selectedLookUpRecord");
        //alert(selectedLookUpRecord);
        if(selectedLookUpRecord != undefined && selectedLookUpRecord != null){
            if(selectedLookUpRecord.Name  == undefined){
                selectedLookUpRecord.Name = '';
            }
            if(selectedLookUpRecord.Franchise_Code__c  == undefined){
                selectedLookUpRecord.Franchise_Code__c = '';
            }
            if(selectedLookUpRecord.ShippingCity  == undefined){
                selectedLookUpRecord.ShippingCity = '';
            }
            if(selectedLookUpRecord.ShippingStreet  == undefined){
                selectedLookUpRecord.ShippingStreet = '';
            }
            component.find("Dealer_Trading_name_or_code__c").set("v.value",selectedLookUpRecord.Franchise_Code__c+' - '+selectedLookUpRecord.Name+' - '+selectedLookUpRecord.ShippingStreet+' - '+selectedLookUpRecord.ShippingCity);
        }else{
            component.find("Dealer_Trading_name_or_code__c").set("v.value",'');
        }
    }
    
    
})