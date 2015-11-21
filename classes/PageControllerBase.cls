/*	Virtual class that every controller that needs to communicate with a MultiSelect component controller will extend.
	It is declaring:
	- a field to hold a reference to the component controller instance;
	- a getter to return the instance of the page controller; 
	- a virtual method to set the comp. Controller;
	 It is useful to make these virtual so that you can simply extend this class in your page controller and, if required, 
	 cast the component controller to a specific type (assuming that your component controller extends the class below).
 */
public with sharing virtual class PageControllerBase 
{
    public SelectOption[] selectedOptions 
    {
    	get{
    		if (multiSelectComponentController != null && multiSelectComponentController.selectedOptions != null)
    			selectedOptions = multiSelectComponentController.selectedOptions;
    		return selectedOptions;
    	}
    	set;
    } 

	private MultiselectController multiSelectComponentController;
		
	//public virtual MultiselectController getComponentController() {
	public MultiselectController getComponentController() {
		return multiSelectComponentController;
	}
		
	//public virtual void setComponentController(MultiselectController compController) {
	public void setComponentController(MultiselectController compController) {
		multiSelectComponentController = compController;
	}

	public PageControllerBase getPageCont()
	{
    	return this;
	}
}