/*--
* LookUpField Lightning Component Client Side Controller
*
* @author  Simangaliso Mathenjwa : Absa
* @version v1.0
* @since   04 June 2020
*
*/

({
    
    //koketso - get query related to the lookup field  
    doInit : function(component, event, helper) {
        
        //Set CaseType default selection
        var action = component.get("c.getQueryString");
        
        var lookupSearchData = component.get("v.lookupSearchData");
        console.log('****lookupSearchVal****'+lookupSearchData);
        
        action.setParams({
            "lookupSearchVal" : lookupSearchData
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
             if (component.isValid() && state === "SUCCESS") {
                
                var query = response.getReturnValue();
                component.set("v.lookupSearchQuery", query);
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    
    //This function will handle click on the Seach field
	handleMouseClick : function( component, event, helper ){
        
        //Show spinner:
        component.set("v.showLoadingSpinner", true); 
        
        var results = component.find( "search_result" );      
  
        //Toggle Div
        $A.util.addClass( results, "slds-is-open" );                            
        $A.util.removeClass( results, "slds-is-close" );                       
		
        var queryString = component.get("v.lookupSearchQuery");
        //Search on Mouse Click
        helper.searchForMatches( component, event, "", queryString);                     

    },//end of function definition



    /** this function will handle when mouse leaves component
     */  
     
    handleMouseLeave : function( component ){

        var results = component.find( "search_result" );
        
        //clear current list of records
        component.set( "v.listOfRecords", null );                
		
        //Toggle Div
        $A.util.addClass( results, 'slds-is-close' );               
        $A.util.removeClass( results, 'slds-is-open' );             

    },//end of function definition


  /** this function will handle key up event */
  
 	handleKeyUp : function( component, event, helper){
		component.set("v.showLoadingSpinner", true);
        
        var keyword_input = component.get("v.searchKeyword");           
        var results = component.find( "search_result" );             

        //check if we have input
        if( keyword_input.length > 0 ){
			
            //Toggle
			$A.util.addClass( results, "slds-is-open" );            
            $A.util.removeClass( results, "slds-is-close" );
            
            var queryString = component.get("v.lookupSearchQuery");
            //perform search
            helper.searchForMatches( component, event, keyword_input, queryString);         
		}
        else{
			//Clear
            component.set( "v.listOfRecords", null );            
			$A.util.addClass( results, "slds-is-close" );          
            $A.util.removeClass( results, "slds-is-open" );     
            component.set("v.showLoadingSpinner", false);
		}//end of if-else block
            

    },//end of function definition


    /** this function will handle component event */
    handleEvent : function( component, event, helper ){
		
        //get the record in given event
        var selected_ServGroup = event.getParam( "record_event" );           
        var current_element;                          //this will indicate what we are closing
		
        //set the selected record
        component.set( "v.selectedRecord", selected_ServGroup ); 
        
        //set the record ID
        component.set( "v.recordIdString", selected_ServGroup.Id ); 
        
        //Toggle Pill
        current_element = component.find( "lookup_pill" );                 //find pill
        $A.util.addClass( current_element, "slds-show" );                   //we show pill
        $A.util.removeClass( current_element, "slds-hide" );                //removing hide
		
        //Toggle Results List
        current_element = component.find( "search_result" );               //find the search result
        $A.util.addClass( current_element, "slds-is-close" );               //add close class
        $A.util.removeClass( current_element, "slds-is-open" );             //remove open class

        current_element = component.find( "lookup_field" );                //find the lookup field
        $A.util.addClass( current_element, "slds-hide" );                   //add hide class
        $A.util.removeClass( current_element, "slds-show" );                //remove show class

    },//end of function definition


    /** function that will clear the Record Selection
     */
    clearSelection : function( componentP, eventP, helperP ){
		
        //find lookup_pill ID
        var current_element = componentP.find( "lookup_pill" );                
        
        $A.util.addClass( current_element, "slds-hide" );          
        $A.util.removeClass( current_element, "slds-show" );        

        current_element = componentP.find( "lookup_field" );       
        $A.util.addClass( current_element, "slds-show" );               //add show class
        $A.util.removeClass( current_element, "slds-hide" );            //remove add class

        //clear component attributes
        componentP.set( "v.searchKeyword", null );                 // clear the search keyword
        componentP.set( "v.listOfRecords", null );                //clear the list of records
        componentP.set( "v.selectedRecord", {} );                //clear selected record
        componentP.set( "v.recordIdString", "" );

    },//end of function definition

})