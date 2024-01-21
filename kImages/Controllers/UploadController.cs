using System;
using System.Linq;
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
                for (var i = 0; i < files.Count; i++)
                {
                    var file = files[i];
                    var path = Helpers.ImagesPath() ?? throw new Exception("Pas de chemin d'enregistrement des images !!!");
                    file?.SaveAs($"{path}/{file.FileName}");
                }
                response.ReasonPhrase = "uploaded successfully";
            }
            catch (Exception ex)
            {
                response.StatusCode = HttpStatusCode.InternalServerError;
                response.ReasonPhrase = ex.Message.Replace(Environment.NewLine, "") + ".";
                System.IO.File.AppendAllText("D:\\log.txt", ex.GetExceptionDetails());
            }
            return response;
        }
    }

    public static class Helpers
    {
        public static string ImagesPath() => new System.Web.UI.Page().Server.MapPath("~\\Content");
        //public static string GetAppSetting(string key) => System.Web.Configuration.WebConfigurationManager.OpenWebConfiguration("~").AppSettings.Settings[key]?.Value;

        /*public static bool IsNull(this string str)
        {
            if (str == null) return true;
            str = str.Trim();
            if (string.IsNullOrEmpty(str) || string.IsNullOrWhiteSpace(str)) return true;
            return str == "" || str.ToLower().Equals("null");
        }*/
        public static string GetExceptionDetails(this Exception exception)
        {
            var properties = exception.GetType().GetProperties();
            return $"--------------------------------------------------------------------------------{Environment.NewLine}" +
                   string.Join(Environment.NewLine, (from property in properties let value = property.GetValue(exception, null) select $"{property.Name} = {(value != null ? value.ToString() : string.Empty)}").ToArray()) +
                   $"{Environment.NewLine}###### {Environment.NewLine}________________________________________________________________________________{Environment.NewLine}{Environment.NewLine}";
        }
    }
}
