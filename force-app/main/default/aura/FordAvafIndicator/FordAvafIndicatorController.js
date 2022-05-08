/**
 * @description       : FordAvafIndicator
 * @author            : Mradul Maheshwari
 * @last modified on  : 14-10-2021
 * @last modified by  : Mradul Maheshwari
 * @Work Id           : W-014878
 **/
({
  handleUpdated: function (component, event, helper) {
    if (event.getParam("changeType") === "LOADED") {
      helper.updateAttributes(component, event, helper);
    }
  }
});