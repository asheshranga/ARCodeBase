// wrapper class for the article category group
public with sharing class KBCategoryGroupDetails {
    public List<KBCategoryDetails> Categories { get; set; }
    
    public string Name { get; set; }
    public string Label { get; set; }
    
    public KBCategoryGroupDetails(string nm, string lb) {
        Name = nm;
        Label = lb;
        Categories = new List<KBCategoryDetails>();
    }
}