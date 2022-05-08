({
    doInit : function(component, event, helper) {
        helper.GetQueryString(component);
    },

    //This function will handle click on the Search field
	handleMouseClick : function( component, event, helper ){

        //Show spinner:
        component.set("v.showLoadingSpinner", true);                          

        var queryString = component.get("v.lookupSearchQuery");
        var keywordInput = component.get("v.searchKeyword");

        //Search on Mouse Click
        if($A.util.isEmpty(keywordInput)){
            helper.searchForMatches( component, event, "", queryString);
        }

    },

    //This function handles keyup event upon typing on the search field
    handleKeyUp : function( component, event, helper){
        
        var keywordInput = component.get("v.searchKeyword");
        var queryString = component.get("v.lookupSearchQuery");                   
        
        if($A.util.isEmpty(keywordInput)){
            helper.searchForMatches( component, event, "", queryString);

        }else if( keywordInput.length > 0){

            //perform search
            helper.searchForMatches( component, event, keywordInput, queryString);         
		}

    },

    clearSearch : function( component, event, helper ){

        var queryString  = component.get("v.lookupSearchQuery");
        var keywordInput = component.get("v.searchKeyword");

        component.set( "v.searchKeyword", null );
        helper.searchForMatches( component, event, "", queryString);
    },

    /** this function will handle component event upon selection of the record*/
    handleEvent : function( component, event, helper ){
		
        //get the record in given event
        var selected_result = event.getParam( "record_event" );           
        var current_element;                          //this will indicate what we are closing
		
        //set the selected record
        component.set( "v.selectedRecord", selected_result); 
        
        //set the record ID
        component.set( "v.recordIdString", selected_result.Id );
        component.set("v.hideTable", true);

    },//end of function definition
})