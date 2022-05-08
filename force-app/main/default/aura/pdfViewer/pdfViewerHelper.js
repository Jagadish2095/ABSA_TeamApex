({
    loadPdf: function (component, event) {
        try {
            var pdfData = component.get("v.pdfData");
            var pdfJsFrame = component.find("pdfFrame");
            if (typeof pdfData != "undefined") {
                pdfJsFrame.getElement().contentWindow.postMessage(pdfData, "*");
            }
        } catch (e) {
            alert("Error: " + e.message);
        }
    }
});