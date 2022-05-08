({	    
    countDownAction : function(component, event, helper,closeDate) {
        var interval = window.setInterval(	 
            $A.getCallback(function() {	    
                var slaCloseDate  = new Date( closeDate);	   
                var now_date = new Date();	
                 // subtracted 30 miutes from the actual internal SLA close time
              var timeDiff = (slaCloseDate.getTime() -  (30 * 60 * 1000) ) - now_date.getTime(); 
                 //  var timeDiff = ( 30 * 60 * 1000 ) - now_date.getTime();  
                component.set("v.isValid",true);	  
                var seconds=Math.floor(timeDiff/1000); // seconds	                
                var minutes=Math.floor(seconds/60); //minute	                
                var hours=Math.floor(minutes/60); //hours	                
                var days=Math.floor(hours/24); //days	                
                hours %=24; 	                
                minutes %=60;	                
                seconds %=60;	                
                component.set("v.day",days);	                
                component.set("v.hour",hours);	                
                component.set("v.minute",minutes);	                
                component.set("v.second",seconds);	
                  if(minutes == '0' && seconds == '0')
                {
                    alert('Your time to resolve the case has been reached');
                    location.reload();
                }
            }), 1000);     	   
    }	
})