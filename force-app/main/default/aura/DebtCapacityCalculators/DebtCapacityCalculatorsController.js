({
  //INIT
  doInit: function (component, event, helper) {
    helper.newProcessDR(component, event, helper);
  },

  //Method to export window
  exportToPdf: function (component, event, helper) {
    window.print();
  }
});