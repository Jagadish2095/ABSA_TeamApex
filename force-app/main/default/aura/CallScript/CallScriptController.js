({
    doInit : function(component, event, helper) {
        
        var action = component.get("c.getScripts");
        action.setParams({"steps" : component.get("v.muiltipleSteps"),
                          "financialProductName" : component.get("v.productName"),
                          "campaign" : component.get("v.campaignId") 
                          });
        

        action.setCallback(this, function(response)
                           {
                               var state = response.getState();
                               if(component.isValid() && state ==="SUCCESS") 
                               {
                                    var scripts = response.getReturnValue();
                                    if(scripts != null)
                                    {
                                        scripts.sort((a, b) => parseFloat(a.Step__c) - parseFloat(b.Step__c));
                                        var listLength = scripts.length;
                                        var clientFirstName = component.get("v.clientFirstName");
                                        var clientLastName = component.get("v.clientLastName");
                                        var agentFirstName = component.get("v.agentFirstName");
                                        var agentLastName = component.get("v.agentLastName");
                                        var clientSalutation= component.get("v.clientSalutation");
                                        for (var i=0 ; i< listLength ; i++)
                                        {
                                            console.log('Scripts>> ' + scripts[i].Script__c);
                                            scripts[i].Script__c = scripts[i].Script__c.replace(/#clientFirstName/g,clientFirstName);
                                            scripts[i].Script__c = scripts[i].Script__c.replace(/#clientLastName/g,clientLastName);
                                            scripts[i].Script__c = scripts[i].Script__c.replace(/#agentFirstName/g,agentFirstName);
                                            scripts[i].Script__c = scripts[i].Script__c.replace(/#agentLastName/g,agentLastName);
                                            scripts[i].Script__c = scripts[i].Script__c.replace(/#clientSalutation/g,clientSalutation);
                                        }
                                        component.set("v.displayMultiAccordian",true);
                                        component.set("v.listOfScripts", scripts);
                                    }

                               }
                           });
        $A.enqueueAction(action);

        console.log('init');
                var mergedScript;
                var action = component.get("c.getScript");
                action.setParams({"count" : component.get("v.step"),
                            "financialProductName" : component.get("v.productName"),
                            "campaign" : component.get("v.campaignId") 
                            });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                   if(component.isValid() && state ==="SUCCESS")
                   {
                    var script = response.getReturnValue();
                    if(script !=null){

                     mergedScript = script.Script__c;
                    var clientFirstName = component.get("v.clientFirstName");
                    var clientLastName = component.get("v.clientLastName");
                    var agentFirstName = component.get("v.agentFirstName");
                    var agentLastName = component.get("v.agentLastName");
                    var clientSalutation=component.get("v.clientSalutation");
                    mergedScript = mergedScript.replace(/#clientFirstName/g,clientFirstName);
                    mergedScript = mergedScript.replace(/#clientLastName/g,clientLastName);
                    mergedScript = mergedScript.replace(/#agentFirstName/g,agentFirstName);
                    mergedScript = mergedScript.replace(/#agentLastName/g,agentLastName);
                    mergedScript = mergedScript.replace(/#clientSalutation/g,clientSalutation);
                        

                    component.set('v.callScript', script);
                    component.set('v.script', mergedScript);
                    }
                    }

                });
                $A.enqueueAction(action);

    },
})