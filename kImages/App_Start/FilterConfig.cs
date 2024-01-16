using System.Web.Mvc;

namespace kImages
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters) => filters.Add(new HandleErrorAttribute());
    }
}
