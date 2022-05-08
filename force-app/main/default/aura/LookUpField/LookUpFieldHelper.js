({
/*--
*LookUpField Lightning Component Client Side Helper
*
* @author  Simangaliso Mathenjwa : Absa
* @version v1.0
* @since   04 June 2020
*
*/
    
    searchForMatches : function( component, event, keyword, queryString){
        var childObjType = component.get("v.childObjectType");
        console.log('Object Type ==>' + JSON.stringify(childObjType));
        console.log('LeadSource ==>' + component.get("v.leadSourceAtt"));
        
        //if there is any aditional conditions to the query
        var queryCondition = component.get("v.lookupSearchCondition");
        var queryLimit = ' Limit '+ component.get("v.lookupSearchLimit");
        
        var fullQueryString = queryString + queryCondition + queryLimit;
        console.log('***fullQueryString***', fullQueryString);
        
        var fetch_action = component.get( "c.fetchMatchingLookupRecord" );
        fetch_action.setParams({
            "search_keywordP" : keyword,
            "query_string" 	  : fullQueryString
        });

        //callback function
        fetch_action.setCallback( this, function( response ){
			//get repsonse state
            var state = response.getState();                

            //check if successful
            if( state === "SUCCESS" ){
                //get the response
				var store_response = response.getReturnValue();   
                console.log('State ==>' + state);
                
                //check if we have a length of zero
                if( store_response.length == 0 ){
                    //no message to show
                    component.set( "v.message", "No Results Found..." );        
                    component.set( "v.listOfRecords", null );   
                } 
                else{
                     //no message
                    component.set( "v.message", "" );                 
					
                    //Set Search Results attribute(listOfRecords)
                	component.set( "v.listOfRecords", store_response );
                }

            }//end if-block
             //remove spinner    
            component.set("v.showLoadingSpinner", false);

        });//end of callback function
		$A.enqueueAction( fetch_action );           

    }//end of function definition
})