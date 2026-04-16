using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;

public partial class admin_RestaurantDetails : System.Web.UI.Page
{
    string strCon = ConfigurationManager.ConnectionStrings["myCon"].ConnectionString;
    int rId = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["AdminID"] == null)
        {
            Response.Redirect("Login.aspx");
        }

        if (Request.QueryString["id"] != null)
        {
            rId = Convert.ToInt32(Request.QueryString["id"]);
            if (!IsPostBack)
            {
                LoadRestaurantDetails();
            }
        }
        else
        {
            Response.Redirect("AllRestaurants.aspx");
        }
    }

    private void LoadRestaurantDetails()
    {
        using (SqlConnection con = new SqlConnection(strCon))
        {
            string query = @"
                SELECT r.*, 
                       s.FullName as OwnerName, s.Phone as OwnerPhone,
                       c.CityName, 
                       cat.CategoryName, 
                       ISNULL(a.AreaName, '-') as AreaName
                FROM tbl_Restaurants r
                INNER JOIN tbl_Sellers s ON r.SellerID = s.SellerID
                INNER JOIN tbl_Cities c ON r.CityID = c.CityID
                INNER JOIN tbl_Categories cat ON r.CategoryID = cat.CategoryID
                LEFT JOIN tbl_Areas a ON r.AreaID = a.AreaID
                WHERE r.RestaurantID = @id";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@id", rId);
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();

                if (rdr.Read())
                {
                    lblRestNameHeader.Text = rdr["Name"].ToString();
                    lblCityHeader.Text = rdr["CityName"].ToString();
                    
                    int status = Convert.ToInt32(rdr["ApprovalStatus"]);
                    if (status == 0) { lblStatusBadge.Text = "Pending"; lblStatusBadge.CssClass += " st-pending"; }
                    else if (status == 1) { lblStatusBadge.Text = "Active"; lblStatusBadge.CssClass += " st-active"; }
                    else { lblStatusBadge.Text = "Rejected"; lblStatusBadge.CssClass += " st-rejected"; }

                    if (rdr["CoverImage"] != DBNull.Value && rdr["CoverImage"].ToString() != "")
                        imgCover.ImageUrl = "~/Images/cover/" + rdr["CoverImage"].ToString();

                    if (rdr["SignatureDishImage"] != DBNull.Value && rdr["SignatureDishImage"].ToString() != "")
                        imgSignatureDish.ImageUrl = "~/Images/menu/" + rdr["SignatureDishImage"].ToString();

                    lblOwnerName.Text = rdr["OwnerName"].ToString();
                    lblPhone.Text = rdr["Phone"].ToString();
                    lblCategory.Text = rdr["CategoryName"].ToString();
                    lblArea.Text = rdr["AreaName"].ToString();
                    lblTime.Text = rdr["OpenTime"] + " - " + rdr["CloseTime"];
                    lblPrice.Text = rdr["MinPrice"] + " - " + rdr["MaxPrice"];

                    lblDescription.Text = rdr["Description"].ToString();
                    lblSignatureDish.Text = rdr["SignatureDish"].ToString();
                    lblOffer.Text = rdr["OfferText"] != DBNull.Value ? rdr["OfferText"].ToString() : "No Current Offers";

                    lblAddress.Text = rdr["Address"].ToString();
                    lblLandmark.Text = rdr["Landmark"].ToString();
                    
                    string mapData = rdr["MapEmbedUrl"].ToString().Trim();

                    if (!string.IsNullOrEmpty(mapData))
                    {
                        if (mapData.StartsWith("<iframe") || mapData.StartsWith("&lt;iframe"))
                        {
                            if (!mapData.Contains("width='100%'"))
                            {
                                mapData = mapData.Replace("width=\"600\"", "width=\"100%\"").Replace("width='600'", "width='100%'");
                            }
                            litMap.Text = mapData;
                        }
                        // Check 2: Agar sirf URL hai (e.g. https://google.com/maps/embed...)
                        else
                        {
                            litMap.Text = String.Format("<iframe src='{0}' width='100%' height='250' style='border:0; border-radius:8px;' loading='lazy' allowfullscreen></iframe>", mapData);
                        }
                    }
                    else
                    {
                        litMap.Text = "<div class='text-center p-5 bg-light text-muted border rounded'>No location map available.</div>";
                    }
                    string facilities = rdr["Facilities"].ToString();
                    if (!string.IsNullOrEmpty(facilities))
                    {
                        rptFacilities.DataSource = facilities.Split(',');
                        rptFacilities.DataBind();
                    }

                    string menuImgs = rdr["MenuImages"].ToString();
                    if (!string.IsNullOrEmpty(menuImgs))
                    {
                        List<string> menuList = new List<string>(menuImgs.Split(','));
                        rptMenu.DataSource = menuList;
                        rptMenu.DataBind();
                    }
                    else
                    {
                        lblNoMenu.Visible = true;
                    }
                }
            }
        }
    }

    protected void btnApprove_Click(object sender, EventArgs e)
    {
        UpdateStatus(1);
        lblMsg.Text = "<div class='alert alert-success'>Restaurant Approved Successfully!</div>";
        LoadRestaurantDetails(); 
    }

    // Reject Button Logic
    protected void btnReject_Click(object sender, EventArgs e)
    {
        UpdateStatus(2); 
        lblMsg.Text = "<div class='alert alert-danger'>Restaurant Rejected.</div>";
        LoadRestaurantDetails();
    }

    private void UpdateStatus(int status)
    {
        using (SqlConnection con = new SqlConnection(strCon))
        {
            string query = "UPDATE tbl_Restaurants SET ApprovalStatus = @s WHERE RestaurantID = @id";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@s", status);
            cmd.Parameters.AddWithValue("@id", rId);
            con.Open();
            cmd.ExecuteNonQuery();
        }
    }
}