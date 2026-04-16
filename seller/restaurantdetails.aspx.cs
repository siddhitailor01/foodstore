using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class seller_restaurantdetails : System.Web.UI.Page
{
    string strCon = ConfigurationManager.ConnectionStrings["myCon"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["SellerID"] == null)
        {
            Response.Redirect("Login.aspx");
        }

        if (!IsPostBack)
        {
            if (Request.QueryString["id"] != null)
            {
                int restId = Convert.ToInt32(Request.QueryString["id"]);
                LoadDetails(restId);
            }
            else
            {
                Response.Redirect("MyRestaurants.aspx");
            }
        }
    }

    private void LoadDetails(int id)
    {
        int sellerId = Convert.ToInt32(Session["SellerID"]);

        using (SqlConnection con = new SqlConnection(strCon))
        {
            string query = @"SELECT r.*, c.CityName, cat.CategoryName, ISNULL(a.AreaName, '-') as AreaName 
                             FROM tbl_Restaurants r 
                             JOIN tbl_Cities c ON r.CityID = c.CityID
                             JOIN tbl_Categories cat ON r.CategoryID = cat.CategoryID
                             LEFT JOIN tbl_Areas a ON r.AreaID = a.AreaID
                             WHERE r.RestaurantID = @rid AND r.SellerID = @sid";

            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@rid", id);
            cmd.Parameters.AddWithValue("@sid", sellerId);

            con.Open();
            SqlDataReader dr = cmd.ExecuteReader();

            if (dr.Read())
            {
                // --- Basic Info ---
                lblName.Text = dr["Name"].ToString();
                lblCityArea.Text = dr["AreaName"].ToString() + ", " + dr["CityName"].ToString();
                lblCategory.Text = dr["CategoryName"].ToString();
                lblDesc.Text = dr["Description"].ToString();
                lblAddress.Text = dr["Address"].ToString();
                lblLandmark.Text = dr["Landmark"].ToString();
                lblPhone.Text = dr["Phone"].ToString();
                lblTiming.Text = dr["OpenTime"].ToString() + " to " + dr["CloseTime"].ToString();
                lblMinPrice.Text = dr["MinPrice"].ToString();
                lblMaxPrice.Text = dr["MaxPrice"].ToString();
                lblDishName.Text = dr["SignatureDish"].ToString();

                // --- 1. FACILITIES LOGIC ---
                string facilities = dr["Facilities"].ToString();
                if (!string.IsNullOrEmpty(facilities))
                {
                    // Split comma separated string into array
                    string[] facList = facilities.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    rptFacilities.DataSource = facList;
                    rptFacilities.DataBind();
                }
                else
                {
                    lblNoFacilities.Visible = true;
                }

                // --- 2. MENU IMAGES LOGIC ---
                string menuFiles = dr["MenuImages"].ToString();
                if (!string.IsNullOrEmpty(menuFiles))
                {
                    // Split filenames into array
                    string[] menuList = menuFiles.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    rptMenu.DataSource = menuList;
                    rptMenu.DataBind();
                }

                // --- 3. MAP LOGIC ---
                string mapUrl = dr["MapEmbedUrl"].ToString();
                if (!string.IsNullOrEmpty(mapUrl))
                {
                    // Check if user pasted full iframe or just link
                    if (mapUrl.Contains("<iframe"))
                    {
                        litMap.Text = mapUrl; // Full code
                    }
                    else
                    {
                        // Just src link, wrap it
                        litMap.Text = "<iframe src='" + mapUrl + "' width='100%' height='250' style='border:0;' allowfullscreen='' loading='lazy'></iframe>";
                    }
                }
                else
                {
                    litMap.Text = "<p class='text-muted pt-5'>Map not available</p>";
                }

                // --- IMAGES HANDLING (Cover & Dish) ---
                string coverFile = dr["CoverImage"].ToString();
                if (!string.IsNullOrEmpty(coverFile))
                {
                    imgCover.ImageUrl = coverFile.Contains("/") ? ResolveUrl(coverFile) : ResolveUrl("~/Images/cover/" + coverFile);
                }
                else
                {
                    imgCover.ImageUrl = ResolveUrl("~/Images/placeholder.png");
                }

                string dishFile = dr["SignatureDishImage"].ToString();
                if (!string.IsNullOrEmpty(dishFile))
                {
                    imgDish.ImageUrl = dishFile.Contains("/") ? ResolveUrl(dishFile) : ResolveUrl("~/Images/dish/" + dishFile);
                }
                else
                {
                    imgDish.ImageUrl = ResolveUrl("~/Images/placeholder-dish.png");
                }

                // --- STATUS BADGE ---
                int status = Convert.ToInt32(dr["ApprovalStatus"]);
                if (status == 1)
                    lblStatusBadge.Text = "<span class='badge bg-success'>Live / Approved</span>";
                else if (status == 2)
                    lblStatusBadge.Text = "<span class='badge bg-danger'>Rejected</span>";
                else
                    lblStatusBadge.Text = "<span class='badge bg-warning text-dark'>Pending Approval</span>";

                // --- EDIT LINK ---
                lnkEdit.NavigateUrl = "editrestaurants.aspx?id=" + id;
            }
            else
            {
                lblMsg.Text = "<div class='alert alert-danger'>Restaurant not found or access denied.</div>";
                pnlDetails.Visible = false;
            }
        }
    }
}