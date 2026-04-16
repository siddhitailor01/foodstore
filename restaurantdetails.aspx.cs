using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls; // ✅ SEO Meta Tags ke liye zaroori namespace

public partial class restaurantdetails : System.Web.UI.Page
{
    string strCon = ConfigurationManager.ConnectionStrings["myCon"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["id"] != null)
            {
                int rId = Convert.ToInt32(Request.QueryString["id"]);
                BindRestaurantDetail(rId);
            }
            else
            {
                Response.Redirect("Restaurants.aspx");
            }
        }
    }

    // --- 1. FETCH RESTAURANT DETAILS & SET DYNAMIC SEO ---
    private void BindRestaurantDetail(int id)
    {
        using (SqlConnection con = new SqlConnection(strCon))
        {
            // Query same as before
            string query = @"SELECT r.*, c.CategoryName, ISNULL(a.AreaName, 'City Center') as AreaName,
                                    s.Phone as SellerPhone,
                                    ISNULL((SELECT AVG(CAST(Rating AS FLOAT)) FROM tbl_Reviews WHERE RestaurantID = r.RestaurantID AND IsApproved = 1), 0) as AvgRating,
                                    (SELECT COUNT(*) FROM tbl_Reviews WHERE RestaurantID = r.RestaurantID AND IsApproved = 1) as ReviewCount
                             FROM tbl_Restaurants r
                             INNER JOIN tbl_Categories c ON r.CategoryID = c.CategoryID
                             LEFT JOIN tbl_Areas a ON r.AreaID = a.AreaID
                             INNER JOIN tbl_Sellers s ON r.SellerID = s.SellerID
                             WHERE r.RestaurantID = @id AND r.ApprovalStatus = 1";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@id", id);
                using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    sda.Fill(dt);
                    lvRestaurantDetail.DataSource = dt;
                    lvRestaurantDetail.DataBind();

                    // ✅ DYNAMIC SEO LOGIC STARTS HERE
                    if (dt.Rows.Count > 0)
                    {
                        DataRow row = dt.Rows[0];
                        SetDynamicSEO(row);
                    }
                }
            }
        }
    }

    
    private void SetDynamicSEO(DataRow row)
    {
        string restName = row["Name"].ToString();
        string areaName = row["AreaName"].ToString();
        string category = row["CategoryName"].ToString();
        string desc = row["Description"].ToString();

        // Image URL Logic
        string imgPath = row["CoverImage"].ToString();
        string fullImageUrl = "https://www.foodstore.in/" + (imgPath.Contains("/") ? imgPath : "Images/cover/" + imgPath);

     
        Page.Title = string.Format("{0} - Order Online in {1} | FoodStore", restName, areaName);

    
        string metaDescText = string.Format("Order food online from {0} in {1}. View menu, prices, reviews, and phone number. Best {2} restaurant near you.", restName, areaName, category);
        AddMetaTag("description", metaDescText);

        string keywordsText = string.Format("{0}, {0} menu, {0} contact number, {1} in {2}, best restaurants in {2}, order food {2}", restName, category, areaName);
        AddMetaTag("keywords", keywordsText);

        AddOGTag("og:title", string.Format("{0} - Best {1} in {2}", restName, category, areaName));

        AddOGTag("og:description", string.Format("Check out the menu and reviews of {0}. Rated {1}/5 stars.", restName, row["AvgRating"]));

        AddOGTag("og:image", fullImageUrl);
        AddOGTag("og:url", HttpContext.Current.Request.Url.AbsoluteUri);
        AddOGTag("og:type", "restaurant.restaurant");

        HtmlLink canonicalLink = new HtmlLink();
        canonicalLink.Attributes.Add("rel", "canonical");
        canonicalLink.Href = HttpContext.Current.Request.Url.AbsoluteUri.Split('?')[0] + "?id=" + row["RestaurantID"];
        Page.Header.Controls.Add(canonicalLink);
    }

    private void AddMetaTag(string name, string content)
    {
        HtmlMeta meta = new HtmlMeta();
        meta.Name = name;
        meta.Content = content;
        Page.Header.Controls.Add(meta);
    }

    private void AddOGTag(string property, string content)
    {
        HtmlMeta meta = new HtmlMeta();
        meta.Attributes.Add("property", property);
        meta.Content = content;
        Page.Header.Controls.Add(meta);
    }

    protected void lvRestaurantDetail_ItemDataBound(object sender, ListViewItemEventArgs e)
    {
        if (e.Item.ItemType == ListViewItemType.DataItem)
        {
            DataRowView drv = (DataRowView)e.Item.DataItem;
            int restaurantID = Convert.ToInt32(drv["RestaurantID"]);

     PlaceHolder phFac = (PlaceHolder)e.Item.FindControl("phFacilities");
            Repeater rptFac = (Repeater)e.Item.FindControl("rptFacilities");
            string facilities = drv["Facilities"].ToString();

            if (!string.IsNullOrEmpty(facilities))
            {
                phFac.Visible = true;
                rptFac.DataSource = facilities.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                rptFac.DataBind();
            }
            else { phFac.Visible = false; }

            PlaceHolder phMenu = (PlaceHolder)e.Item.FindControl("phMenu");
            Repeater rptMenu = (Repeater)e.Item.FindControl("rptMenu");
            string menuImages = drv["MenuImages"].ToString();

            if (!string.IsNullOrEmpty(menuImages))
            {
                phMenu.Visible = true;
                rptMenu.DataSource = menuImages.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                rptMenu.DataBind();
            }
            else { phMenu.Visible = false; }

            PlaceHolder phMap = (PlaceHolder)e.Item.FindControl("phMap");
            Literal litMap = (Literal)e.Item.FindControl("litMap");
            string mapUrl = drv["MapEmbedUrl"].ToString();

            if (!string.IsNullOrEmpty(mapUrl))
            {
                phMap.Visible = true;
                litMap.Text = mapUrl.Contains("<iframe") ? mapUrl : "<iframe src='" + mapUrl + "' width='100%' height='300' style='border:0; border-radius:8px;' loading='lazy'></iframe>";
            }
            else { phMap.Visible = false; }

            Repeater rptReviews = (Repeater)e.Item.FindControl("rptReviews");
            Label lblNoReviews = (Label)e.Item.FindControl("lblNoReviews");

            using (SqlConnection con = new SqlConnection(strCon))
            {
                string reviewSql = "SELECT * FROM tbl_Reviews WHERE RestaurantID=@rid AND IsApproved=1 ORDER BY ReviewDate DESC";
                using (SqlCommand cmd = new SqlCommand(reviewSql, con))
                {
                    cmd.Parameters.AddWithValue("@rid", restaurantID);
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dtReviews = new DataTable();
                        sda.Fill(dtReviews);

                        if (dtReviews.Rows.Count > 0)
                        {
                            rptReviews.DataSource = dtReviews;
                            rptReviews.DataBind();
                            rptReviews.Visible = true;
                            lblNoReviews.Visible = false;
                        }
                        else
                        {
                            rptReviews.Visible = false;
                            lblNoReviews.Visible = true;
                        }
                    }
                }
            }

            if (Request.QueryString["msg"] == "success")
            {
                Label lblMsg = (Label)e.Item.FindControl("lblReviewMsg");
                Panel pnlForm = (Panel)e.Item.FindControl("pnlReviewForm");

                if (lblMsg != null && pnlForm != null)
                {
                    pnlForm.Visible = false; // Hide Form
                    lblMsg.Text = "<div class='alert alert-success mt-3'>Thank you! Your review has been submitted for approval.</div>";
                }
            }
        }
    }

    protected void lvRestaurantDetail_ItemCommand(object sender, ListViewCommandEventArgs e)
    {
        if (e.CommandName == "SubmitReview")
        {
            TextBox txtName = (TextBox)e.Item.FindControl("txtReviewName");
            TextBox txtMsg = (TextBox)e.Item.FindControl("txtReviewMsg");
            DropDownList ddlRate = (DropDownList)e.Item.FindControl("ddlRating");
            Label lblMsg = (Label)e.Item.FindControl("lblReviewMsg");

            if (string.IsNullOrEmpty(txtName.Text) || string.IsNullOrEmpty(txtMsg.Text))
            {
                lblMsg.Text = "<span class='text-danger'>Name and Review are required.</span>";
                return;
            }

            int restId = Convert.ToInt32(Request.QueryString["id"]);

            try
            {
                using (SqlConnection con = new SqlConnection(strCon))
                {
                    string query = @"INSERT INTO tbl_Reviews (RestaurantID, UserName, Rating, ReviewText, IsApproved) 
                                     VALUES (@rid, @name, @rate, @msg, 0)";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@rid", restId);
                        cmd.Parameters.AddWithValue("@name", txtName.Text.Trim());
                        cmd.Parameters.AddWithValue("@rate", ddlRate.SelectedValue);
                        cmd.Parameters.AddWithValue("@msg", txtMsg.Text.Trim());

                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
                Response.Redirect("restaurantdetails.aspx?id=" + restId + "&msg=success");
            }
            catch (Exception ex)
            {
                lblMsg.Text = "<span class='text-danger'>Error: " + ex.Message + "</span>";
            }
        }
    }

    public string GenerateStars(int rating)
    {
        string stars = "";
        for (int i = 0; i < rating; i++) stars += "<i class='ri-star-fill'></i>";
        for (int i = rating; i < 5; i++) stars += "<i class='ri-star-line'></i>";
        return stars;
    }

    public string GetImageUrl(object imgName, string folder)
    {
        string img = imgName.ToString();
        if (string.IsNullOrEmpty(img)) return "assets/images/placeholder.jpg";
        if (img.Contains("/")) return img;
        return folder + img;
    }

    protected void btnCall_Click(object sender, EventArgs e)
    {
        TrackLead("Call Click");
        string phone = "9876543210";
        Response.Redirect("tel:" + phone);
    }

    private void TrackLead(string actionType)
    {
        if (Request.QueryString["id"] != null)
        {
            string rId = Request.QueryString["id"];
            using (SqlConnection con = new SqlConnection(strCon))
            {
                string query = "INSERT INTO tbl_Leads (RestaurantID, ActionType, ActionDate) VALUES (@rid, @type, GETDATE())";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@rid", rId);
                    cmd.Parameters.AddWithValue("@type", actionType);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }
    }

    protected void btnSubmitReport_Click(object sender, EventArgs e)
    {
        if (Request.QueryString["id"] != null)
        {
            int rId = Convert.ToInt32(Request.QueryString["id"]);
            string reason = ddlReportReason.SelectedValue;
            string msg = txtReportMsg.Text.Trim();

            try
            {
                using (SqlConnection con = new SqlConnection(strCon))
                {
                    string query = @"INSERT INTO tbl_Reports (RestaurantID, ReportReason, UserMessage) 
                                     VALUES (@rid, @reason, @msg)";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@rid", rId);
                        cmd.Parameters.AddWithValue("@reason", reason);
                        cmd.Parameters.AddWithValue("@msg", msg);

                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
                txtReportMsg.Text = "";
                string script = "alert('Report submitted successfully. We will investigate this seller.'); window.location='restaurantdetails.aspx?id=" + rId + "';";
                ClientScript.RegisterStartupScript(this.GetType(), "ReportSuccess", script, true);
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error: " + ex.Message + "');</script>");
            }
        }
    }
}