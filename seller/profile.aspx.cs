using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class seller_profile : System.Web.UI.Page
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
            BindCities();
            BindProfile();
        }
    }

    // 1. Dropdown mein Cities bharna
    private void BindCities()
    {
        using (SqlConnection con = new SqlConnection(strCon))
        {
            string query = "SELECT * FROM tbl_Cities ORDER BY CityName";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                con.Open();
                ddlCity.DataSource = cmd.ExecuteReader();
                ddlCity.DataTextField = "CityName";
                ddlCity.DataValueField = "CityID";
                ddlCity.DataBind();
            }
        }
        ddlCity.Items.Insert(0, new ListItem("Select City", "0"));
    }

    // 2. Profile Data Fetch karna
    private void BindProfile()
    {
        string sellerId = Session["SellerID"].ToString();

        using (SqlConnection con = new SqlConnection(strCon))
        {
            string query = "SELECT * FROM tbl_Sellers WHERE SellerID = @id";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@id", sellerId);
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                if (rdr.Read())
                {
                    string fullName = rdr["FullName"].ToString();

                    // --- NEW LOGIC START: First Letter Logic ---
                    if (!string.IsNullOrEmpty(fullName))
                    {
                        // Pehla akshar nikala aur Capital kar diya
                        lblAvatarLetter.Text = fullName.Substring(0, 1).ToUpper();
                    }
                    else
                    {
                        lblAvatarLetter.Text = "U"; // Default agar naam na ho to 'U' (User)
                    }
                    // --- NEW LOGIC END ---

                    lblDisplayName.Text = fullName;
                    lblDisplayEmail.Text = rdr["Email"].ToString();

                    // ... Baaki purana code same rahega ...
                    lblJoinDate.Text = Convert.ToDateTime(rdr["RegistrationDate"]).ToString("dd MMM yyyy");

                    // Form Fields
                    txtName.Text = fullName;
                    txtEmail.Text = rdr["Email"].ToString();
                    txtPhone.Text = rdr["Phone"].ToString();
                    txtAddress.Text = rdr["Address"].ToString();

                    if (rdr["CityID"] != DBNull.Value)
                    {
                        ddlCity.SelectedValue = rdr["CityID"].ToString();
                    }
                }
            }
        }
    }

    // 3. Data Update karna
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        string sellerId = Session["SellerID"].ToString();

        using (SqlConnection con = new SqlConnection(strCon))
        {
            string query = @"UPDATE tbl_Sellers 
                             SET FullName=@name, Phone=@phone, Address=@addr, CityID=@city 
                             WHERE SellerID=@id";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@name", txtName.Text.Trim());
                cmd.Parameters.AddWithValue("@phone", txtPhone.Text.Trim());
                cmd.Parameters.AddWithValue("@addr", txtAddress.Text.Trim());
                cmd.Parameters.AddWithValue("@city", ddlCity.SelectedValue);
                cmd.Parameters.AddWithValue("@id", sellerId);

                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        // Success Message & Refresh UI
        lblMsg.Text = "<span class='text-success fw-bold'><i class='fas fa-check-circle'></i> Profile Updated Successfully!</span>";

        // Update Card Display immediately
        lblDisplayName.Text = txtName.Text;
    }
}