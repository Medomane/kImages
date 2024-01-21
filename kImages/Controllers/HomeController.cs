using System;
using System.Linq;
using System.Web.Mvc;

namespace kImages.Controllers
{
    public class HomeController : Controller
    {
        public string Index() => "kImages";
        public ActionResult Images()
        {
            var files = new System.IO.DirectoryInfo(Helpers.ImagesPath())
                .GetFiles()
                .Where(f => f.Name.ToLower().EndsWith("png") || f.Name.ToLower().EndsWith("jpeg") || f.Name.ToLower().EndsWith("jpg"))
                .GroupBy(f => new DateTime(f.LastWriteTime.Year, f.LastWriteTime.Month, f.LastWriteTime.Day))
                .ToDictionary(g => g.Key, g => g.ToList());
            return View("Images", files);
        }
    }
}
