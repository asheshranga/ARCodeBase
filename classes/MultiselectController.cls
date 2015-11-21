/*
 * MultiselectController synchronizes the values of the hidden elements to the SelectOption lists.
 * Controller initially copied from the below URL
 * "https://github.com/metadaddy-sfdc/Visualforce-Multiselect-Picklist/blob/master/src/classes/MultiselectController.cls"
 */
public with sharing class MultiselectController 
{
    // SelectOption lists for public consumption - called on Component init
    public SelectOption[] leftOptions { get; set; }
    public SelectOption[] rightOptions { get; set; }

	// Selected SelectOption lists for public consumption - called from the Page
    public SelectOption[] selectedOptions { 
    	get{
    		if (selectedOptions == null)
    			selectedOptions = new list<SelectOption>();
        	if (rightOptionsHidden != null)
        		setOptions(selectedOptions, rightOptionsHidden);
        	return selectedOptions;
    	}
    	set; 
    }
    
    // Parse &-separated values and labels from value and put them in option
    private void setOptions(SelectOption[] options, String value) {
        options.clear();
        String[] parts = value.split('&');
        for (Integer i=0; i<parts.size()/2; i++) 
        {
            options.add(new SelectOption(EncodingUtil.urlDecode(parts[i*2], 'UTF-8'), 
              EncodingUtil.urlDecode(parts[(i*2)+1], 'UTF-8')));
        }
    }
    
    // Backing for hidden text field containing the options from the left list
    public String leftOptionsHidden { get; set {
           leftOptionsHidden = value;
           setOptions(leftOptions, value);           
        }
    }
    
    // Backing for hidden text field containing the options from the right list
    public String rightOptionsHidden { get; set {
           rightOptionsHidden = value;
           setOptions(rightOptions, value);
system.debug('*** rightOptions:' + rightOptions); 		
        }
    }

	public PageControllerBase pageController { get; set {
		if (value != null) 
		{
			pageController = value;
			pageController.setComponentController(this);
		}
	}
  } 
}