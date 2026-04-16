using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class menu : System.Web.UI.Page
{
    string strCon = ConfigurationManager.ConnectionStrings["myCon"].ConnectionString;
    int PageSize = 9; // Changed to 9 since grid is now 3x3

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindCategories();
            BindMenu();
        }
    }

    // --- 1. Sidebar Categories ---
    private void BindCategories()
    {
        using (SqlConnection con = new SqlConnection(strCon))
        {
            // Only fetch active categories that have dishes
            string query = @"SELECT DISTINCT c.CategoryID, c.CategoryName 
                             FROM tbl_Categories c
                             JOIN tbl_Restaurants r ON c.CategoryID = r.CategoryID
                             WHERE c.IsActive = 1 AND r.ApprovalStatus = 1";

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

    // --- 2. Main Menu Grid with Filters ---
    private void BindMenu()
    {
        int pageIndex = 1;
        if (Request.QueryString["page"] != null)
        {
            int.TryParse(Request.QueryString["page"], out pageIndex);
        }
        if (pageIndex < 1) pageIndex = 1;

        using (SqlConnection con = new SqlConnection(strCon))
        {
            con.Open();

            // Build Query dynamically based on Filter
            string whereCondition = "WHERE r.ApprovalStatus = 1 AND r.SignatureDish IS NOT NULL AND r.SignatureDish <> ''";

            if (Request.QueryString["cat"] != null)
            {
                whereCondition += " AND r.CategoryID = @catId";
            }

            // A. Get Total Count (for pagination)
            string countQuery = "SELECT COUNT(*) FROM tbl_Restaurants r " + whereCondition;
            SqlCommand cmdCount = new SqlCommand(countQuery, con);

            if (Request.QueryString["cat"] != null)
                cmdCount.Parameters.AddWithValue("@catId", Request.QueryString["cat"]);

            int totalRecords = (int)cmdCount.ExecuteScalar();

            // B. Get Data
            string query = @"SELECT r.RestaurantID, r.Name as RestaurantName, 
                                    r.SignatureDish, r.SignatureDishImage, 
                                    r.MinPrice, c.CategoryName 
                             FROM tbl_Restaurants r
                             INNER JOIN tbl_Categories c ON r.CategoryID = c.CategoryID "
                             + whereCondition +
                             @" ORDER BY r.RestaurantID DESC
                             OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY";

            SqlCommand cmd = new SqlCommand(query, con);

            if (Request.QueryString["cat"] != null)
                cmd.Parameters.AddWithValue("@catId", Request.QueryString["cat"]);

            cmd.Parameters.AddWithValue("@Offset", (pageIndex - 1) * PageSize);
            cmd.Parameters.AddWithValue("@PageSize", PageSize);

            using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
            {
                DataTable dt = new DataTable();
                sda.Fill(dt);
                lvMenu.DataSource = dt;
                lvMenu.DataBind();
            }

            // 3. Setup Pagination
            SetupPagination(totalRecords, pageIndex);
        }
    }

    // --- 3. Pagination Logic (Persist Category Filter) ---
    private void SetupPagination(int totalRecords, int currentPage)
    {
        int totalPages = (int)Math.Ceiling((double)totalRecords / PageSize);

        if (totalPages <= 1)
        {
            liPrev.Visible = false;
            liNext.Visible = false;
            rptPaging.Visible = false;
            return;
        }

        rptPaging.Visible = true;
        liPrev.Visible = true;
        liNext.Visible = true;

        // PREV Link
        if (currentPage > 1)
        {
            lnkPrev.NavigateUrl = GetPageUrl(currentPage - 1);
            liPrev.Attributes["class"] = "page-item";
        }
        else
        {
            liPrev.Attributes["class"] = "page-item disabled";
        }

        // NEXT Link
        if (currentPage < totalPages)
        {
            lnkNext.NavigateUrl = GetPageUrl(currentPage + 1);
            liNext.Attributes["class"] = "page-item";
        }
        else
        {
            liNext.Attributes["class"] = "page-item disabled";
        }

        // Page Numbers
        List<object> pages = new List<object>();
        for (int i = 1; i <= totalPages; i++)
        {
            pages.Add(new { PageIndex = i, PageText = i });
        }
        rptPaging.DataSource = pages;
        rptPaging.DataBind();
    }

    // Helper: Generates URL like "menu.aspx?cat=5&page=2"
    public string GetPageUrl(object pageIndex)
    {
        string url = "menu.aspx?page=" + pageIndex;
        if (Request.QueryString["cat"] != null)
        {
            url += "&cat=" + Request.QueryString["cat"];
        }
        return url;
    }

    // Helper: Highlights active category
    public string IsActiveCategory(object catId)
    {
        if (Request.QueryString["cat"] != null && Request.QueryString["cat"] == catId.ToString())
        {
            return "active";
        }
        return "";
    }

    protected void rptPaging_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            int pageIndex = 1;
            if (Request.QueryString["page"] != null)
                int.TryParse(Request.QueryString["page"], out pageIndex);

            HtmlGenericControl liPage = (HtmlGenericControl)e.Item.FindControl("liPage");
            int itemPageIndex = Convert.ToInt32(DataBinder.Eval(e.Item.DataItem, "PageIndex"));

            if (itemPageIndex == pageIndex)
            {
                liPage.Attributes["class"] = "page-item active";
            }
        }
    }

    public string GetImageUrl(object imgName)
    {
        string img = imgName.ToString();
        if (string.IsNullOrEmpty(img)) return "assets/images/placeholder.jpg";
        if (img.Contains("/")) return img;
        return "Images/dish/" + img;
    }
}