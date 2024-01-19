using System.Linq;
using System.Web.Mvc;

namespace kImages.Controllers
{
    public class HomeController : Controller
    {
        public string Index() => "kImages";
        public ActionResult Images()
        {
            var files = new System.IO.DirectoryInfo(Helpers.ImagesPath()).GetFiles();
            var destPath = new System.Web.UI.Page().Server.MapPath("~\\Content");
            foreach (var f in files) f.CopyTo($"{destPath}/{f.Name}", true);
            return View("Images", files.Select(f => f.Name).Where(name => name.ToLower().EndsWith("png") || name.ToLower().EndsWith("jpeg") || name.ToLower().EndsWith("jpg")).ToArray());
        }
    }
}
