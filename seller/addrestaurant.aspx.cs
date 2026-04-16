using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class seller_addrestaurant : System.Web.UI.Page
{
    string strCon = ConfigurationManager.ConnectionStrings["myCon"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["SellerID"] == null)
            {
                Response.Redirect("Login.aspx");
            }
            BindDropdowns();
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

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (txtName.Text == "" || ddlCity.SelectedValue == "0" || ddlCategory.SelectedValue == "0")
        {
            lblMsg.Text = "<div class='alert alert-danger'>Please fill all required details!</div>";
            return;
        }

        try
        {
            int sellerID = Convert.ToInt32(Session["SellerID"]);
            int cityID = Convert.ToInt32(ddlCity.SelectedValue);
            int areaID = GetOrCreateAreaID(txtArea.Text.Trim(), cityID);

            // Parse Coordinates
            decimal latitude = 0, longitude = 0;
            decimal.TryParse(txtLat.Text.Trim(), out latitude);
            decimal.TryParse(txtLng.Text.Trim(), out longitude);

            int newRestaurantID = 0;

            using (SqlConnection con = new SqlConnection(strCon))
            {
                con.Open();

                string query = @"INSERT INTO tbl_Restaurants 
                            (SellerID, CityID, AreaID, CategoryID, Name, Address, Landmark, Phone, OpenTime, CloseTime, 
                             MinPrice, MaxPrice, SignatureDish, Description, ApprovalStatus, CoverImage, SignatureDishImage, 
                             MenuImages, MapEmbedUrl, Facilities, OfferText, Latitude, Longitude) 
                            VALUES 
                            (@sid, @cid, @aid, @catid, @name, @addr, @land, @phone, @open, @close, 
                             @min, @max, @sigName, @desc, 0, '', '', '', '', '', @offer, @lat, @lng);
                            
                            SELECT CAST(SCOPE_IDENTITY() as int);";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@sid", sellerID);
                cmd.Parameters.AddWithValue("@cid", cityID);
                cmd.Parameters.AddWithValue("@aid", areaID);
                cmd.Parameters.AddWithValue("@catid", ddlCategory.SelectedValue);
                cmd.Parameters.AddWithValue("@name", txtName.Text.Trim());
                cmd.Parameters.AddWithValue("@addr", txtAddress.Text.Trim());
                cmd.Parameters.AddWithValue("@land", txtLandmark.Text.Trim());
                cmd.Parameters.AddWithValue("@phone", txtPhone.Text.Trim());
                cmd.Parameters.AddWithValue("@open", txtOpen.Text.Trim());
                cmd.Parameters.AddWithValue("@close", txtClose.Text.Trim());
                cmd.Parameters.AddWithValue("@min", txtMinPrice.Text == "" ? 0 : Convert.ToInt32(txtMinPrice.Text));
                cmd.Parameters.AddWithValue("@max", txtMaxPrice.Text == "" ? 0 : Convert.ToInt32(txtMaxPrice.Text));
                cmd.Parameters.AddWithValue("@sigName", txtSigDish.Text.Trim());
                cmd.Parameters.AddWithValue("@desc", txtDesc.Text.Trim());
                cmd.Parameters.AddWithValue("@offer", txtOffer.Text.Trim());

                if (latitude != 0) cmd.Parameters.AddWithValue("@lat", latitude);
                else cmd.Parameters.AddWithValue("@lat", DBNull.Value);

                if (longitude != 0) cmd.Parameters.AddWithValue("@lng", longitude);
                else cmd.Parameters.AddWithValue("@lng", DBNull.Value);

                newRestaurantID = (int)cmd.ExecuteScalar();
            }

            // Image Upload Logic
            if (newRestaurantID > 0)
            {
                string coverFilename = "";
                string dishFilename = "";
                string menuFilenames = "";
                string facilitiesStr = "";

                if (fuCoverImage.HasFile)
                {
                    string ext = Path.GetExtension(fuCoverImage.FileName).ToLower();
                    if (ext == ".jpg" || ext == ".png" || ext == ".jpeg")
                    {
                        string filename = "cover_" + newRestaurantID + ext;
                        string path = Server.MapPath("~/Images/cover/");
                        if (!Directory.Exists(path)) Directory.CreateDirectory(path);
                        fuCoverImage.SaveAs(path + filename);
                        coverFilename = filename;
                    }
                }

                if (fuSigImage.HasFile)
                {
                    string ext = Path.GetExtension(fuSigImage.FileName).ToLower();
                    if (ext == ".jpg" || ext == ".png" || ext == ".jpeg")
                    {
                        string filename = "dish_" + newRestaurantID + ext;
                        string path = Server.MapPath("~/Images/dish/");
                        if (!Directory.Exists(path)) Directory.CreateDirectory(path);
                        fuSigImage.SaveAs(path + filename);
                        dishFilename = filename;
                    }
                }

                if (fuMenu.HasFiles)
                {
                    List<string> menuList = new List<string>();
                    int count = 1;
                    string menuPath = Server.MapPath("~/Images/menu/");
                    if (!Directory.Exists(menuPath)) Directory.CreateDirectory(menuPath);

                    foreach (HttpPostedFile postedFile in fuMenu.PostedFiles)
                    {
                        string ext = Path.GetExtension(postedFile.FileName).ToLower();
                        if (ext == ".jpg" || ext == ".png" || ext == ".jpeg")
                        {
                            string filename = "menu_" + newRestaurantID + "_" + count + ext;
                            postedFile.SaveAs(menuPath + filename);
                            menuList.Add(filename);
                            count++;
                        }
                    }
                    menuFilenames = string.Join(",", menuList);
                }

                List<string> facilitiesList = new List<string>();
                foreach (ListItem item in cblFacilities.Items)
                {
                    if (item.Selected) facilitiesList.Add(item.Value);
                }
                if (facilitiesList.Count > 0) facilitiesStr = string.Join(",", facilitiesList);

                using (SqlConnection con = new SqlConnection(strCon))
                {
                    string updateQuery = @"UPDATE tbl_Restaurants SET 
                                         CoverImage = @cover, 
                                         SignatureDishImage = @dish,
                                         MenuImages = @menu, 
                                         Facilities = @facilities,
                                         MapEmbedUrl = @map
                                         WHERE RestaurantID = @rid";

                    SqlCommand cmdUpdate = new SqlCommand(updateQuery, con);
                    cmdUpdate.Parameters.AddWithValue("@cover", coverFilename);
                    cmdUpdate.Parameters.AddWithValue("@dish", dishFilename);
                    cmdUpdate.Parameters.AddWithValue("@menu", menuFilenames);
                    cmdUpdate.Parameters.AddWithValue("@facilities", facilitiesStr);
                    cmdUpdate.Parameters.AddWithValue("@map", txtMap.Text.Trim());
                    cmdUpdate.Parameters.AddWithValue("@rid", newRestaurantID);

                    con.Open();
                    cmdUpdate.ExecuteNonQuery();
                }

                // ✅✅ ADMIN EMAIL NOTIFICATION (NEW)
                try
                {
                    string cityName = ddlCity.SelectedItem.Text;
                    string categoryName = ddlCategory.SelectedItem.Text;

                    string subject = "New Restaurant Added (Pending Approval) - " + txtName.Text.Trim();

                    string body = @"
                        <h3>New Restaurant Submitted</h3>
                        <p><b>Restaurant ID:</b> " + newRestaurantID + @"</p>
                        <p><b>Name:</b> " + txtName.Text.Trim() + @"</p>
                        <p><b>City:</b> " + cityName + @"</p>
                        <p><b>Category:</b> " + categoryName + @"</p>
                        <p><b>Area:</b> " + txtArea.Text.Trim() + @"</p>
                        <p><b>Address:</b> " + txtAddress.Text.Trim() + @"</p>
                        <p><b>Landmark:</b> " + txtLandmark.Text.Trim() + @"</p>
                        <p><b>Phone:</b> " + txtPhone.Text.Trim() + @"</p>
                        <p><b>Open:</b> " + txtOpen.Text.Trim() + @"</p>
                        <p><b>Close:</b> " + txtClose.Text.Trim() + @"</p>
                        <p><b>Price Range:</b> ₹" + (txtMinPrice.Text == "" ? "0" : txtMinPrice.Text) + @" - ₹" + (txtMaxPrice.Text == "" ? "0" : txtMaxPrice.Text) + @"</p>
                        <p><b>Signature Dish:</b> " + txtSigDish.Text.Trim() + @"</p>
                        <p><b>Offer:</b> " + txtOffer.Text.Trim() + @"</p>
                        <p><b>Map:</b> " + txtMap.Text.Trim() + @"</p>
                        <p><b>Latitude:</b> " + txtLat.Text.Trim() + @"</p>
                        <p><b>Longitude:</b> " + txtLng.Text.Trim() + @"</p>
                        <hr/>
                        <p>Status: <b>Pending Approval</b></p>
                    ";

                    EmailHelper.SendNotificationToAdmin(subject, body);
                }
                catch { }
            }

            lblMsg.Text = "<div class='alert alert-success'>Restaurant submitted successfully! Waiting for Approval.</div>";
            ClearForm();
        }
        catch (Exception ex)
        {
            lblMsg.Text = "<div class='alert alert-danger'>Error: " + ex.Message + "</div>";
        }
    }

    private void ClearForm()
    {
        txtName.Text = ""; txtAddress.Text = ""; txtArea.Text = ""; txtLandmark.Text = "";
        txtPhone.Text = ""; txtOpen.Text = ""; txtClose.Text = ""; txtMinPrice.Text = ""; txtMaxPrice.Text = "";
        txtSigDish.Text = ""; txtDesc.Text = ""; txtMap.Text = ""; txtOffer.Text = "";
        txtLat.Text = ""; txtLng.Text = "";
        ddlCity.SelectedIndex = 0; ddlCategory.SelectedIndex = 0; cblFacilities.ClearSelection();
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
            if (result != null) areaId = Convert.ToInt32(result);
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
