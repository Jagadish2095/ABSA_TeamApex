public  class FPCustomerDatadisplayController {
    public String PDFData {get; set;}
    public FPCustomerDatadisplayController() {
        PDFData = '';
    }
    public PageReference downloadPDF(){
        System.PageReference pageRef = new System.PageReference('/apex/FPCustomerSmsPDF');

        //ensure pdf downloads and is assigned with defined name
        pageRef.getHeaders().put('content-disposition', 'attachment; filename=CustomerCommentsPDF.pdf');

        return pageRef;
    }
}