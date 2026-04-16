using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class index : System.Web.UI.Page
{
    string strCon = ConfigurationManager.ConnectionStrings["myCon"].ConnectionString;

   protected void Page_Load(object sender, EventArgs e)
{
    // ✅ SEARCH SESSION SYNC (Index bhi)
    if (Request.QueryString["q"] != null)
    {
        string q = Request.QueryString["q"].Trim();
        if (!string.IsNullOrEmpty(q))
            Session["LastSearch"] = q;
        else
            Session.Remove("LastSearch");
    }
    else
    {
        // URL me q nahi => clear (jab user chip se hata de)
        Session.Remove("LastSearch");
    }

    // ✅ LOCATION SESSION SYNC (optional but recommended)
    if (Request.QueryString["type"] == "nearby" &&
        !string.IsNullOrEmpty(Request.QueryString["lat"]) &&
        !string.IsNullOrEmpty(Request.QueryString["lng"]))
    {
        Session.Remove("CityID");
        Session.Remove("CityName");

        Session["NearType"] = "nearby";
        Session["UserLat"] = Request.QueryString["lat"];
        Session["UserLng"] = Request.QueryString["lng"];
    }
    else if (!string.IsNullOrEmpty(Request.QueryString["cityid"]) &&
             !string.IsNullOrEmpty(Request.QueryString["cityname"]))
    {
        Session.Remove("NearType");
        Session.Remove("UserLat");
        Session.Remove("UserLng");

        Session["CityID"] = Request.QueryString["cityid"];
        Session["CityName"] = Request.QueryString["cityname"];
    }

    if (!IsPostBack)
    {
        BindRestaurants();
        BindCategories();
    }
}


    // 1. Categories Slider ke liye Data
    private void BindCategories()
    {
        using (SqlConnection con = new SqlConnection(strCon))
        {
            // Assuming IsActive column exists based on your schema
            string query = "SELECT * FROM tbl_Categories WHERE IsActive = 1";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    sda.Fill(dt);
                    rptCategories.DataSource = dt;
                    rptCategories.DataBind();
                }
            }
        }
    }

    // 2. Restaurants List ke liye Data (ListView)
    private void BindRestaurants()
    {
        // ✅ Session City
        string cityId = (Session["CityID"] != null) ? Session["CityID"].ToString() : "";

        // ✅ Session Nearby
        string nearType = (Session["NearType"] != null) ? Session["NearType"].ToString() : "";
        string userLat = (Session["UserLat"] != null) ? Session["UserLat"].ToString() : "";
        string userLng = (Session["UserLng"] != null) ? Session["UserLng"].ToString() : "";

        // ✅ Session Search
        string searchText = (Session["LastSearch"] != null) ? Session["LastSearch"].ToString().Trim() : "";

        if (!string.IsNullOrEmpty(userLat)) userLat = userLat.Replace(",", ".");
        if (!string.IsNullOrEmpty(userLng)) userLng = userLng.Replace(",", ".");

        bool isNearby = (nearType == "nearby" && !string.IsNullOrEmpty(userLat) && !string.IsNullOrEmpty(userLng));

        using (SqlConnection con = new SqlConnection(strCon))
        {
            string distanceSelect = "";
            string whereExtra = "";
            string groupByExtra = "";
            string orderBy = " ORDER BY AvgRating DESC, r.RestaurantID DESC ";

            // ✅ Search filter (only if searchText exists)
            string searchWhere = "";
            if (!string.IsNullOrWhiteSpace(searchText))
            {
                searchWhere = @"
                AND (
                    r.Name LIKE '%' + @Q + '%'
                    OR c.CategoryName LIKE '%' + @Q + '%'
                    OR r.SignatureDish LIKE '%' + @Q + '%'
                    OR r.OfferText LIKE '%' + @Q + '%'
                )
            ";
            }

            if (isNearby)
            {
                string haversineExpr = string.Format(
                    "6371 * ACOS(COS(RADIANS({0})) * COS(RADIANS(r.Latitude)) * COS(RADIANS(r.Longitude) - RADIANS({1})) + SIN(RADIANS({0})) * SIN(RADIANS(r.Latitude)))",
                    userLat, userLng);

                distanceSelect = ", (" + haversineExpr + ") AS Distance ";
                whereExtra = " AND r.Latitude IS NOT NULL AND r.Longitude IS NOT NULL AND (" + haversineExpr + ") < 2 ";
                groupByExtra = ", r.Latitude, r.Longitude ";
                orderBy = " ORDER BY Distance ASC, AvgRating DESC, r.RestaurantID DESC ";
            }

            string query = @"
            SELECT TOP 8
                r.RestaurantID,
                r.Name,
                r.CoverImage,
                r.MinPrice,
                r.MaxPrice,
                r.OpenTime,
                r.CloseTime,
                r.OfferText,
                c.CategoryName,
                ISNULL(a.AreaName,'City Center') AS AreaName,
                AVG(ISNULL(CAST(rw.Rating AS FLOAT),0)) AS AvgRating
                " + distanceSelect + @"
            FROM tbl_Restaurants r
            INNER JOIN tbl_Categories c ON r.CategoryID = c.CategoryID
            LEFT JOIN tbl_Areas a ON r.AreaID = a.AreaID
            LEFT JOIN tbl_Reviews rw 
                ON r.RestaurantID = rw.RestaurantID 
               AND rw.IsApproved = 1
            WHERE r.ApprovalStatus = 1
              AND (
                    @IsNearby = 1
                    OR (@CityID = '' OR r.CityID = @CityID)
                  )
              " + whereExtra + @"
              " + searchWhere + @"
            GROUP BY
                r.RestaurantID, r.Name, r.CoverImage,
                r.MinPrice, r.MaxPrice,
                r.OpenTime, r.CloseTime,
                r.OfferText,
                c.CategoryName, a.AreaName
                " + groupByExtra + @"
            " + orderBy;

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@CityID", string.IsNullOrEmpty(cityId) ? "" : cityId);
                cmd.Parameters.AddWithValue("@IsNearby", isNearby ? 1 : 0);

                if (!string.IsNullOrWhiteSpace(searchText))
                    cmd.Parameters.AddWithValue("@Q", searchText);

                using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    sda.Fill(dt);

                    lvRestaurants.DataSource = dt;
                    lvRestaurants.DataBind();
                }
            }
        }
    }




    public string GetCategoryUrl(object categoryId)
    {
        // Basic URL with Category ID (catid match hona chahiye Restaurants.aspx.cs se)
        string url = "Restaurants.aspx?catid=" + categoryId;

        // 2. FILTER FIX: Agar user ne City select ki hai, to use bhi URL me add karo
        // Pehle QueryString check karo
        if (Request.QueryString["cityid"] != null)
        {
            url += "&cityid=" + Request.QueryString["cityid"];
            if (Request.QueryString["cityname"] != null)
            {
                url += "&cityname=" + Request.QueryString["cityname"];
            }
        }
        // Agar URL me nahi hai, to Session check karo (Jo humne pehle set kiya tha)
        else if (Session["SelectedCityID"] != null)
        {
            url += "&cityid=" + Session["SelectedCityID"];
            if (Session["SelectedCityName"] != null)
            {
                url += "&cityname=" + Session["SelectedCityName"];
            }
        }

        return url;
    }

    // Helper to handle Image Paths safely
    public string GetImageUrl(object imgName, string folder)
    {
        string img = imgName.ToString();
        if (string.IsNullOrEmpty(img))
        {
            return "assets/images/placeholder.jpg"; // Default image
        }

        // Agar database me pura path save hai (old data)
        if (img.Contains("/")) return img;

        // Agar sirf filename hai (new data)
        return folder + img;
    }
    public bool IsOpenNow(object openTimeObj, object closeTimeObj)
    {
        if (openTimeObj == null || closeTimeObj == null) return false;

        TimeSpan openTime, closeTime;
        if (!TimeSpan.TryParse(openTimeObj.ToString(), out openTime)) return false;
        if (!TimeSpan.TryParse(closeTimeObj.ToString(), out closeTime)) return false;

        TimeSpan now = DateTime.Now.TimeOfDay;

        // Same-day timing
        if (openTime < closeTime)
            return now >= openTime && now <= closeTime;

        // Overnight timing (e.g. 7 PM – 2 AM)
        return now >= openTime || now <= closeTime;
    }

}