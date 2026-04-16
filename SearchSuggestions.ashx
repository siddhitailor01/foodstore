<%@ WebHandler Language="C#" Class="SearchSuggestions" %>

using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.Script.Serialization;

public class SearchSuggestions : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";

        string q = (context.Request["q"] ?? "").Trim();
        string cityid = (context.Request["cityid"] ?? "").Trim();

        if (string.IsNullOrWhiteSpace(q))
        {
            context.Response.Write("[]");
            return;
        }

        var list = new List<object>();
        string conStr = ConfigurationManager.ConnectionStrings["myCon"].ConnectionString;

        using (SqlConnection con = new SqlConnection(conStr))
        {
            con.Open();

            // ✅ Only Approved restaurants (ApprovalStatus = 1)
            // ✅ Suggestions from:
            // 1) Restaurant Name
            // 2) SignatureDish (Dish)

            string sql = @"
SELECT TOP 10 Name, Type
FROM
(
    SELECT DISTINCT r.Name AS Name, 'Cafe/Restaurant' AS Type
    FROM tbl_Restaurants r
    WHERE r.ApprovalStatus = 1
      AND r.Name LIKE @q + '%'
      AND (@cityid = '' OR CAST(r.CityID AS NVARCHAR(20)) = @cityid)

    UNION

    SELECT DISTINCT r.SignatureDish AS Name, 'Dish' AS Type
    FROM tbl_Restaurants r
    WHERE r.ApprovalStatus = 1
      AND r.SignatureDish IS NOT NULL
      AND LTRIM(RTRIM(r.SignatureDish)) <> ''
      AND r.SignatureDish LIKE @q + '%'
      AND (@cityid = '' OR CAST(r.CityID AS NVARCHAR(20)) = @cityid)
) x
ORDER BY Name ASC;
";

            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.AddWithValue("@q", q);
                cmd.Parameters.AddWithValue("@cityid", cityid);

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        list.Add(new
                        {
                            text = dr["Name"].ToString(),
                            type = dr["Type"].ToString()
                        });
                    }
                }
            }
        }

        var js = new JavaScriptSerializer();
        context.Response.Write(js.Serialize(list));
    }

    public bool IsReusable { get { return false; } }
}
