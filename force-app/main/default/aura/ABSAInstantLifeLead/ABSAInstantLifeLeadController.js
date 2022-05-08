({
    //Last modified 2021/08/13
    init: function(component, event, helper) {
        helper.fetchData(component);  
        component.set('v.CanNavigate', false);
        
    },
    getEducation: function(component,event,helper){
        component.set('v.education',(component.find('selectEducation').get('v.value')));
        var education= component.get('v.education');
        
    },
    
    getCoverAmount: function(component,event,helper){
        
        var Education= component.find("selectEducation");
        var EducationValue = Education.get("v.value") 
        var monthlyincome = component.find("Monthlyincome").get("v.value");
        if(EducationValue =='None' || EducationValue==''){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"Error",
                "duration" : '5000',
                "mode" : 'pester',
                "message": "Please fill in mandatory fields Education"
            });
            toastEvent.fire();
            component.find("selectCoverAmount").set("v.value", '0');
        } else if( monthlyincome=='' || monthlyincome=='None' ){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"Error",
                "duration" : '5000',
                "mode" : 'pester',
                "message": "Please  fill in mandatory fields Monthly Income."
            });
            toastEvent.fire();
            component.find("selectCoverAmount").set("v.value", '0');
        }
            else
            {
                component.set('v.InsuredAmount',(component.find('selectCoverAmount').get('v.value')));
                component.set("v.showSpinner", true);
                helper.fetchData_Original(component);
            }
    },
    
    
    handleNavigate: function(component, event, helper) { 
        var navigate = component.get("v.navigateFlow");
        var actionClicked = event.getParam("action");
        var globalId = component.getGlobalId();
        switch(actionClicked)
        {       
                
            case 'NEXT': 
            case 'FINISH':
                {
                    var coveramount = component.find('selectCoverAmount').get('v.value');
                    var newmessage = component.get("v.errorFree");    
                    /* if(newmessage=='yes')
                    {
                        var navigate = component.get('v.navigateFlow');
              			  navigate('NEXT');
                       
                    }else{
                    var homeEvent = $A.get("e.force:navigateToURL");
                    homeEvent.setParams({
                        "url": "/home/home.jsp"
                    });        
                    homeEvent.fire();
                    window.close();
                   
                   
                    }*/
                    var emailcheck=component.find("emailAddress").get("v.value");
                    var phonecheck=component.find("telephoneNumber").get("v.value");
                    var emailpattern = new RegExp('[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$');
                    var phonepattern=new RegExp('[0-9]{10}');
                    if(emailcheck !== undefined && emailcheck !== "" && !emailcheck.match(emailpattern)){
                        console.log('enter valid emailaddress or phone number');
                    }else if(phonecheck !== undefined && phonecheck !== "" && !phonecheck.match(phonepattern)){
                        console.log('enter valid  phone number');
                    }else{
                        var navigate = component.get('v.navigateFlow');
                        navigate('NEXT');
                    }
                    break;
                    
                }
            case 'BACK':
                {
                    navigate(actionClicked);
                    break;
                }
            case 'PAUSE':
                {
                    navigate(actionClicked);
                    break;
                }
        }
    },
    
})