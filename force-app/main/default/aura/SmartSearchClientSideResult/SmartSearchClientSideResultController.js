({
    recordSelected : function( component, event, helper ){
		//get the object record
        var selected_record = component.get( "v.object_record" ); 
        
        console.log('Selected record ==> '+ JSON.stringify(selected_record));
        
        //get the record event
        var component_event = component.getEvent( "selectedBeneficiaryEvt" );      

        //set the parameter
        component_event.setParams( { "beneficiaryEventRecord" : selected_record } );      
        
        //fire the component event
        component_event.fire();                                                 

    },
})