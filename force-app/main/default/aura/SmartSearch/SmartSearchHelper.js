({
    GetQueryString : function(component) { 

        var lookupSearchData = component.get("v.lookupSearchData");
        console.log('****lookupSearchVal****'+lookupSearchData);
        var action = component.get("c.getQueryString");

        action.setParams({
            "lookupSearchVal" : lookupSearchData
        });

        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {

            var state = response.getState();

            if (component.isValid() && state === "SUCCESS") {

                var query = response.getReturnValue();
                component.set("v.lookupSearchQuery", query);
                this.searchForMatches( component, event, "", query);
                component.set("v.unfilteredData", component.get("v.listOfRecords"));
            
            }else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Apex error SmartSearchController.getQueryString: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    },

    searchForMatches : function( component, event, keyword, queryString){
        
        var fullQueryString = queryString;  
        console.log('***fullQueryString***', fullQueryString);
        
        var action = component.get( "c.fetchMatchingLookupRecord" );
        action.setParams({
            "searchKeyword" : keyword,
            "queryString" 	: fullQueryString
        });

        //callback function
        action.setCallback( this, function( response ){
			//get repsonse state
            var state = response.getState();                

            //check if successful
            if( state === "SUCCESS" ){
                //get the response
				var storeResponse = response.getReturnValue(); 

                //check if we have a length of zero
                if( storeResponse.length == 0 ){       
                    component.set( "v.listOfRecords", null );   
                } 
                else{
                    //Set Search Results attribute(listOfRecords)
                	component.set( "v.listOfRecords", storeResponse);
                }
            }else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Apex error SmartSearchController.fetchMatchingLookupRecord: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
            }

        });//end of callback function
		$A.enqueueAction(action);           

    }
})