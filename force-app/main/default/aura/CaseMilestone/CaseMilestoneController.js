({	 
    doInit : function(component, event, helper) {	    
        let action = component.get("c.fetchCaseSLADate");	
        console.log('@@@@@@recordId:'+component.get("v.recordId"));
        action.setParams({	         
            "recId" : component.get("v.recordId")	  
        });	
        action.setCallback(this,function(response){	          
            let state = response.getState();	
            if(state == 'SUCCESS')
            {	      
                var records = response.getReturnValue();
                console.log('Server-> ' + JSON.stringify(records));
                var newItems=[];  
                var slaCloseDate;
                var resdata;
                var Item;
                for (var i=0; i< records.length; i++)
                {
                    var record = records[i];
                    console.log('record-> ' + JSON.stringify(record));
                    Item = {Internal_SLA_End_Date__c: record.Internal_SLA_End_Date__c};
                    var Item2 = {createdDate: record.createdDate};
                    console.log('Item-> ' + JSON.stringify(Item));
                    resdata = Item;
                    console.log('>>>created date: '+resdata['createdDate']);
                    console.log('>>>SLA Close Date: '+resdata['Internal_SLA_End_Date__c']);
                    slaCloseDate = new Date(resdata['Internal_SLA_End_Date__c']);	
                    console.log('>>>what is close date: '+ slaCloseDate);
                }
                
                
                
                component.set("v.allItems", newItems);
                console.log('output->'+ slaCloseDate); 
                var result = slaCloseDate;
                console.log('Result : ' +result);	       
                if(result ==null)
                {
                    component.set("v.isValidDate",true);	
                    component.set("v.error",'no close date found on case');	     
                }
                else{
                    
                    var months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];		
                    var monthName = months[slaCloseDate.getMonth()];	
                    var dateNumber = slaCloseDate.getDate();	
                    var yearNumber =  slaCloseDate.getFullYear();	                
                    var timeNumber =  slaCloseDate.getTime();	  
                    // console.log('Month Name: ' +monthName+' Date: '+dateNumber+' Year: '+yearNumber);	      
                    var closeDateVar = timeNumber;	               
                    var opptyCloseDate = new Date( closeDateVar+" 00:00:00 ");	           
                    var now_date = new Date();
                    console.log('Todays date: ' + now_date);	      
                    
                    var timeDiff = (slaCloseDate.getTime() - ( 30 * 60 * 1000 )) - now_date.getTime();	
                    
                    if(timeDiff<=0){	             
                        component.set("v.isValid",false);	
                        component.set("v.msg",'Case SLA Breached');	   
                    }else{	                  
                        helper.countDownAction(component, event, helper, closeDateVar);	
                    }	        
                }
            }	    
        });	 
        $A.enqueueAction(action);	
    }
})