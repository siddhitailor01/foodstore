using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class restaurants : System.Web.UI.Page
{
    string strCon = ConfigurationManager.ConnectionStrings["myCon"].ConnectionString;
    int PageSize = 9;

    protected void Page_Load(object sender, EventArgs e)
    {
        // ✅ 1) SEARCH SESSION SYNC
        // If q exists => save, if q missing => remove (means user cleared chip)
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
            // q not in URL => user removed it by chip OR came from a link without q
            Session.Remove("LastSearch");
        }

        // ✅ 2) LOCATION SESSION SYNC (City / Nearby)
        // If nearby in URL => clear city, save nearby
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
        // If city in URL => clear nearby, save city
        else if (!string.IsNullOrEmpty(Request.QueryString["cityid"]) &&
                 !string.IsNullOrEmpty(Request.QueryString["cityname"]))
        {
            Session.Remove("NearType");
            Session.Remove("UserLat");
            Session.Remove("UserLng");

            Session["CityID"] = Request.QueryString["cityid"];
            Session["CityName"] = Request.QueryString["cityname"];
        }
        else
        {
            // ✅ If neither city nor nearby in URL => user cleared city/nearby chip
            // So clear both from session
            Session.Remove("NearType");
            Session.Remove("UserLat");
            Session.Remove("UserLng");
            Session.Remove("CityID");
            Session.Remove("CityName");
        }

        if (!IsPostBack)
        {
            if (Request.QueryString["min"] != null) txtMinPrice.Text = Request.QueryString["min"];
            if (Request.QueryString["max"] != null) txtMaxPrice.Text = Request.QueryString["max"];

            BindCategories();
            BindRestaurants();
            BindActiveFilters();
        }
    }


    protected void btnFilterPrice_Click(object sender, EventArgs e)
    {
        var query = HttpUtility.ParseQueryString(Request.Url.Query);
        if (!string.IsNullOrEmpty(txtMinPrice.Text)) query.Set("min", txtMinPrice.Text.Trim()); else query.Remove("min");
        if (!string.IsNullOrEmpty(txtMaxPrice.Text)) query.Set("max", txtMaxPrice.Text.Trim()); else query.Remove("max");
        query.Remove("page");
        Response.Redirect("restaurants.aspx?" + query.ToString());
    }

    private void BindCategories()
    {
        int cityId = 0;

        // ✅ 1) QueryString
        if (Request.QueryString["cityid"] != null)
            int.TryParse(Request.QueryString["cityid"], out cityId);

        // ✅ 2) Session fallback
        if (cityId == 0 && Session["CityID"] != null)
            int.TryParse(Session["CityID"].ToString(), out cityId);

        using (SqlConnection con = new SqlConnection(strCon))
        {
            string sql = @"SELECT c.CategoryID, c.CategoryName, COUNT(r.RestaurantID) as RestCount
                           FROM tbl_Categories c
                           LEFT JOIN tbl_Restaurants r ON c.CategoryID = r.CategoryID
                                AND r.ApprovalStatus = 1
                                AND (@CityID = 0 OR r.CityID = @CityID)
                           WHERE c.IsActive = 1
                           GROUP BY c.CategoryID, c.CategoryName
                           ORDER BY c.CategoryName";

            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.Parameters.AddWithValue("@CityID", cityId);

            SqlDataAdapter sda = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            sda.Fill(dt);

            rptCategories.DataSource = dt;
            rptCategories.DataBind();

            object total = dt.Compute("SUM(RestCount)", "");
            lblTotalCount.Text = total != DBNull.Value ? total.ToString() : "0";
        }
    }

    private string GetCleanKeywords(string rawQuery)
    {
        if (string.IsNullOrEmpty(rawQuery)) return "";
        rawQuery = rawQuery.ToLower();

        string[] stopWords = {
            "best","top","famous","good","great",
            "near","me","nearby","location",
            "in","at","on","for","the","a","an","of","and",
            "restaurant","hotel","cafe","place","shop","store","eating","dining"
        };

        string[] words = rawQuery.Split(new char[] { ' ', ',', '.', '-' }, StringSplitOptions.RemoveEmptyEntries);

        List<string> usefulWords = new List<string>();
        foreach (string w in words)
        {
            if (!stopWords.Contains(w))
                usefulWords.Add(w);
        }

        if (usefulWords.Count > 0) return string.Join(" ", usefulWords);
        return rawQuery;
    }

    private void BindRestaurants()
    {
        // ✅ Sort
        string sort = Request.QueryString["sort"];

        // ✅ Rating filter
        int minRating = 0;
        if (Request.QueryString["rating"] != null)
            int.TryParse(Request.QueryString["rating"], out minRating);

        int pageIndex = 1;
        if (Request.QueryString["page"] != null) int.TryParse(Request.QueryString["page"], out pageIndex);
        if (pageIndex < 1) pageIndex = 1;

        // ✅ Nearby: QueryString first, then Session fallback
        string type = Request.QueryString["type"];
        string userLat = Request.QueryString["lat"];
        string userLng = Request.QueryString["lng"];

        if (string.IsNullOrEmpty(type) && Session["NearType"] != null)
            type = Session["NearType"].ToString();

        if (string.IsNullOrEmpty(userLat) && Session["UserLat"] != null)
            userLat = Session["UserLat"].ToString();

        if (string.IsNullOrEmpty(userLng) && Session["UserLng"] != null)
            userLng = Session["UserLng"].ToString();

        if (!string.IsNullOrEmpty(userLat)) userLat = userLat.Replace(",", ".");
        if (!string.IsNullOrEmpty(userLng)) userLng = userLng.Replace(",", ".");

        // ✅ CityId: QueryString first, then Session fallback
        int cityId = 0;
        if (Request.QueryString["cityid"] != null) int.TryParse(Request.QueryString["cityid"], out cityId);
        if (cityId == 0 && Session["CityID"] != null) int.TryParse(Session["CityID"].ToString(), out cityId);

        int categoryId = 0;
        if (Request.QueryString["catid"] != null) int.TryParse(Request.QueryString["catid"], out categoryId);

        int minPrice = 0, maxPrice = 999999;
        if (Request.QueryString["min"] != null) int.TryParse(Request.QueryString["min"], out minPrice);
        if (Request.QueryString["max"] != null) int.TryParse(Request.QueryString["max"], out maxPrice);

        string rawSearchQuery = Request.QueryString["q"];
        string cleanSearchQuery = GetCleanKeywords(rawSearchQuery);

        using (SqlConnection con = new SqlConnection(strCon))
        {
            con.Open();

            string distanceSelect = "";
            string havingCondition = "";
            string whereCondition = " WHERE r.ApprovalStatus = 1 ";

            // ✅ Nearby logic (now supports Session too)
            bool isNearby = (type == "nearby" && !string.IsNullOrEmpty(userLat) && !string.IsNullOrEmpty(userLng));
            string haversineExpr = "";

            // ✅ Default order
            string orderBy = " ORDER BY AvgRating DESC, r.RestaurantID DESC ";

            if (isNearby)
            {
                haversineExpr = String.Format(
                    "6371 * ACOS(COS(RADIANS({0})) * COS(RADIANS(r.Latitude)) * COS(RADIANS(r.Longitude) - RADIANS({1})) + SIN(RADIANS({0})) * SIN(RADIANS(r.Latitude)))",
                    userLat, userLng);

                distanceSelect = ", (" + haversineExpr + ") AS Distance ";
                whereCondition += " AND r.Latitude IS NOT NULL AND r.Longitude IS NOT NULL ";
                whereCondition += " AND (" + haversineExpr + ") < 2 ";
                lblSearchResult.Text = "Restaurants Near You";
            }
            else
            {
                if (cityId > 0)
                {
                    whereCondition += " AND r.CityID = @CityID ";

                    // ✅ City name: querystring first, then session fallback
                    string cityName = Request.QueryString["cityname"];
                    if (string.IsNullOrEmpty(cityName) && Session["CityName"] != null)
                        cityName = Session["CityName"].ToString();

                    if (!string.IsNullOrEmpty(cityName))
                        lblSearchResult.Text = "Restaurants in " + cityName;
                }
                else
                {
                    lblSearchResult.Text = "All Restaurants";
                }
            }

            // Filters
            if (categoryId > 0) whereCondition += " AND r.CategoryID = @CatID ";
            whereCondition += " AND r.MinPrice >= @MinPrice ";
            if (Request.QueryString["max"] != null) whereCondition += " AND r.MinPrice <= @MaxPrice ";

            // Search
            if (!string.IsNullOrEmpty(cleanSearchQuery))
            {
                string[] searchWords = cleanSearchQuery.Split(' ');
                string searchFilter = " AND (";

                for (int i = 0; i < searchWords.Length; i++)
                {
                    string paramName = "@Word" + i;
                    if (i > 0) searchFilter += " OR ";

                    searchFilter += string.Format(@"
                    (r.Name LIKE '%' + {0} + '%'
                     OR c.CategoryName LIKE '%' + {0} + '%'
                     OR r.SignatureDish LIKE '%' + {0} + '%'
                     OR r.OfferText LIKE '%' + {0} + '%')", paramName);
                }

                searchFilter += " )";
                whereCondition += searchFilter;

                lblSearchResult.Text = "Search Results for '" + rawSearchQuery + "'";
            }

            // ✅ HAVING rating filter
            if (minRating > 0)
                havingCondition = " HAVING AVG(ISNULL(CAST(rw.Rating AS FLOAT),0)) >= @MinRating ";

            // ✅ Sort (final)
            if (!string.IsNullOrEmpty(sort))
            {
                switch (sort)
                {
                    case "rating":
                        orderBy = " ORDER BY AvgRating DESC, r.RestaurantID DESC ";
                        break;
                    case "price_low":
                        orderBy = " ORDER BY r.MinPrice ASC ";
                        break;
                    case "price_high":
                        orderBy = " ORDER BY r.MinPrice DESC ";
                        break;
                    case "newest":
                        orderBy = " ORDER BY r.RestaurantID DESC ";
                        break;
                    case "nearby":
                        if (isNearby)
                            orderBy = " ORDER BY Distance ASC, AvgRating DESC, r.RestaurantID DESC ";
                        break;
                }
            }

            // ✅ Heading suffix
            if (!string.IsNullOrEmpty(sort))
            {
                if (sort == "rating") lblSearchResult.Text += " • Top Rated";
                else if (sort == "price_low") lblSearchResult.Text += " • Price Low to High";
                else if (sort == "price_high") lblSearchResult.Text += " • Price High to Low";
                else if (sort == "newest") lblSearchResult.Text += " • Newest";
                else if (sort == "nearby" && isNearby) lblSearchResult.Text += " • Nearest";
            }

            string fromSql = @"
            FROM tbl_Restaurants r
            INNER JOIN tbl_Categories c ON r.CategoryID = c.CategoryID
            LEFT JOIN tbl_Areas a ON r.AreaID = a.AreaID
            LEFT JOIN tbl_Reviews rw ON r.RestaurantID = rw.RestaurantID AND rw.IsApproved = 1
        ";

            string groupBySql;
            if (isNearby)
            {
                groupBySql = @"
                GROUP BY r.RestaurantID, r.Name, r.CoverImage, r.MinPrice, r.MaxPrice, r.OfferText,
                         r.OpenTime, r.CloseTime,
                         c.CategoryName, a.AreaName, r.Latitude, r.Longitude
            ";
            }
            else
            {
                groupBySql = @"
                GROUP BY r.RestaurantID, r.Name, r.CoverImage, r.MinPrice, r.MaxPrice, r.OfferText,
                         r.OpenTime, r.CloseTime,
                         c.CategoryName, a.AreaName
            ";
            }

            // ✅ COUNT for pagination
            string countSql = @"
            SELECT COUNT(*) FROM (
                SELECT r.RestaurantID
                " + fromSql +
                    whereCondition +
                    groupBySql +
                    havingCondition +
                @") AS X";

            SqlCommand cmdCount = new SqlCommand(countSql, con);

            if (!isNearby && cityId > 0) cmdCount.Parameters.AddWithValue("@CityID", cityId);
            if (categoryId > 0) cmdCount.Parameters.AddWithValue("@CatID", categoryId);
            cmdCount.Parameters.AddWithValue("@MinPrice", minPrice);
            cmdCount.Parameters.AddWithValue("@MaxPrice", maxPrice);
            if (minRating > 0) cmdCount.Parameters.AddWithValue("@MinRating", minRating);

            if (!string.IsNullOrEmpty(cleanSearchQuery))
            {
                string[] searchWords = cleanSearchQuery.Split(' ');
                for (int i = 0; i < searchWords.Length; i++)
                    cmdCount.Parameters.AddWithValue("@Word" + i, searchWords[i]);
            }

            int totalRecords = (int)cmdCount.ExecuteScalar();

            if (totalRecords > 0)
            {
                string sql = @"
                SELECT
                    r.RestaurantID, r.Name, r.CoverImage,
                    r.MinPrice, r.MaxPrice,
                    r.OpenTime, r.CloseTime,
                    r.OfferText,
                    c.CategoryName, ISNULL(a.AreaName, '-') AS AreaName,
                    AVG(ISNULL(CAST(rw.Rating AS FLOAT),0)) AS AvgRating
                    " + distanceSelect + @"
                " + fromSql +
                    whereCondition +
                    groupBySql +
                    havingCondition +
                    orderBy +
                    " OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY";

                SqlCommand cmd = new SqlCommand(sql, con);

                if (!isNearby && cityId > 0) cmd.Parameters.AddWithValue("@CityID", cityId);
                if (categoryId > 0) cmd.Parameters.AddWithValue("@CatID", categoryId);
                cmd.Parameters.AddWithValue("@MinPrice", minPrice);
                cmd.Parameters.AddWithValue("@MaxPrice", maxPrice);
                if (minRating > 0) cmd.Parameters.AddWithValue("@MinRating", minRating);

                cmd.Parameters.AddWithValue("@Offset", (pageIndex - 1) * PageSize);
                cmd.Parameters.AddWithValue("@PageSize", PageSize);

                if (!string.IsNullOrEmpty(cleanSearchQuery))
                {
                    string[] searchWords = cleanSearchQuery.Split(' ');
                    for (int i = 0; i < searchWords.Length; i++)
                        cmd.Parameters.AddWithValue("@Word" + i, searchWords[i]);
                }

                SqlDataAdapter sda = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                sda.Fill(dt);

                rptRestaurants.DataSource = dt;
                rptRestaurants.DataBind();

                rptRestaurants.Visible = true;
                pnlNoData.Visible = false;

                SetupPagination(totalRecords, pageIndex);
            }
            else
            {
                rptRestaurants.Visible = false;
                pnlNoData.Visible = true;
                rptPaging.Visible = false;
                liPrev.Visible = false;
                liNext.Visible = false;

                if (!string.IsNullOrEmpty(rawSearchQuery))
                    lblSearchResult.Text = "No results found for '" + rawSearchQuery + "'";
                else
                    lblSearchResult.Text = "No restaurants found.";
            }
        }
    }


    // ---------------- Helper functions ----------------

    public string GetCategoryLink(object catId)
    {
        var query = HttpUtility.ParseQueryString(Request.Url.Query);
        query.Set("catid", catId.ToString());
        query.Remove("page");
        return "restaurants.aspx?" + query.ToString();
    }

    public bool IsActiveCategory(object catId)
    {
        string currentCat = Request.QueryString["catid"];
        return currentCat != null && currentCat == catId.ToString();
    }

    public string GetImageUrl(object imgName, string basePath)
    {
        if (imgName == null) return "assets/images/placeholder.jpg";

        string img = imgName.ToString();
        if (string.IsNullOrWhiteSpace(img)) return "assets/images/placeholder.jpg";
        if (img.StartsWith("http") || img.Contains("/")) return img;

        return basePath + img;
    }

    private void SetupPagination(int totalRecords, int currentPage)
    {
        int totalPages = (int)Math.Ceiling((double)totalRecords / PageSize);
        if (totalPages <= 1)
        {
            rptPaging.Visible = false;
            liPrev.Visible = false;
            liNext.Visible = false;
            return;
        }

        rptPaging.Visible = true;
        liPrev.Visible = true;
        liNext.Visible = true;

        var query = HttpUtility.ParseQueryString(Request.Url.Query);
        query.Remove("page");
        string baseUrl = "restaurants.aspx?" + query.ToString() + "&page={0}";

        if (currentPage > 1)
        {
            lnkPrev.NavigateUrl = string.Format(baseUrl, currentPage - 1);
            liPrev.Attributes["class"] = "page-item";
        }
        else liPrev.Attributes["class"] = "page-item disabled";

        if (currentPage < totalPages)
        {
            lnkNext.NavigateUrl = string.Format(baseUrl, currentPage + 1);
            liNext.Attributes["class"] = "page-item";
        }
        else liNext.Attributes["class"] = "page-item disabled";

        List<object> pages = new List<object>();
        for (int i = 1; i <= totalPages; i++)
        {
            pages.Add(new { PageIndex = i, PageUrl = string.Format(baseUrl, i) });
        }

        rptPaging.DataSource = pages;
        rptPaging.DataBind();
    }

    protected void rptPaging_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            int pageIndex = 1;
            if (Request.QueryString["page"] != null) int.TryParse(Request.QueryString["page"], out pageIndex);

            HtmlGenericControl liPage = (HtmlGenericControl)e.Item.FindControl("liPage");
            int itemPageIndex = Convert.ToInt32(DataBinder.Eval(e.Item.DataItem, "PageIndex"));
            if (itemPageIndex == pageIndex)
                liPage.Attributes["class"] = "page-item active";
        }
    }

    // -------- Rating links --------
    public string GetRatingLink(int rating)
    {
        var query = HttpUtility.ParseQueryString(Request.Url.Query);
        query.Set("rating", rating.ToString());
        query.Remove("page");
        string qs = query.ToString();
        return string.IsNullOrEmpty(qs) ? "restaurants.aspx" : "restaurants.aspx?" + qs;
    }

    public string ClearRatingLink()
    {
        var query = HttpUtility.ParseQueryString(Request.Url.Query);
        query.Remove("rating");
        query.Remove("page");
        string qs = query.ToString();
        return string.IsNullOrEmpty(qs) ? "restaurants.aspx" : "restaurants.aspx?" + qs;
    }

    public string ClearPriceLink()
    {
        var query = HttpUtility.ParseQueryString(Request.Url.Query);
        query.Remove("min");
        query.Remove("max");
        query.Remove("page");
        string qs = query.ToString();
        return string.IsNullOrEmpty(qs) ? "restaurants.aspx" : "restaurants.aspx?" + qs;
    }

    // -------- Sort links --------
    public string GetSortLink(string sort)
    {
        var query = HttpUtility.ParseQueryString(Request.Url.Query);

        if (string.IsNullOrEmpty(sort)) query.Remove("sort");
        else query.Set("sort", sort);

        query.Remove("page");

        string qs = query.ToString();
        return string.IsNullOrEmpty(qs) ? "restaurants.aspx" : "restaurants.aspx?" + qs;
    }

    // -------- Active Filter Chips --------
    public class FilterChip
    {
        public string Text { get; set; }
        public string Url { get; set; }
    }

    private void BindActiveFilters()
    {
        List<FilterChip> chips = new List<FilterChip>();

        string q = Request.QueryString["q"];
        string cityId = Request.QueryString["cityid"];
        string cityName = Request.QueryString["cityname"];
        string catId = Request.QueryString["catid"];
        string rating = Request.QueryString["rating"];
        string min = Request.QueryString["min"];
        string max = Request.QueryString["max"];

        string type = Request.QueryString["type"];
        string lat = Request.QueryString["lat"];
        string lng = Request.QueryString["lng"];

        if (!string.IsNullOrWhiteSpace(q))
            chips.Add(new FilterChip { Text = "Search: " + q, Url = RemoveParams("q") });

        if (!string.IsNullOrWhiteSpace(cityId))
            chips.Add(new FilterChip { Text = "City: " + (!string.IsNullOrWhiteSpace(cityName) ? cityName : cityId), Url = RemoveParams("cityid", "cityname") });

        if (!string.IsNullOrWhiteSpace(catId))
            chips.Add(new FilterChip { Text = "Category", Url = RemoveParams("catid") });

        if (!string.IsNullOrWhiteSpace(rating))
            chips.Add(new FilterChip { Text = rating + "★ & above", Url = RemoveParams("rating") });

        if (!string.IsNullOrWhiteSpace(min) || !string.IsNullOrWhiteSpace(max))
        {
            string priceText = "Price: ";
            if (!string.IsNullOrWhiteSpace(min) && !string.IsNullOrWhiteSpace(max)) priceText += "₹" + min + " - ₹" + max;
            else if (!string.IsNullOrWhiteSpace(min)) priceText += "₹" + min + "+";
            else priceText += "Up to ₹" + max;

            chips.Add(new FilterChip { Text = priceText, Url = RemoveParams("min", "max") });
        }

        if (!string.IsNullOrWhiteSpace(type) && type == "nearby" && !string.IsNullOrWhiteSpace(lat) && !string.IsNullOrWhiteSpace(lng))
            chips.Add(new FilterChip { Text = "Nearby", Url = RemoveParams("type", "lat", "lng") });

        pnlActiveFilters.Visible = (chips.Count > 0);
        rptActiveFilters.DataSource = chips;
        rptActiveFilters.DataBind();
    }

    private string RemoveParams(params string[] keysToRemove)
    {
        var query = HttpUtility.ParseQueryString(Request.Url.Query);

        foreach (var k in keysToRemove)
            query.Remove(k);

        query.Remove("page");

        string qs = query.ToString();
        return string.IsNullOrEmpty(qs) ? "restaurants.aspx" : "restaurants.aspx?" + qs;
    }

    public bool IsOpenNow(object openTimeObj, object closeTimeObj)
    {
        if (openTimeObj == null || closeTimeObj == null) return false;

        TimeSpan openTime, closeTime;
        if (!TimeSpan.TryParse(openTimeObj.ToString(), out openTime)) return false;
        if (!TimeSpan.TryParse(closeTimeObj.ToString(), out closeTime)) return false;

        TimeSpan now = DateTime.Now.TimeOfDay;

        if (openTime < closeTime)
            return now >= openTime && now <= closeTime;

        return now >= openTime || now <= closeTime;
    }
}
