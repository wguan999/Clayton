public class ParkLocator {
    //public string[] gt{get;set;}
    
    public  static string[] country(String theCountry) {
        ParkService.ParksImplPort park = new ParkService.ParksImplPort();
        // parkService.ParksImplPort park = new parkService.ParksImplPort();
        system.debug(theCountry);
        return park.byCountry(theCountry);
        
    }
}