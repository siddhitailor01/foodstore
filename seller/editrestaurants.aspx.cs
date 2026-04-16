using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class seller_editrestaurants : System.Web.UI.Page
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
            BindDropdowns();

            if (Request.QueryString["id"] != null)
            {
                int restId = Convert.ToInt32(Request.QueryString["id"]);
                LoadRestaurantData(restId);
            }
            else
            {
                Response.Redirect("MyRestaurants.aspx");
            }
        }
    }

    private void BindDropdowns()
    {
        using (SqlConnection con = new SqlConnection(strCon))
        {
            con.Open();
            SqlCommand cmdCity = new SqlCommand("SELECT CityID, CityName FROM tbl_Cities", con);
            ddlCity.DataSource = cmdCity.ExecuteReader();
            ddlCity.DataTextField = "CityName";
            ddlCity.DataValueField = "CityID";
            ddlCity.DataBind();
            ddlCity.Items.Insert(0, new ListItem("-- Select City --", "0"));
        }

        using (SqlConnection con = new SqlConnection(strCon))
        {
            con.Open();
            SqlCommand cmdCat = new SqlCommand("SELECT CategoryID, CategoryName FROM tbl_Categories", con);
            ddlCategory.DataSource = cmdCat.ExecuteReader();
            ddlCategory.DataTextField = "CategoryName";
            ddlCategory.DataValueField = "CategoryID";
            ddlCategory.DataBind();
            ddlCategory.Items.Insert(0, new ListItem("-- Select Type --", "0"));
        }
    }

    private void LoadRestaurantData(int id)
    {
        int sellerId = Convert.ToInt32(Session["SellerID"]);

        using (SqlConnection con = new SqlConnection(strCon))
        {
            // Select all columns including Latitude/Longitude
            string query = @"SELECT r.*, a.AreaName 
                             FROM tbl_Restaurants r 
                             LEFT JOIN tbl_Areas a ON r.AreaID = a.AreaID
                             WHERE r.RestaurantID = @rid AND r.SellerID = @sid";

            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@rid", id);
            cmd.Parameters.AddWithValue("@sid", sellerId);

            con.Open();
            SqlDataReader dr = cmd.ExecuteReader();

            if (dr.Read())
            {
                txtName.Text = dr["Name"].ToString();
                txtPhone.Text = dr["Phone"].ToString();
                txtAddress.Text = dr["Address"].ToString();
                txtLandmark.Text = dr["Landmark"].ToString();
                txtDesc.Text = dr["Description"].ToString();

                txtOpen.Text = dr["OpenTime"].ToString();
                txtClose.Text = dr["CloseTime"].ToString();
                txtMinPrice.Text = dr["MinPrice"].ToString();
                txtMaxPrice.Text = dr["MaxPrice"].ToString();

                txtSigDish.Text = dr["SignatureDish"].ToString();
                txtMap.Text = dr["MapEmbedUrl"].ToString();

                if (dr["AreaName"] != DBNull.Value)
                    txtArea.Text = dr["AreaName"].ToString();

                try { ddlCity.SelectedValue = dr["CityID"].ToString(); }
                catch { }
                try { ddlCategory.SelectedValue = dr["CategoryID"].ToString(); }
                catch { }

                // --- LOAD LATITUDE & LONGITUDE ---
                if (dr["Latitude"] != DBNull.Value)
                    txtLat.Text = dr["Latitude"].ToString();

                if (dr["Longitude"] != DBNull.Value)
                    txtLng.Text = dr["Longitude"].ToString();

                // --- LOAD FACILITIES ---
                string facilities = dr["Facilities"].ToString();
                if (!string.IsNullOrEmpty(facilities))
                {
                    string[] arr = facilities.Split(',');
                    foreach (ListItem item in cblFacilities.Items)
                    {
                        if (arr.Any(s => s.Trim() == item.Value))
                        {
                            item.Selected = true;
                        }
                    }
                }

                if (dr["OfferText"] != DBNull.Value)
                {
                    txtOffer.Text = dr["OfferText"].ToString();
                }

                // --- IMAGES PREVIEW ---
                hfCoverImage.Value = dr["CoverImage"].ToString();
                hfDishImage.Value = dr["SignatureDishImage"].ToString();
                hfMenuImages.Value = dr["MenuImages"].ToString();

                string dbCover = dr["CoverImage"].ToString();
                if (!string.IsNullOrEmpty(dbCover))
                {
                    imgCoverPreview.ImageUrl = dbCover.Contains("/") ? ResolveUrl(dbCover) : ResolveUrl("~/Images/cover/" + dbCover);
                }

                string dbDish = dr["SignatureDishImage"].ToString();
                if (!string.IsNullOrEmpty(dbDish))
                {
                    imgDishPreview.ImageUrl = dbDish.Contains("/") ? ResolveUrl(dbDish) : ResolveUrl("~/Images/dish/" + dbDish);
                }
            }
            else
            {
                Response.Redirect("MyRestaurants.aspx");
            }
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        try
        {
            int restId = Convert.ToInt32(Request.QueryString["id"]);
            int cityID = Convert.ToInt32(ddlCity.SelectedValue);
            int catID = Convert.ToInt32(ddlCategory.SelectedValue);
            int areaID = GetOrCreateAreaID(txtArea.Text.Trim(), cityID);

            // --- 1. HANDLE LATITUDE & LONGITUDE ---
            decimal latitude = 0;
            decimal longitude = 0;
            decimal.TryParse(txtLat.Text.Trim(), out latitude);
            decimal.TryParse(txtLng.Text.Trim(), out longitude);

            // --- 2. IMAGE UPLOAD LOGIC ---
            string coverPath = hfCoverImage.Value;
            if (fuCoverImage.HasFile)
            {
                string ext = Path.GetExtension(fuCoverImage.FileName).ToLower();
                if (ext == ".jpg" || ext == ".png" || ext == ".jpeg")
                {
                    string filename = "restaurant_" + restId + ext;
                    string path = Server.MapPath("~/Images/cover/");
                    if (!Directory.Exists(path)) Directory.CreateDirectory(path);
                    fuCoverImage.SaveAs(path + filename);
                    coverPath = filename;
                }
            }

            string dishPath = hfDishImage.Value;
            if (fuSigImage.HasFile)
            {
                string ext = Path.GetExtension(fuSigImage.FileName).ToLower();
                if (ext == ".jpg" || ext == ".png" || ext == ".jpeg")
                {
                    string filename = "dish_" + restId + ext;
                    string path = Server.MapPath("~/Images/dish/");
                    if (!Directory.Exists(path)) Directory.CreateDirectory(path);
                    fuSigImage.SaveAs(path + filename);
                    dishPath = filename;
                }
            }

            string menuPath = hfMenuImages.Value;
            if (fuMenu.HasFiles)
            {
                List<string> menuList = new List<string>();
                int count = 1;
                string path = Server.MapPath("~/Images/menu/");
                if (!Directory.Exists(path)) Directory.CreateDirectory(path);

                foreach (HttpPostedFile postedFile in fuMenu.PostedFiles)
                {
                    string ext = Path.GetExtension(postedFile.FileName).ToLower();
                    if (ext == ".jpg" || ext == ".png" || ext == ".jpeg")
                    {
                        string filename = "menu_" + restId + "_" + count + ext;
                        postedFile.SaveAs(path + filename);
                        menuList.Add(filename);
                        count++;
                    }
                }
                menuPath = string.Join(",", menuList);
            }

            // --- 3. FACILITIES STRING ---
            List<string> facilitiesList = new List<string>();
            foreach (ListItem item in cblFacilities.Items)
            {
                if (item.Selected) facilitiesList.Add(item.Value);
            }
            string facilitiesStr = string.Join(", ", facilitiesList);

            // --- 4. UPDATE DATABASE ---
            using (SqlConnection con = new SqlConnection(strCon))
            {
                string query = @"UPDATE tbl_Restaurants SET 
                            Name=@name, Phone=@phone, CityID=@cid, CategoryID=@catid, AreaID=@aid,
                            Address=@addr, Landmark=@land, OpenTime=@open, CloseTime=@close,
                            MinPrice=@min, MaxPrice=@max, SignatureDish=@sigName, Description=@desc,
                            CoverImage=@cover, SignatureDishImage=@dish,
                            MenuImages=@menu, Facilities=@facilities, MapEmbedUrl=@map,
                            OfferText=@offer,
                            Latitude=@lat, Longitude=@lng
                            WHERE RestaurantID=@rid";

                SqlCommand cmd = new SqlCommand(query, con);

                cmd.Parameters.AddWithValue("@name", txtName.Text.Trim());
                cmd.Parameters.AddWithValue("@phone", txtPhone.Text.Trim());
                cmd.Parameters.AddWithValue("@cid", cityID);
                cmd.Parameters.AddWithValue("@catid", catID);
                cmd.Parameters.AddWithValue("@aid", areaID);
                cmd.Parameters.AddWithValue("@addr", txtAddress.Text.Trim());
                cmd.Parameters.AddWithValue("@land", txtLandmark.Text.Trim());
                cmd.Parameters.AddWithValue("@open", txtOpen.Text.Trim());
                cmd.Parameters.AddWithValue("@close", txtClose.Text.Trim());

                int minP = 0, maxP = 0;
                int.TryParse(txtMinPrice.Text, out minP);
                int.TryParse(txtMaxPrice.Text, out maxP);
                cmd.Parameters.AddWithValue("@min", minP);
                cmd.Parameters.AddWithValue("@max", maxP);

                cmd.Parameters.AddWithValue("@sigName", txtSigDish.Text.Trim());
                cmd.Parameters.AddWithValue("@desc", txtDesc.Text.Trim());

                // New Fields
                cmd.Parameters.AddWithValue("@cover", coverPath);
                cmd.Parameters.AddWithValue("@dish", dishPath);
                cmd.Parameters.AddWithValue("@menu", menuPath);
                cmd.Parameters.AddWithValue("@facilities", facilitiesStr);
                cmd.Parameters.AddWithValue("@map", txtMap.Text.Trim());
                cmd.Parameters.AddWithValue("@offer", txtOffer.Text.Trim());

                // Update Lat/Lng (Handle 0 or empty values)
                if (latitude != 0) cmd.Parameters.AddWithValue("@lat", latitude);
                else cmd.Parameters.AddWithValue("@lat", DBNull.Value);

                if (longitude != 0) cmd.Parameters.AddWithValue("@lng", longitude);
                else cmd.Parameters.AddWithValue("@lng", DBNull.Value);

                cmd.Parameters.AddWithValue("@rid", restId);

                con.Open();
                int rows = cmd.ExecuteNonQuery();

                if (rows > 0)
                {
                    // Success Message
                    lblMsg.Text = "<div class='alert alert-success'>Restaurant Updated Successfully! <a href='MyRestaurants.aspx'>Go Back</a></div>";

                    // Optional: Redirect immediately
                    // Response.Redirect("MyRestaurants.aspx");
                }
                else
                {
                    lblMsg.Text = "<div class='alert alert-warning'>Update Failed! Check ID.</div>";
                }
            }
        }
        catch (Exception ex)
        {
            lblMsg.Text = "<div class='alert alert-danger'>Error: " + ex.Message + "</div>";
        }
    }

    private int GetOrCreateAreaID(string areaName, int cityId)
    {
        if (string.IsNullOrEmpty(areaName)) return 0;

        int areaId = 0;
        using (SqlConnection con = new SqlConnection(strCon))
        {
            con.Open();
            SqlCommand cmdCheck = new SqlCommand("SELECT AreaID FROM tbl_Areas WHERE AreaName=@name AND CityID=@city", con);
            cmdCheck.Parameters.AddWithValue("@name", areaName);
            cmdCheck.Parameters.AddWithValue("@city", cityId);
            object result = cmdCheck.ExecuteScalar();

            if (result != null)
            {
                areaId = Convert.ToInt32(result);
            }
            else
            {
                SqlCommand cmdInsert = new SqlCommand("INSERT INTO tbl_Areas (AreaName, CityID) VALUES (@name, @city); SELECT SCOPE_IDENTITY();", con);
                cmdInsert.Parameters.AddWithValue("@name", areaName);
                cmdInsert.Parameters.AddWithValue("@city", cityId);
                areaId = Convert.ToInt32(cmdInsert.ExecuteScalar());
            }
        }
        return areaId;
    }
}