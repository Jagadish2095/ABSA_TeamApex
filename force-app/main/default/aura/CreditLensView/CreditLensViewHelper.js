({
  helpContext: function (component, selectedContext, envBaseURL, entityID, helper) {
    component.set("v.isLoading", true);
    var contextURL = "";
    switch (selectedContext) {
      case "start":
        contextURL = envBaseURL + "/";
        break;
      case "creditmemo":
        contextURL = envBaseURL + "/?ctx=Entity:" + entityID + "&nav=CreditPresentation.EntityCreditMemoList";
        break;
      case "pmanagement":
        contextURL = envBaseURL + "/?ctx=Entity:" + entityID + "&nav=FacilityProductManagement.ProductSummary";
        break;
      case "dstructuring":
        contextURL = envBaseURL + "/?ctx=Entity:" + entityID + "&nav=DealStructuringAdvanced.AssetSearch";
        break;
      case "danalyses":
        contextURL = envBaseURL + "/?ctx=Entity:" + entityID + "&nav=DealAnalytics.CmmGroups";
        break;
      case "rgrading":
        contextURL = envBaseURL + "/?ctx=Entity:"+entityID+"&nav=RiskGrading.RiskGradingLanding";
        break;
      case "fanalyses":
        contextURL = envBaseURL + "/?ctx=Entity:" + entityID + "&nav=FinancialAnalysis.FinancialAnalysis";
        break;
      case "pcenter":
        contextURL = envBaseURL + "/?ctx=Entity:" + entityID + "&nav=ProposalCenter.ProposalCenter";
        break;
      case "sautomation":
        contextURL = envBaseURL + "/?ctx=Entity:" + entityID + "&nav=SpreadingAutomation.SpreadingAutomation";
        break;
      case "candc":
        contextURL = envBaseURL + "/?ctx=Entity:" + entityID + "&nav=CovenantsAndConditions.CovenantSummary";
        break;
      default:
        contextURL = envBaseURL + "/";
    }
    component.set("v.isLoading", false);
    component.set("v.currentContextURL", contextURL);
    helper.throwVisualToast(component);
    //Pause for UX
    setTimeout(function () {
      window.open(contextURL);
    }, 1500);
    
  },

  throwVisualToast: function (component) {
    component.find("notifLib").showToast({
      title: "Opening...",
      message: "CreditLens opening in new browser tab!",
      variant: "info"
    });
  }
});