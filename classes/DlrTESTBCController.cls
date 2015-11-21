public class DlrTESTBCController {
    /**
     * Test class for Change Plan Bread Crumb Controller
     */

    public integer clickedStep = 2;
    
    public integer getClickedStep() {
        return clickedStep;
    }
    
    
    public List<String> bcList = new List<String>();
    
    public List<String> getBCList() {
        String s = DealerUtility.getMapValue('BreadCrumbChange');
        String[] sList = s.split(',');
        
        for(integer i = 0; i < sList.size(); i++){
            bcList.add(sList[i]);
        }
        
        return bcList;
    }
    
}