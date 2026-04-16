using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class seller_register : System.Web.UI.Page
{
    string strCon = ConfigurationManager.ConnectionStrings["myCon"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindCities();
        }
    }

    private void BindCities()
    {
        using (SqlConnection con = new SqlConnection(strCon))
        {
            SqlCommand cmd = new SqlCommand("SELECT CityID, CityName FROM tbl_Cities", con);
            con.Open();
            ddlCity.DataSource = cmd.ExecuteReader();
            ddlCity.DataTextField = "CityName";
            ddlCity.DataValueField = "CityID";
            ddlCity.DataBind();
            ddlCity.Items.Insert(0, new ListItem("Select City", "0"));
        }
    }

    protected void btnRegister_Click(object sender, EventArgs e)
    {
        // Basic Validation
        if (txtName.Text == "" || txtEmail.Text == "" || ddlCity.SelectedValue == "0")
        {
            lblMsg.Text = "<span class='text-danger'>Please fill all fields!</span>";
            return;
        }

        try
        {
            using (SqlConnection con = new SqlConnection(strCon))
            {
                string checkQuery = "SELECT COUNT(*) FROM tbl_Sellers WHERE Email='" + txtEmail.Text + "'";
                SqlCommand checkCmd = new SqlCommand(checkQuery, con);
                con.Open();
                int exist = (int)checkCmd.ExecuteScalar();

                if (exist > 0)
                {
                    lblMsg.Text = "<span class='text-danger'>Email already registered!</span>";
                    return;
                }

                string query = @"INSERT INTO tbl_Sellers (FullName, Email, Password, Phone, Address, CityID, IsApproved) 
                                 VALUES (@Name, @Email, @Pass, @Phone, @Addr, @City, 0)";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Name", txtName.Text);
                cmd.Parameters.AddWithValue("@Email", txtEmail.Text);
                cmd.Parameters.AddWithValue("@Pass", txtPass.Text); 
                cmd.Parameters.AddWithValue("@Phone", txtPhone.Text);
                cmd.Parameters.AddWithValue("@Addr", txtAddress.Text);
                cmd.Parameters.AddWithValue("@City", ddlCity.SelectedValue);

                cmd.ExecuteNonQuery();

                // ---------------------------------------------------------
                // 3. YAHAN HUM ADMIN KO MESSAGE BHEJENGE (Using EmailHelper)
                // ---------------------------------------------------------
                string emailSubject = "New Seller Registration Alert";
                string emailBody = "Hello Admin,<br><br>" +
                                   "A new seller has registered on FoodStore.<br>" +
                                   "<b>Name:</b> " + txtName.Text + "<br>" +
                                   "<b>City:</b> " + ddlCity.SelectedItem.Text + "<br>" +
                                   "<b>Phone:</b> " + txtPhone.Text + "<br><br>" +
                                   "Please login to Admin Panel and approve/reject this request.";

                // Helper class ko call kiya
                EmailHelper.SendNotificationToAdmin(emailSubject, emailBody);

                // Success Message
                lblMsg.Text = "<div class='alert alert-success'>Registration Successful! Please wait for Admin Approval.</div>";
                ClearForm();
            }
        }
        catch (Exception ex)
        {
            lblMsg.Text = "<span class='text-danger'>Error: " + ex.Message + "</span>";
        }
    }

    private void ClearForm()
    {
        txtName.Text = "";
        txtEmail.Text = "";
        txtPhone.Text = "";
        txtAddress.Text = "";
        ddlCity.SelectedIndex = 0;
    }
}