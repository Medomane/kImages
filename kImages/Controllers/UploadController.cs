using System;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace kImages.Controllers
{
    public class UploadController : ApiController
    {
        // POST api/<controller>
        public HttpResponseMessage Post()
        {
            var response = Request.CreateResponse(HttpStatusCode.OK);
            try
            {
                var httpRequest = HttpContext.Current.Request;
                if (httpRequest.Files.Count <= 0) throw new Exception("Pas de fichier .");
                var files = httpRequest.Files;
                foreach (HttpPostedFile file in files)
                {
                    var path = Helpers.ImagesPath() ?? throw new Exception("Pas de chemin d'enregistrement des images !!!");
                    file?.SaveAs($"{path}/{DateTime.Now:ddMMyyyyHHmmss}_{file.FileName}");
                }
                response.ReasonPhrase = "uploaded successfully";
            }
            catch (Exception ex)
            {
                response.StatusCode = HttpStatusCode.InternalServerError;
                response.ReasonPhrase = ex.Message.Replace(Environment.NewLine, "") + ".";
            }
            return response;
        }
    }

    public static class Helpers
    {
        public static string ImagesPath()
        {
            var path = GetAppSetting("ABSOLUTE_PATH");
            return path.IsNull() ? null : path.TrimEnd('\\').TrimEnd('\\').TrimEnd('/').TrimEnd('/');
        }
        public static string GetAppSetting(string key) => System.Web.Configuration.WebConfigurationManager.OpenWebConfiguration("~").AppSettings.Settings[key]?.Value;

        public static bool IsNull(this string str)
        {
            if (str == null) return true;
            str = str.Trim();
            if (string.IsNullOrEmpty(str) || string.IsNullOrWhiteSpace(str)) return true;
            return str == "" || str.ToLower().Equals("null");
        }
    }
}
