({
	  check_validation: function(component,event,helper){
          
          let checked = component.get("v.client.i_accept_terms_and_conditions");
          if(checked){
               component.set("v.client.i_accept_terms_and_conditions_validation", "");              
          }
          
          if(component.get("v.client.products") != "00"){
              //component.set("v.client.products_validation","Please select pesornal loan");
          }else{
              component.set("v.client.products_validation","");
          }
      },
})